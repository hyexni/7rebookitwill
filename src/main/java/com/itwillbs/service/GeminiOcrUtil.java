package com.itwillbs.service;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.auth.oauth2.AccessToken;
import com.google.auth.oauth2.GoogleCredentials;
import lombok.Data;
import org.springframework.web.multipart.MultipartFile;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.Collections;
import java.util.List;

public class GeminiOcrUtil {

    // --- Vertex AI 설정 정보 ---
    private static final String PROJECT_ID = "gen-lang-client-0137886470"; // 이전 오류 로그에 있던 프로젝트 ID
    private static final String LOCATION = "asia-northeast3";
    // ✅ 존재하고 성능 좋은 모델 이름으로 수정 완료!
    private static final String MODEL_NAME = "gemini-1.5-pro-002"; 

    // Vertex AI의 REST API 엔드포인트 URL
    private static final String API_URL = String.format(
            "https://%s-aiplatform.googleapis.com/v1/projects/%s/locations/%s/publishers/google/models/%s:generateContent",
            LOCATION, PROJECT_ID, LOCATION, MODEL_NAME
    );

    private static final ObjectMapper objectMapper = new ObjectMapper();

    public static OcrResult extractInfoFromImage(MultipartFile imageFile) throws Exception {

        GoogleCredentials credentials = GoogleCredentials.getApplicationDefault()
                .createScoped(Collections.singleton("https://www.googleapis.com/auth/cloud-platform"));
        credentials.refreshIfExpired();
        AccessToken accessToken = credentials.getAccessToken();
        String tokenValue = accessToken.getTokenValue();
        
        byte[] imageBytes = imageFile.getBytes();
        String base64Image = Base64.getEncoder().encodeToString(imageBytes);
        String payload = createApiPayload(base64Image, imageFile.getContentType());
        
        URL url = new URL(API_URL);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Authorization", "Bearer " + tokenValue);
        conn.setRequestProperty("Content-Type", "application/json; charset=utf-8");
        conn.setDoOutput(true);

        try (OutputStream os = conn.getOutputStream()) {
            os.write(payload.getBytes(StandardCharsets.UTF_8));
        }

        int responseCode = conn.getResponseCode();
        if (responseCode == HttpURLConnection.HTTP_OK) {
            try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))) {
                StringBuilder response = new StringBuilder();
                String responseLine;
                while ((responseLine = br.readLine()) != null) {
                    response.append(responseLine.trim());
                }
                String extractedJson = parseApiResponse(response.toString());
                return objectMapper.readValue(extractedJson, OcrResult.class);
            }
        } else {
            try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getErrorStream(), StandardCharsets.UTF_8))) {
                StringBuilder errorResponse = new StringBuilder();
                String responseLine;
                while ((responseLine = br.readLine()) != null) {
                    errorResponse.append(responseLine.trim());
                }
                throw new RuntimeException("Gemini API 호출 실패: " + responseCode + " - " + errorResponse.toString());
            }
        }
    }
    
    private static String createApiPayload(String base64Image, String mimeType) throws JsonProcessingException {
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

        // JSON 문자열의 특수문자를 이스케이프 처리
        String escapedPromptText = promptText.replace("\"", "\\\"").replace("\n", "\\n");

        return String.format("{\"contents\":[{\"parts\":[{\"text\":\"%s\"},{\"inlineData\":{\"mimeType\":\"%s\",\"data\":\"%s\"}}]}]}",
                escapedPromptText, mimeType, base64Image);
    }

    private static String parseApiResponse(String apiResponse) throws JsonProcessingException {
        JsonNode rootNode = objectMapper.readTree(apiResponse);
        JsonNode textNode = rootNode.path("candidates").get(0)
                .path("content").path("parts").get(0)
                .path("text");
        
        if (textNode.isMissingNode() || textNode.asText().isEmpty()) {
            throw new RuntimeException("Gemini 응답에서 유효한 텍스트를 찾을 수 없습니다.");
        }
        
        return textNode.asText().replaceAll("(?s)```json\\s*|\\s*```", "").trim();
    }

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