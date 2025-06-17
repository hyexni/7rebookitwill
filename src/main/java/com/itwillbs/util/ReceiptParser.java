package com.itwillbs.util;

import java.util.*;
import java.util.regex.*;

public class ReceiptParser {

    public static Map<String, List<String>> extractReceiptData(String text) {
        Map<String, List<String>> result = new HashMap<>();

        // 날짜 + 시간 (예: 2024-06-13 14:23:45)
        result.put("dates", extractPattern(text,
            "\\d{4}[./\\-년 ]+\\d{1,2}[./\\-월 ]+\\d{1,2}(\\s\\d{1,2}:\\d{2}(:\\d{2})?)?"));

        // 금액 (예: 12,300원, ₩15,000)
        result.put("amounts", extractPattern(text,
            "(₩|\\b)?\\d{1,3}(,\\d{3})*(원)?"));

        // 승인번호 (예: 승인번호: 12345678)
        result.put("approvalNumbers", extractPattern(text,
            "(승인번호|승인|AUTH|Approval)[\\s:：]*\\d{6,}"));

        // 구매처 (예: 교보문고, YES24 등)
        result.put("storeNames", extractPattern(text,
            "\\b(교보문고|영풍문고|YES24|알라딘|인터파크|반디앤루니스)\\b"));

        // 책 제목 (예: 도서명: 부자 아빠 가난한 아빠)
        result.put("bookTitles", extractPattern(text,
            "(도서명|책제목|제목)[\\s:：]*[\\p{L}\\p{N} \\-\\_\\'\\\"()]{2,}"));

        return result;
    }

    // 문자열에서 정규식으로 항목 추출
    private static List<String> extractPattern(String text, String regex) {
        List<String> matches = new ArrayList();
        Pattern pattern = Pattern.compile(regex, Pattern.CASE_INSENSITIVE);
        Matcher matcher = pattern.matcher(text);
        while (matcher.find()) {
            matches.add(matcher.group().trim());
        }
        return matches;
    }
}
