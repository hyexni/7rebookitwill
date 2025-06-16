package com.itwillbs.service;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.web.multipart.MultipartFile;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Base64;
import java.util.Collections;
import java.util.List;

public class GeminiOcrUtil {

    private static final String GEMINI_API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro-vision:generateContent";
    // ⚠️ 경고: API 키를 코드에 하드코딩하는 것은 매우 위험합니다. 외부 설정으로 분리하는 것을 강력히 권장합니다.
    private static final String API_KEY = "YOUR_GEMINI_API_KEY"; // 🔒 여기에 본인의 Gemini API 키를 입력하세요

    private static final ObjectMapper objectMapper = new ObjectMapper();

    /**
     * MultipartFile을 받아 Gemini Vision API를 호출하고, 구조화된 결과를 DTO로 반환합니다.
     */
    public static OcrResult extractInfoFromImage(MultipartFile imageFile) throws Exception {
        
        // 1. 이미지 파일을 Base64로 인코딩
        byte[] imageBytes = imageFile.getBytes();
        String base64Image = Base64.getEncoder().encodeToString(imageBytes);

        // 2. Gemini에 보낼 요청 본문(JSON) 생성
        String payload = createApiPayload(base64Image, imageFile.getContentType());
        
        // 3. API 호출 및 응답 받기
        URL url = new URL(GEMINI_API_URL + "?key=" + API_KEY);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
        conn.setDoOutput(true);

        try (OutputStream os = conn.getOutputStream()) {
            os.write(payload.getBytes("UTF-8"));
        }

        int responseCode = conn.getResponseCode();
        if (responseCode == 200) {
            // 4. 성공 응답 파싱
            try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"))) {
                StringBuilder response = new StringBuilder();
                String responseLine;
                while ((responseLine = br.readLine()) != null) {
                    response.append(responseLine.trim());
                }
                
                // Gemini의 응답에서 실제 우리가 요청한 JSON 텍스트를 추출
                String extractedJson = parseApiResponse(response.toString());
                
                // 추출된 JSON 텍스트를 최종 DTO 객체로 변환
                return objectMapper.readValue(extractedJson, OcrResult.class);
            }
        } else {
            // 에러 응답 처리
            try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "UTF-8"))) {
                 StringBuilder errorResponse = new StringBuilder();
                String responseLine;
                while ((responseLine = br.readLine()) != null) {
                    errorResponse.append(responseLine.trim());
                }
                 throw new RuntimeException("Gemini API 호출 실패: " + responseCode + " - " + errorResponse.toString());
            }
        }
    }
    
    /**
     * Gemini API 요청 본문(Payload)을 생성합니다.
     */
    private static String createApiPayload(String base64Image, String mimeType) throws JsonProcessingException {
        // 프롬프트 정의
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
        
        // 자바 객체를 사용하여 안전하게 JSON 생성
        Part textPart = new Part(promptText);
        Part imagePart = new Part(new InlineData(mimeType, base64Image));
        Content content = new Content(List.of(textPart, imagePart));
        GeminiRequest request = new GeminiRequest(List.of(content));

        return objectMapper.writeValueAsString(request);
    }
    
    /**
     * Gemini API의 전체 응답에서 우리가 요청한 JSON 텍스트 부분만 추출합니다.
     */
    private static String parseApiResponse(String apiResponse) throws JsonProcessingException {
        JsonNode rootNode = objectMapper.readTree(apiResponse);
        JsonNode textNode = rootNode.path("candidates").get(0)
                                    .path("content").path("parts").get(0)
                                    .path("text");
        
        // `text` 노드가 존재하지 않거나 비어있을 경우 예외 처리
        if (textNode.isMissingNode() || textNode.asText().isEmpty()) {
            throw new RuntimeException("Gemini 응답에서 유효한 텍스트를 찾을 수 없습니다.");
        }
        
        // JSON 블록 마커(```) 제거
        return textNode.asText().replaceAll("(?s)```json\\s*|\\s*```", "").trim();
    }


    // --- DTO 클래스들 (API 요청 및 응답 처리에 사용) ---

    // Gemini API 요청 본문 구조
    @Data @AllArgsConstructor
    private static class GeminiRequest {
        private List<Content> contents;
    }
    @Data @AllArgsConstructor
    private static class Content {
        private List<Part> parts;
    }
    @Data @NoArgsConstructor
    private static class Part {
        private String text;
        private InlineData inlineData;
        public Part(String text) { this.text = text; }
        public Part(InlineData inlineData) { this.inlineData = inlineData; }
    }
    @Data @AllArgsConstructor
    private static class InlineData {
        private String mimeType;
        private String data;
    }

    // 최종 추출 결과를 담을 DTO
    @Data
    public static class OcrResult {
        @JsonProperty("storeName") private String storeName;
        @JsonProperty("purchaseDate") private String purchaseDate;
        @JsonProperty("approvalNumber") private String approvalNumber;
        @JsonProperty("totalPrice") private int totalPrice;
        @JsonProperty("items") private List<Item> items;
    }

    // 품목 정보를 담을 DTO
    @Data
    public static class Item {
        @JsonProperty("itemName") private String itemName;
        @JsonProperty("quantity") private int quantity;
        @JsonProperty("price") private int price;
    }
}