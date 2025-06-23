package com.itwillbs.service;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.cloud.vertexai.VertexAI;
import com.google.cloud.vertexai.api.Blob;
import com.google.cloud.vertexai.api.GenerateContentResponse;
import com.google.cloud.vertexai.api.Part;
import com.google.cloud.vertexai.generativeai.ContentMaker;
import com.google.cloud.vertexai.generativeai.GenerativeModel;
import com.google.cloud.vertexai.generativeai.ResponseHandler;
import com.google.protobuf.ByteString;
import lombok.Data;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

public class GeminiOcrUtil {

    private static final String PROJECT_ID = "gen-lang-client-0137886470";
    private static final String LOCATION = "us-central1";
    private static final String MODEL_NAME = "gemini-2.0-flash-001";

    private static final ObjectMapper objectMapper = new ObjectMapper();

    public static OcrResult extractInfoFromImage(MultipartFile imageFile) throws Exception {
        byte[] imageBytes = imageFile.getBytes();
        String contentType = imageFile.getContentType();
        if (contentType == null) {
            contentType = "image/png"; // 기본값 지정
        }

        try (VertexAI vertexAi = new VertexAI(PROJECT_ID, LOCATION)) {

            // 프롬프트 구성 (JSON 형태 안내)
            String promptText =
            		 "당신은 매우 정확한 도서 구매 영수증 분석 전문가입니다.  .|n"+
            				 " - 교보문고, 영풍문고, YES24, 알라딘, 인터파크, 반디앤루니스, 쿠팡 단어가 판매처 이름으로 들어가 있거나 서점이라는 단어가 들어가 있는 영수증이라면 아래와 같은 명령을 실행하라.\n" + 
            				 " - 만약 그렇지 않다면 모든 값을 'null'로 해주세요\n" +
            				 " - 주어진 이미지에서 다음 JSON 구조에 맞춰 정보를 추출해주세요.\n" +
                             " - 각 필드의 값은 반드시 \"(큰따옴표)로 감싸진 문자열이어야 합니다. 단, totalPrice, quantity, price는 숫자 타입입니다.\n" +
                             " - 날짜는 'YYYY-MM-DD' 형식으로 변환해주세요.\n" +
                             " - 만약 특정 정보를 찾을 수 없다면, 그 값으로 `null`을 사용해주세요.\n" +
                             " - 만약 요청한 판매처 정보를 찾을 수 없다면, 그 값으로 `null`을 사용해주세요.\n" +
                             " - 설명이나 추가 텍스트 없이, 오직 순수한 JSON 객체만 응답해야 합니다.\n" +
                             "다음은 출력 형식의 예시입니다:\n" +
                             "```json\n" +
                             "{\n" +
                             "  \"seller\": \"판매처 이름\",\n" +
                             "  \"purchaseDate\": \"구매일자\",\n" +
                             "  \"approvalNumber\": \"카드 승인번호\",\n" +
                             "  \"totalPrice\": 총 결제 금액,\n" +
                             "  \"items\": [\n" +
                             "    { \"bookTitle\": \"품목명\", \"quantity\": 수량, \"price\": 단가 },\n" +
                             "    { \"bookTitle\": \"품목명\", \"quantity\": 수량, \"price\": 단가 }\n" +
                             "  ]\n" +
                             "}\n" +
                             "```";

            Part textPart = Part.newBuilder()
                    .setText(promptText) // ✔️ fromText() 대신
                    .build();

            Part imagePart = Part.newBuilder()
            	    .setInlineData(Blob.newBuilder()
            	        .setData(ByteString.copyFrom(imageBytes))
            	        .build())
            	    .build();
            
            // VertexAI 모델 호출
            GenerativeModel model = new GenerativeModel(MODEL_NAME, vertexAi);
            GenerateContentResponse response = model.generateContent(
                ContentMaker.fromMultiModalData(textPart, imagePart)
            );
            // 결과 추출
            String extractedJson = parseApiResponse(response);
            return objectMapper.readValue(extractedJson, OcrResult.class);

        } catch (IOException e) {
            System.err.println("IO 오류: " + e.getMessage());
            throw new RuntimeException("영수증 이미지 처리 중 IO 오류 발생", e);
        } catch (Exception e) {
            System.err.println("예상치 못한 오류: " + e.getMessage());
            throw new RuntimeException("영수증 분석 실패", e);
        }
    }

    // 응답 텍스트에서 JSON 파싱 (```json 코드 블럭 제거)
    private static String parseApiResponse(GenerateContentResponse response) {
        String rawText = ResponseHandler.getText(response);
        return rawText.replaceAll("(?s)```json\\s*|\\s*```", "").trim();
    }

    // --- DTO 클래스 (이 클래스 내부에 정의하여 의존성 최소화) ---

    /**
     * OCR 결과를 담는 메인 DTO 클래스
     */
    @Data
    public static class OcrResult {
        @JsonProperty("seller") private String seller;
        @JsonProperty("purchaseDate") private String purchaseDate;
        @JsonProperty("approvalNumber") private String approvalNumber;
        @JsonProperty("totalPrice") private int totalPrice;
        @JsonProperty("items") private List<Item> items;
    }

    /**
     * 개별 품목 정보를 담는 서브 DTO 클래스
     */
    @Data
    public static class Item {
        @JsonProperty("bookTitle") private String bookTitle;
        @JsonProperty("quantity") private int quantity;
        @JsonProperty("price") private int price;
    }
}