package com.itwillbs.dto;

import java.util.Collections;
import java.util.List;

// 이 클래스는 Gemini API에 요청을 보낼 때의 JSON 구조와 똑같이 생겼습니다.
public class GeminiRequest {
    private List<Content> contents;

    // 생성자: 텍스트 프롬프트와 Base64로 인코딩된 이미지 데이터를 받아서 API가 요구하는 형식으로 만듭니다.
    public GeminiRequest(String text, String base64ImageData) {
        Part textPart = new Part(text);
        Part imagePart = new Part(new InlineData("image/jpeg", base64ImageData));
        this.contents = Collections.singletonList(new Content(List.of(textPart, imagePart)));
    }

    // Getter와 Setter
    public List<Content> getContents() {
        return contents;
    }

    public void setContents(List<Content> contents) {
        this.contents = contents;
    }

    // --- 내부 구조를 표현하는 중첩 클래스들 ---

    public static class Content {
        private List<Part> parts;

        public Content(List<Part> parts) {
            this.parts = parts;
        }

        public List<Part> getParts() {
            return parts;
        }

        public void setParts(List<Part> parts) {
            this.parts = parts;
        }
    }

    public static class Part {
        private String text;
        private InlineData inlineData;

        public Part(String text) {
            this.text = text;
        }

        public Part(InlineData inlineData) {
            this.inlineData = inlineData;
        }

        public String getText() {
            return text;
        }

        public void setText(String text) {
            this.text = text;
        }

        public InlineData getInlineData() {
            return inlineData;
        }

        public void setInlineData(InlineData inlineData) {
            this.inlineData = inlineData;
        }
    }

    public static class InlineData {
        private String mimeType;
        private String data;

        public InlineData(String mimeType, String data) {
            this.mimeType = mimeType;
            this.data = data;
        }

        public String getMimeType() {
            return mimeType;
        }

        public void setMimeType(String mimeType) {
            this.mimeType = mimeType;
        }

        public String getData() {
            return data;
        }

        public void setData(String data) {
            this.data = data;
        }
    }
}