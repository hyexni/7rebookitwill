package com.itwillbs.service;

import net.sourceforge.tess4j.ITesseract;
import net.sourceforge.tess4j.Tesseract;
import net.sourceforge.tess4j.TesseractException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Tesseract OCR 엔진을 사용하여 이미지에서 텍스트를 추출하고,
 * 특정 영수증의 패턴을 분석하여 정보를 추출하는 유틸리티 클래스입니다.
 */
public class OcrUtil {

    private static final Logger logger = LoggerFactory.getLogger(OcrUtil.class);

    private OcrUtil() {}

    /**
     * Tesseract를 사용하여 이미지 파일에서 텍스트를 추출합니다.
     */
    public static String extractTextFromImage(File imageFile) {
        ITesseract tesseract = new Tesseract();
        // ※ 중요 ※: Tesseract 학습 데이터(tessdata)가 있는 경로를 PC 환경에 맞게 설정해야 합니다.
        tesseract.setDatapath("C:/Program Files/Tesseract-OCR/tessdata"); // 예시 경로
        tesseract.setLanguage("kor");

        try {
            logger.info("Tesseract OCR 처리를 시작합니다: {}", imageFile.getName());
            return tesseract.doOCR(imageFile);
        } catch (TesseractException e) {
            logger.error("Tesseract OCR 처리 중 오류가 발생했습니다.", e);
            return null;
        }
    }
    /**
     * [강화] 다양한 영수증 양식에서 구매한 모든 품목 정보를 추출합니다.
     */
    public static List<ReceiptItem> extractItems(String ocrText) {
        List<ReceiptItem> items = new ArrayList();

        // --- 로직 1: 교보문고 영수증 형식 ('*' 기호 기반) ---
        String[] lines = ocrText.split("\n");
        for (int i = 0; i < lines.length; i++) {
            if (lines[i].trim().startsWith("*")) {
                String title = (i > 0) ? lines[i - 1].trim().replaceAll("\\(.*\\)", "").trim() : "알 수 없는 품목";
                if (title.contains("할인금액")) continue;

                String[] parts = lines[i].trim().substring(1).split("\\s+");
                if (parts.length >= 3) {
                    try {
                        int price = parseAmount(parts[1]);
                        int quantity = Integer.parseInt(parts[2]);
                        items.add(new ReceiptItem(title, price, quantity));
                    } catch (NumberFormatException e) {
                        logger.warn("교보문고 형식 품목 라인 파싱 실패: {}", lines[i]);
                    }
                }
            }
        }

        // --- 로직 2: 쿠팡 영수증 형식 ('상품명' 키워드 기반) ---
        // '상품명' 키워드 다음 줄부터 '과세금액' 전까지의 모든 라인을 품목명으로 간주합니다.
        // 이 로직은 품목이 하나일 때를 가정합니다. 여러개일 경우 패턴 수정이 필요합니다.
        Pattern coupangPattern = Pattern.compile("상품명\\n([\\s\\S]*?)\\n과세금액");
        Matcher coupangMatcher = coupangPattern.matcher(ocrText);
        if (items.isEmpty() && coupangMatcher.find()) { // 로직 1에서 찾은게 없을 때만 실행
            String title = coupangMatcher.group(1).trim().replace("\n", " ");
            int quantity = 1; // 쿠팡 영수증에는 수량이 명시되지 않아 1로 가정
            int price = extractTotalAmount(ocrText); // 쿠팡 영수증은 합계금액을 단가로 사용
            items.add(new ReceiptItem(title, price, quantity));
        }
        
        return items;
    }

    /**
     * [강화] 다양한 영수증에서 구매처를 추출합니다.
     */
    public static String extractStoreName(String ocrText) {
        // 1순위: '판매자상호' 키워드 (쿠팡 형식)
        Pattern pattern = Pattern.compile("판매자상호\\s*([\\w가-힣()]+)");
        Matcher matcher = pattern.matcher(ocrText);
        if (matcher.find()) {
            return matcher.group(1).trim();
        }
        
        // 2순위: 국내 주요 서점 키워드
        pattern = Pattern.compile("(교보문고|영풍문고|반디앤루니스|알라딘|YES24|인터파크|서울문고|아크앤북|북스리브로|교보핫트랙스)");
        matcher = pattern.matcher(ocrText);
        if (matcher.find()) {
            return matcher.group(1).trim();
        }
        
        return null;
    }

    /**
     * [강화] 다양한 영수증에서 구매일시를 추출합니다.
     */
    public static String extractPurchaseDate(String ocrText) {
        // 1순위: '거래일시' 키워드 (쿠팡 형식)
        Pattern pattern = Pattern.compile("거래일시\\s*(\\d{4}/\\d{2}/\\d{2}\\s+\\d{2}:\\d{2}:\\d{2})");
        Matcher matcher = pattern.matcher(ocrText);
        if (matcher.find()) {
            return matcher.group(1).trim();
        }

        // 2순위: '[판매]' 키워드 (교보문고 형식)
        pattern = Pattern.compile("\\[판매\\]\\s*(\\d{4}-\\d{2}-\\d{2}\\s+\\d{2}:\\d{2}:\\d{2})");
        matcher = pattern.matcher(ocrText);
        if (matcher.find()) {
            return matcher.group(1).trim();
        }
        return null;
    }

    /**
     * 다양한 영수증에서 최종 결제 금액을 추출합니다.
     */
    public static int extractTotalAmount(String ocrText) {
        // 1순위: '합계금액' 키워드 (쿠팡 형식)
        Pattern pattern = Pattern.compile("합계금액\\s*([\\d,]+)");
        Matcher matcher = pattern.matcher(ocrText);
        if (matcher.find()) {
            return parseAmount(matcher.group(1));
        }

        // 2순위: '결제금액' 키워드 (교보문고 형식)
        pattern = Pattern.compile("결\\s*제\\s*금\\s*액\\s*([\\d,]+)");
        matcher = pattern.matcher(ocrText);
        if (matcher.find()) {
            return parseAmount(matcher.group(1));
        }
        return 0;
    }

    /**
     * 금액 문자열에서 숫자 외 문자를 제거하고 정수로 변환하는 헬퍼 메서드.
     */
    private static int parseAmount(String amountStr) {
        if (amountStr == null || amountStr.isEmpty()) {
            return 0;
        }
        return Integer.parseInt(amountStr.replaceAll("[^0-9]", ""));
    }

    /**
     * 추출된 개별 구매 품목 정보를 담기 위한 내부 데이터 클래스(DTO).
     */
    public static class ReceiptItem {
        private final String title;
        private final int price;
        private final int quantity;

        public ReceiptItem(String title, int price, int quantity) {
            this.title = title;
            this.price = price;
            this.quantity = quantity;
        }

        public String getTitle() { return title; }
        public int getPrice() { return price; }
        public int getQuantity() { return quantity; }

        @Override
        public String toString() {
            return "ReceiptItem{" +
                    "title='" + title + '\'' +
                    ", price=" + price +
                    ", quantity=" + quantity +
                    '}';
        }
    }
}