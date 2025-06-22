package com.itwillbs.service;

// --- 필요한 모든 import 문 ---
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.cloud.vertexai.VertexAI;
import com.google.cloud.vertexai.api.Blob; // [추가] Blob 클래스 import
import com.google.cloud.vertexai.api.Candidate;
import com.google.cloud.vertexai.api.Content;
import com.google.cloud.vertexai.api.GenerateContentResponse;
import com.google.cloud.vertexai.api.GenerationConfig;
import com.google.cloud.vertexai.api.Part;
import com.google.cloud.vertexai.generativeai.GenerativeModel;
import com.google.cloud.vertexai.generativeai.ResponseHandler;
import com.google.protobuf.ByteString;
import com.itwillbs.domain.PointVO;
import com.itwillbs.domain.ReceiptVO;
import com.itwillbs.dto.ReceiptDTO;
import com.itwillbs.dto.ReceiptItemDTO;
import com.itwillbs.persistence.MemberDAO;
import com.itwillbs.persistence.PointHistoryDAO;
import com.itwillbs.persistence.ReceiptDAO;
import lombok.RequiredArgsConstructor;

import org.slf4j.Logger;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.security.MessageDigest;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
@RequiredArgsConstructor // final 필드에 대한 생성자를 자동으로 생성합니다.
public class ReceiptServiceImpl implements ReceiptService {

    // Bean으로 주입받는 의존성은 final로 선언하여 불변성을 보장합니다.
    private final ReceiptDAO receiptDAO;
    private final ObjectMapper objectMapper;

    // @Value로 주입받는 값은 필드 주입 방식을 사용합니다.
    @Value("${upload.path}")
    private String uploadPath;

    @Value("${gcp.project-id}")
    private String gcpProjectId;

    
    @Override
    @Transactional(rollbackFor = Exception.class) // 모든 예외 발생 시 롤백
    public ReceiptVO processAndSaveReceipt(MultipartFile file, int member_idx) throws Exception {

        // 1. 파일 해시 생성 및 중복 확인
        String fileHash = generateFileHash(file);
        if (receiptDAO.countByFileHash(fileHash) > 0) {
            throw new IllegalStateException("동일한 내용의 파일이 이미 등록되어 있습니다.");
        }

        // 2. 물리적 파일 저장
        String savedFilename = saveFileToServer(file);

        // 3. Gemini API 호출하여 영수증 정보 추출
        byte[] imageBytes = file.getBytes();
        ReceiptDTO ocrDto = callGeminiApi(imageBytes, file.getContentType());
        if (ocrDto == null) {
            throw new RuntimeException("영수증 정보를 추출하는 데 실패했습니다. 이미지 품질이나 형식을 확인해주세요.");
        }
        
       System.out.println(ocrDto);

        // 4. 최종 VO 객체 생성 및 모든 정보 설정
        ReceiptVO finalVO = createReceiptVO(file, ocrDto, member_idx, savedFilename, fileHash);

                
        // 5. DB에 영수증 정보 저장
        receiptDAO.insertReceipt(finalVO);
        
        
        // ==========================================================
        // [수정] 포인트 적립 로직 전체 수정
        // 6. 저장된 영수증 금액을 기준으로 포인트 계산 및 적립
        // ==========================================================
        int ocrAmount = finalVO.getOcr_amount();
        if (ocrAmount > 0) {
            // 5% 포인트 계산 (소수점 버림)
            int pointsToCredit = (int) (ocrAmount * 0.05);

            if (pointsToCredit > 0) {
                // 1. 회원의 현재 포인트를 DB에서 조회합니다.
                int currentPoints = PointHistoryDAO.selectMemberPoints(member_idx);

                // 2. 현재 포인트와 신규 포인트를 더해 최종 누적 포인트를 계산합니다.
                int newTotalPoints = currentPoints + pointsToCredit;

                // 3. PointVO 객체를 생성하고 올바른 값들을 설정합니다.
                PointVO pointVO = new PointVO();
                pointVO.setMember_idx(member_idx);
                pointVO.setChange_amount(pointsToCredit);   // 이번에 '변동된' 포인트
                pointVO.setPoint_amount(newTotalPoints);      // [수정] '누적된 최종' 포인트
                pointVO.setChange_reason("영수증 인증 적립");

                // 4. 포인트 내역(history)을 DB에 저장합니다.
                PointHistoryDAO.insertReceiptPoint(pointVO);
                
                // 5. 컨트롤러로 반환할 finalVO 객체에 적립된 포인트 값을 설정합니다.
                finalVO.setEarnedPoints(pointsToCredit);
                
                // 6. 실제 회원 테이블의 총 포인트를 안전하게 업데이트합니다.
                 PointHistoryDAO.updateMemberTotalPoints(member_idx, pointsToCredit);
            }
        }
        
       return finalVO;
    }

    
    // --- Private 헬퍼 메서드들 ---

    /**
     * 최종적으로 DB에 저장할 ReceiptVO 객체를 생성하고 모든 정보를 설정합니다.
     */
    private ReceiptVO createReceiptVO(MultipartFile file, ReceiptDTO ocrDto, int memberIdx, String savedFilename, String fileHash) {
        ReceiptVO finalVO = new ReceiptVO();

        // 파일 기본 정보
        finalVO.setMember_idx(memberIdx);
        finalVO.setOriginalfilename(file.getOriginalFilename());
        finalVO.setSavedfilename(savedFilename);
        finalVO.setFilepath(new File(uploadPath, savedFilename).getAbsolutePath());
        finalVO.setFile_size((int) file.getSize());
        finalVO.setFile_type(file.getContentType());
        finalVO.setFileHash(fileHash);
        finalVO.setItems(ocrDto.getItems());
        

        // OCR 결과 정보
        finalVO.setOcr_store(ocrDto.getSeller());
        
        String totalTitle="";
        for(ReceiptItemDTO recDTO:ocrDto.getItems()) {
        	totalTitle += recDTO.getBookTitle() + "/";
        }
               
        finalVO.setOcr_booktitle(totalTitle);
        finalVO.setApprovalnumber(ocrDto.getApprovalNumber());

        finalVO.setOcr_amount(ocrDto.getTotalPrice());
        
               
       

        // 날짜 정보 처리 안정성 강화
        String dateStr = ocrDto.getPurchaseDate();
        if (dateStr != null && !dateStr.isEmpty()) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                Date parsedDate = sdf.parse(dateStr);
                finalVO.setOcr_date(new java.sql.Timestamp(parsedDate.getTime()));
            } catch (ParseException e) {
                // 날짜 파싱 실패 시 에러 로그를 남기고, DB에는 null로 저장됨
                System.err.println("날짜 형식 파싱 실패: " + dateStr + ". 에러: " + e.getMessage());
            }
        }

        finalVO.setUpload_status("SUCCESS"); // 업로드 상태
        return finalVO;
    }

    /**
     * 파일을 서버의 지정된 경로에 저장합니다.
     */
    private String saveFileToServer(MultipartFile file) throws IOException {
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        String savedFilename = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();
        file.transferTo(new File(uploadPath, savedFilename));
        return savedFilename;
    }

    /**
     * 파일의 내용으로 SHA-256 해시를 생성합니다.
     */
    private String generateFileHash(MultipartFile file) throws Exception {
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] hash = digest.digest(file.getBytes());
        StringBuilder hexString = new StringBuilder();
        for (byte b : hash) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) hexString.append('0');
            hexString.append(hex);
        }
        return hexString.toString();
    }

    /**
     * Google Gemini API를 호출하여 이미지에서 텍스트 정보를 추출합니다.
     */
    private ReceiptDTO callGeminiApi(byte[] imageBytes, String mimeType) throws Exception {
        String projectId = "gen-lang-client-0137886470"; // [필수] 자신의 프로젝트 ID로 변경
        String location = "us-central1";              // 미국
        String modelName = "gemini-2.0-flash-001";         // 사용할 모델

        String promptText = "당신은 도서구매 영수증 분석 전문가입니다. 주어진 영수증 이미지에서 다음 정보를 JSON 형식으로 정확히 추출해주세요 : "
        										+" - 교보문고, 영풍문고, YES24, 알라딘, 인터파크, 반디앤루니스 단어가 판매처 이름으로 들어가 있거나 서점이라는 단어가 들어가 있는 영수증이라면 아래와 같은 명령을 실행하라." 
        										+ "1. 'seller': 서점 또는 상점 이름 "
        										+ "2. 'purchaseDate': 구매 날짜 (반드시<y_bin_46>-MM-DD 형식) "
        										+ "3. 'approvalNumber': 카드 승인 번호 "
        		 								+ "4. 'totalPrice': '총금액' 또는 '결제금액'에 해당하는 최종 결제 금액 (문자나 콤마 없이 오직 숫자만) "
        		                                 + "5. 'items': 구매한 모든 상품 목록을 담는 배열(Array). 각 상품은 다음 정보를 포함하는 별개의 객체(Object)로 분류해야 합니다: " 
                                                 + "- 'bookTitle': 개별 책 제목 " 
        		 								 + "- 'quantity': 수량 (숫자만) "
        		 								 + "- 'price': 해당 상품의 금액 (숫자만) "
        		                                 + "만약 특정 최상위 항목(seller, purchaseDate 등)을 찾을 수 없다면, 오류발생처리로 설정해주세요. " 
        		                                 + "절대로 설명이나 추가적인 텍스트 없이 순수한 JSON 객체만 응답해야 합니다.";  
       
        
        
        try (VertexAI vertexAi = new VertexAI(projectId, location)) {
            GenerationConfig generationConfig = GenerationConfig.newBuilder()
                    .setMaxOutputTokens(2048)
                    .setTemperature(0.2f)
                    .build();

            GenerativeModel model = new GenerativeModel(modelName, vertexAi)
                    .withGenerationConfig(generationConfig);

              Part imagePart = Part.newBuilder()
                .setInlineData(
                    Blob.newBuilder()
                        .setMimeType(mimeType)
                        .setData(ByteString.copyFrom(imageBytes))
                        .build()
                )
                .build();

            Part textPart = Part.newBuilder()
                .setText(promptText)
                .build();

            Content content = Content.newBuilder()
            	.setRole("user")
                .addParts(imagePart)
                .addParts(textPart)
                .build();

         // 1. API 응답 생성
            GenerateContentResponse response = model.generateContent(content);

            // 2. 응답 유효성 검사 (결과가 없거나 안전 문제로 차단된 경우)
            if (response.getCandidatesCount() == 0) {
                throw new RuntimeException("Gemini API로부터 유효한 응답 후보(Candidate)를 받지 못했습니다.");
            }

            // 3. 응답에서 원본 텍스트 추출
            //    Candidate -> Content -> Part -> Text 순서로 안전하게 접근합니다.
            Candidate candidate = response.getCandidates(0);
            String rawText = candidate.getContent().getParts(0).getText();
            System.out.println("Gemini 원본 응답: " + rawText);

            // 4. 정규식을 사용하여 JSON 부분만 정확하게 추출
            //    패턴: ```json 과 ``` 사이의 내용 또는 { 와 } 사이의 내용을 찾습니다.
            Pattern jsonPattern = Pattern.compile("```json\\s*(\\{.*?\\})\\s*```|(\\{.*\\})", Pattern.DOTALL);
            Matcher matcher = jsonPattern.matcher(rawText);

            String jsonResponse;
            if (matcher.find()) {
                // 첫 번째 캡처 그룹(```json ...```)이 없으면 두 번째 캡처 그룹({ ... })을 사용합니다.
                jsonResponse = (matcher.group(1) != null) ? matcher.group(1) : matcher.group(2);
            } else {
                // 응답에서 JSON 형식을 찾지 못한 경우
                throw new RuntimeException("Gemini API 응답에서 JSON 형식의 콘텐츠를 찾을 수 없습니다.");
            }
            
            System.out.println("추출된 JSON: " + jsonResponse);

            // 5. 추출된 JSON 문자열을 DTO 객체로 변환
            return objectMapper.readValue(jsonResponse, ReceiptDTO.class);

        } catch (Exception e) {
            // 예외 발생 시 로그를 남기고, 필요한 경우 상위로 예외를 다시 던집니다.
            System.err.println("Gemini 응답 처리 중 심각한 오류 발생: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Gemini 응답 처리 중 오류가 발생했습니다.", e); // 원인 예외(e)를 포함하여 throw
        }
    }
}