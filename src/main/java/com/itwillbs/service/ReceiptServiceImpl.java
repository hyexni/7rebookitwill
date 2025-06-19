package com.itwillbs.service;

// --- 필요한 모든 import 문 ---
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.cloud.vertexai.VertexAI;
import com.google.cloud.vertexai.api.Blob; // [추가] Blob 클래스 import
import com.google.cloud.vertexai.api.Content;
import com.google.cloud.vertexai.api.GenerateContentResponse;
import com.google.cloud.vertexai.api.GenerationConfig;
import com.google.cloud.vertexai.api.Part;
import com.google.cloud.vertexai.generativeai.GenerativeModel;
import com.google.cloud.vertexai.generativeai.ResponseHandler;
import com.google.protobuf.ByteString;
import com.itwillbs.domain.ReceiptVO;
import com.itwillbs.dto.ReceiptDTO;
import com.itwillbs.persistence.ReceiptDAO;
import lombok.RequiredArgsConstructor;
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
import java.util.UUID;

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

    // 명시적인 생성자 코드가 사라져 클래스가 더 깔끔해졌습니다.

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

        // 4. 최종 VO 객체 생성 및 모든 정보 설정
        ReceiptVO finalVO = createReceiptVO(file, ocrDto, member_idx, savedFilename, fileHash);

        // 5. DB에 영수증 정보 저장
        receiptDAO.insertReceipt(finalVO);

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

        // OCR 결과 정보
        finalVO.setOcr_store(ocrDto.getSeller());
        finalVO.setOcr_booktitle(ocrDto.getBookTitle());
        finalVO.setApprovalnumber(ocrDto.getApprovalNumber());

        // 가격 정보 처리 안정성 강화
        if (ocrDto.getPrice() != null && !ocrDto.getPrice().isEmpty()) {
            // 숫자 외 모든 문자(콤마, 원 등)를 제거하여 NumberFormatException 방지
            String priceOnlyNumbers = ocrDto.getPrice().replaceAll("[^0-9]", "");
            if (!priceOnlyNumbers.isEmpty()) {
                finalVO.setOcr_amount(Integer.parseInt(priceOnlyNumbers));
            }
        }

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
        String location = "asia-northeast3";              // 서울 리전
        String modelName = "gemini-1.5-pro-002";         // 사용할 모델

        String promptText = "당신은 영수증 분석 전문가입니다. 주어진 영수증 이미지에서 다음 정보를 JSON 형식으로 정확히 추출해주세요: "
                + "1. 'seller': 서점 또는 상점 이름 "
                + "2. 'bookTitle': 책 제목 (여러 개일 경우 쉼표(,)로 구분) "
                + "3. 'price': '총금액' 또는 '합계'에 해당하는 최종 결제 금액 (문자나 콤마 없이 오직 숫자만) "
                + "4. 'purchaseDate': 구매 날짜 (반드시<y_bin_46>-MM-dd 형식) "
                + "5. 'approvalNumber': 카드 승인 번호. "
                + "만약 특정 항목을 찾을 수 없다면, 그 값은 null로 설정해주세요. "
                + "절대로 설명이나 추가적인 텍스트 없이 순수한 JSON 객체만 응답해야 합니다.";

        try (VertexAI vertexAi = new VertexAI(projectId, location)) {
            GenerationConfig generationConfig = GenerationConfig.newBuilder()
                    .setMaxOutputTokens(2048)
                    .setTemperature(0.2f)
                    .build();

            GenerativeModel model = new GenerativeModel(modelName, vertexAi)
                    .withGenerationConfig(generationConfig);

            // [핵심 수정] setMimeType 오류 해결을 위해 Part 객체 생성 방식을 변경합니다.
            // Part.newBuilder().setInlineData()를 사용하여 MIME 타입과 이미지 데이터를
            // Blob 객체로 감싸서 전달합니다. 이 방식은 구버전 SDK와의 호환성이 더 좋습니다.
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
                .addParts(imagePart)
                .addParts(textPart)
                .build();

            GenerateContentResponse response = model.generateContent(content);

            String jsonResponse = ResponseHandler.getText(response).replace("```json", "").replace("```", "").trim();
            System.out.println("Gemini 응답 (JSON): " + jsonResponse);

            return objectMapper.readValue(jsonResponse, ReceiptDTO.class);

        } catch (Exception e) {
            System.err.println("Gemini API 호출 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }
}