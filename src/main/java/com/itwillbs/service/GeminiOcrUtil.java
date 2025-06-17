package com.itwillbs.service;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.cloud.vertexai.VertexAI;
import com.google.cloud.vertexai.api.GenerateContentResponse;
import com.google.cloud.vertexai.api.GenerationConfig;
import com.google.cloud.vertexai.api.Part;
import com.google.cloud.vertexai.generativeai.ContentMaker;
import com.google.cloud.vertexai.generativeai.GenerativeModel;
import com.google.cloud.vertexai.generativeai.ResponseHandler;
import com.google.protobuf.ByteString;
import lombok.Data;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public class GeminiOcrUtil {

    // --- Vertex AI 설정 정보 ---
    // ⚠️ 이 값들은 실제 자신의 Google Cloud 프로젝트 정보로 채워야 합니다.
    private static final String PROJECT_ID = "radiant-micron-463205-k3"; // 🔒 여기에 본인의 프로젝트 ID를 입력하세요
    private static final String LOCATION = "asia-northeast3";                 // 서울 리전
    private static final String MODEL_NAME = "gemini-1.5-flash-001";            // 사용할 모델

    private static final ObjectMapper objectMapper = new ObjectMapper();

    /**
     * MultipartFile을 받아 Vertex AI Gemini API를 호출하고, 구조화된 결과를 DTO로 반환합니다.
     */
    public static OcrResult extractInfoFromImage(MultipartFile imageFile) throws Exception {

        // 1. 이미지 파일을 byte 배열로 변환
        byte[] imageBytes = imageFile.getBytes();

        // 2. VertexAI 클라이언트 초기화 (try-with-resources로 자동 리소스 관리)
        // 이 클라이언트는 ADC를 사용하여 자동으로 인증합니다.
        try (VertexAI vertexAi = new VertexAI(PROJECT_ID, LOCATION)) {

            // 3. 프롬프트 정의
            String promptText = "당신은 영수증 분석 전문가입니다. "
                    + "이 이미지에서 다음 정보를 추출해서 JSON 형식으로만 응답해주세요. "
                    + "만약 특정 정보를 찾을 수 없으면, 값으로 \"정보 없음\"을 사용하세요. "
                    + "날짜는 'YYYY-MM-DD HH:mm:ss' 형식으로, 금액과 수량은 쉼표 없는 숫자만 추출해주세요. "
                    + "품목(items)은 반드시 배열(array) 형태로 추출해주세요.\n"
                    + "{\n"
                    + "  \"storeName\": \"판매처 이름\",\n"
                    + "  \"purchaseDate\": \"구매일시\",\n"
                    + "  \"approvalNumber\": \"카드 승인번호\",\n"
                    + "  \"totalPrice\": 총 결제 금액,\n"
                    + "  \"items\": [\n"
                    + "    { \"itemName\": \"품목명\", \"quantity\": 수량, \"price\": 단가 },\n"
                    + "    { \"itemName\": \"품목명\", \"quantity\": 수량, \"price\": 단가 }\n"
                    + "  ]\n"
                    + "}";

            // 4. API에 보낼 콘텐츠(프롬프트 + 이미지) 생성
            Part textPart = Part.newBuilder().setText(promptText).build();
            Part imagePart = Part.newBuilder()
                    .setMimeType(imageFile.getContentType())
                    .setData(ByteString.copyFrom(imageBytes))
                    .build();

            // 5. API 호출 및 응답 받기
            GenerativeModel model = new GenerativeModel(MODEL_NAME, vertexAi);
            GenerateContentResponse response = model.generateContent(ContentMaker.fromMultiModalData(textPart, imagePart));

            // 6. 응답에서 JSON 텍스트 추출 및 파싱
            String extractedJson = parseApiResponse(response);
            return objectMapper.readValue(extractedJson, OcrResult.class);

        } catch (Exception e) {
            System.err.println("Vertex AI Gemini API 호출 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("영수증 정보 추출에 실패했습니다.", e);
        }
    }

    /**
     * Gemini API의 전체 응답에서 우리가 요청한 JSON 텍스트 부분만 추출하고 정리합니다.
     */
    private static String parseApiResponse(GenerateContentResponse response) throws JsonProcessingException {
        String rawText = ResponseHandler.getText(response);
        // Gemini가 응답을 ```json ... ``` 와 같이 마크다운으로 감싸는 경우가 많으므로 제거
        return rawText.replaceAll("(?s)```json\\s*|\\s*```", "").trim();
    }


    // --- DTO 클래스들 (API 응답 결과를 담는 용도) ---

    @Data
    public static class OcrResult {
        @JsonProperty("storeName") private String storeName;
        @JsonProperty("purchaseDate") private String purchaseDate;
        @JsonProperty("approvalNumber") private String approvalNumber;
        @JsonProperty("totalPrice") private int totalPrice;
        @JsonProperty("items") private List<Item> items;
    }

    @Data
    public static class Item {
        @JsonProperty("itemName") private String itemName;
        @JsonProperty("quantity") private int quantity;
        @JsonProperty("price") private int price;
    }
}