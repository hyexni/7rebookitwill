package com.itwillbs.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.itwillbs.domain.ReceiptVO;
import com.itwillbs.dto.GeminiRequest;
import com.itwillbs.dto.GeminiResponse;
import com.itwillbs.dto.ReceiptDto;
import com.itwillbs.persistence.ReceiptDAO;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import javax.inject.Inject;
import java.io.IOException;
import java.util.Base64;
import java.util.List;

@Service
public class ReceiptServiceImpl implements ReceiptService {

    private final RestTemplate restTemplate;
    private final ObjectMapper objectMapper;

    @Inject
    private ReceiptDAO receiptDAO;

    @Value("${gemini.api.key}")
    private String apiKey;

    public ReceiptServiceImpl(RestTemplate restTemplate, ObjectMapper objectMapper) {
        this.restTemplate = restTemplate;
        this.objectMapper = objectMapper;
    }

    /**
     * Gemini API로 영수증 정보 추출
     */
    @Override
    public ReceiptDto getInfoFromReceipt(MultipartFile imageFile) throws IOException {
        String apiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro-vision:generateContent?key=" + apiKey;

        String base64ImageData = Base64.getEncoder().encodeToString(imageFile.getBytes());
        String promptText = "이 이미지는 책을 구매한 영수증이야.\n" +
                "여기서 '도서명', '판매처', '구매일시', '승인번호', '가격' 정보를 추출해서 아래 JSON 형식으로만 응답해줘.\n" +
                "만약 특정 정보를 찾을 수 없으면, 값으로 \"정보 없음\"이라고 넣어줘.\n" +
                "{\n" +
                "  \"bookTitle\": \"여기에 도서명\",\n" +
                "  \"seller\": \"여기에 판매처\",\n" +
                "  \"purchaseDate\": \"YYYY-MM-DD HH:mm:ss 형식의 구매일시\",\n" +
                "  \"approvalNumber\": \"여기에 승인번호\",\n" +
                "  \"price\": \"여기에 가격 (숫자만)\"\n" +
                "}";

        GeminiRequest request = new GeminiRequest(promptText, base64ImageData);
        GeminiResponse response = restTemplate.postForObject(apiUrl, request, GeminiResponse.class);

        if (response != null && response.extractText() != null) {
            String jsonResponse = response.extractText().replace("```json", "").replace("```", "").trim();
            return objectMapper.readValue(jsonResponse, ReceiptDto.class);
        } else {
            throw new IOException("Gemini API 응답 실패");
        }
    }

    /**
     * 파일명이 DB에 이미 존재하는지 확인
     */
    @Override
    public boolean isDuplicate(String originalFilename) {
        System.out.println("isDuplicate 메소드 호출됨: " + originalFilename);
        // TODO: 실제 구현 필요
        return receiptDAO.countByFilename(originalFilename) > 0;
    }

    /**
     * 추출된 영수증 정보 저장
     */
    @Override
    public void uploadReceipt(ReceiptVO vo) throws Exception {
        System.out.println("uploadReceipt 메소드 호출됨: " + vo.getOcr_booktitle());
        receiptDAO.insertReceipt(vo);
    }

    /**
     * 전체 영수증 목록 조회
     */
    @Override
    public List<ReceiptVO> getAllReceipts() throws Exception {
        System.out.println("getAllReceipts 메소드 호출됨");
        return receiptDAO.selectAllReceipts();
    }
}
