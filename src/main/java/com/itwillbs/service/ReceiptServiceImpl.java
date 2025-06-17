package com.itwillbs.service;

// --- 필요한 모든 import 문 ---
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.cloud.vertexai.VertexAI;
import com.google.cloud.vertexai.api.GenerateContentResponse;
import com.google.cloud.vertexai.api.GenerationConfig;
import com.google.cloud.vertexai.api.Part;
import com.google.cloud.vertexai.generativeai.ContentMaker;
import com.google.cloud.vertexai.generativeai.GenerativeModel;
import com.google.cloud.vertexai.generativeai.ResponseHandler;
import com.google.protobuf.ByteString;
import com.itwillbs.domain.ReceiptVO;
import com.itwillbs.dto.ReceiptDto;
import com.itwillbs.persistence.ReceiptDAO;
import org.springframework.beans.factory.annotation.Autowired;
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
public class ReceiptServiceImpl implements ReceiptService {

    private final ReceiptDAO receiptDAO;
    private final ObjectMapper objectMapper;

    @Value("${upload.path}")
    private String uploadPath;

    @Autowired
    public ReceiptServiceImpl(ReceiptDAO receiptDAO, ObjectMapper objectMapper) {
        this.receiptDAO = receiptDAO;
        this.objectMapper = objectMapper;
    }

    @Override
    @Transactional(rollbackFor = Exception.class) // 모든 예외 발생 시 롤백
    public ReceiptVO processAndSaveReceipt(MultipartFile file, int memberIdx) throws Exception {

        // 1. 파일 해시 생성 및 중복 확인
        String fileHash = generateFileHash(file);
        if (receiptDAO.countByFileHash(fileHash) > 0) {
            throw new IllegalStateException("동일한 내용의 파일이 이미 등록되어 있습니다.");
        }

        // 2. 물리적 파일 저장
        String savedFilename = saveFileToServer(file);

        // 3. Gemini API 호출하여 영수증 정보 추출
        byte[] imageBytes = file.getBytes();
        ReceiptDto ocrDto = callGeminiApi(imageBytes, file.getContentType());
        if (ocrDto == null) {
            throw new RuntimeException("영수증 정보를 추출하는 데 실패했습니다. 이미지 품질이나 형식을 확인해주세요.");
        }

        // 4. 최종 VO 객체 생성 및 모든 정보 설정
        ReceiptVO finalVO = createReceiptVO(file, ocrDto, memberIdx, savedFilename, fileHash);

        // 5. DB에 영수증 정보 저장
        receiptDAO.insertReceipt(finalVO);

        return finalVO;
    }

    // --- Private 헬퍼 메서드들 ---

    /**
     * 최종적으로 DB에 저장할 ReceiptVO 객체를 생성하고 모든 정보를 설정합니다.
     */
    private ReceiptVO createReceiptVO(MultipartFile file, ReceiptDto ocrDto, int memberIdx, String savedFilename, String fileHash) throws ParseException {
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

        // 가격 정보 (문자열 -> 정수)
        if (ocrDto.getPrice() != null && !ocrDto.getPrice().isEmpty()) {
            finalVO.setOcr_amount(Integer.parseInt(ocrDto.getPrice()));
        }

        // 날짜 정보 (문자열 -> Timestamp)
        String dateStr = ocrDto.getPurchaseDate();
        if (dateStr != null && !dateStr.isEmpty()) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date parsedDate = sdf.parse(dateStr);
            finalVO.setOcr_date(new java.sql.Timestamp(parsedDate.getTime()));
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
    private ReceiptDto callGeminiApi(byte[] imageBytes, String mimeType) throws Exception {
        String projectId = "radiant-micron-463205-k3"; // [필수] 자신의 프로젝트 ID로 변경
        String location = "asia-northeast3";              // 서울 리전
        String modelName = "gemini-1.5-flash-001";         // 사용할 모델

        String promptText = "이 영수증 이미지에서 다음 정보를 JSON 형식으로 추출해줘: "
            + "1. 'seller': 서점 또는 상점 이름 "
            + "2. 'bookTitle': 책 제목 "
            + "3. 'price': '총금액' 또는 '합계'에 해당하는 숫자 값 (문자나 콤마 없이 숫자만) "
            + "4. 'purchaseDate': 구매 날짜 (YYYY-MM-DD 형식) "
            + "5. 'approvalNumber': 승인 번호. "
            + "만약 특정 항목을 찾을 수 없다면, 그 값은 null로 설정해줘. "
            + "절대로 설명이나 추가적인 텍스트 없이 순수한 JSON 객체만 응답해야 해.";

        try (VertexAI vertexAi = new VertexAI(projectId, location)) {
            GenerationConfig generationConfig = GenerationConfig.newBuilder()
                .setMaxOutputTokens(2048)
                .setTemperature(0.2f)
                .build();

            GenerativeModel model = new GenerativeModel(modelName, vertexAi)
                .withGenerationConfig(generationConfig);

            GenerateContentResponse response = model.generateContent(
                ContentMaker.fromMultiModalData(
                    Part.newBuilder().setText(promptText).build()
                   // Part.newBuilder().setMimeType(mimeType).setData(ByteString.copyFrom(imageBytes)).build()
                )
            );

            String jsonResponse = ResponseHandler.getText(response).replace("```json", "").replace("```", "").trim();
            System.out.println("Gemini 응답 (JSON): " + jsonResponse);

            return objectMapper.readValue(jsonResponse, ReceiptDto.class);

        } catch (Exception e) {
            System.err.println("Gemini API 호출 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }
}