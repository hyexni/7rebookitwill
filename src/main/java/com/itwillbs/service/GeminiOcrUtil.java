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
    private static final String PROJECT_ID = "gen-lang-client-0137886470";
    private static final String LOCATION = "asia-northeast3";
    private static final String MODEL_NAME = "gemini-1.5-pro-001"; 

    private static final ObjectMapper objectMapper = new ObjectMapper();

    public static OcrResult extractInfoFromImage(MultipartFile imageFile) throws Exception {
        byte[] imageBytes = imageFile.getBytes();

        try (VertexAI vertexAi = new VertexAI(PROJECT_ID, LOCATION)) {
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
            
            // pom.xml을 업데이트하면 이 부분이 더 이상 오류가 발생하지 않습니다.
            Part textPart = Part.newBuilder().setText(promptText).build();
            Part imagePart = Part.newBuilder()
                    .setMimeType(imageFile.getContentType())
                    .setData(ByteString.copyFrom(imageBytes))
                    .build();

            GenerativeModel model = new GenerativeModel(MODEL_NAME, vertexAi);
            GenerateContentResponse response = model.generateContent(ContentMaker.fromMultiModalData(textPart, imagePart));
            
            String extractedJson = parseApiResponse(response);
            return objectMapper.readValue(extractedJson, OcrResult.class);

        } catch (Exception e) {
            System.err.println("Vertex AI Gemini API 호출 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("영수증 정보 추출에 실패했습니다.", e);
        }
    }

    private static String parseApiResponse(GenerateContentResponse response) {
        String rawText = ResponseHandler.getText(response);
        return rawText.replaceAll("(?s)```json\\s*|\\s*```", "").trim();
    }

    // --- DTO 클래스들 ---
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