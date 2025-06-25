package com.itwillbs.controller;

import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.itwillbs.service.ReceiptRecommendationService;

@RestController
@RequestMapping("/recommendations")
public class ReceiptRecommendationController {

    private static final Logger logger = LoggerFactory.getLogger(ReceiptRecommendationController.class);

    @Inject
    private ReceiptRecommendationService rService;

    /**
     * 로그인된 회원의 영수증 기반 도서 추천 카테고리를 조회하는 API
     * @param session HttpSession 객체 (로그인 정보 확인용)
     * @return 추천 카테고리 ID 목록을 담은 ResponseEntity 객체
     */
    @GetMapping("/receipt-based")
    public ResponseEntity<List<Integer>> getReceiptBasedRecommendations(HttpSession session) {
        logger.debug("Controller: /recommendations/receipt-based 호출");

        // 1. 세션에서 회원 ID 가져오기
        Integer member_idx = (Integer) session.getAttribute("member_idx"); 
        // "member_idx"는 실제 세션에 저장된 키값으로 변경해야 합니다.

        if (member_idx == null) {
            logger.warn("로그인되지 않은 사용자의 접근");
            // 로그인되지 않았을 경우, 권한 없음(401) 또는 잘못된 요청(400) 상태 코드 반환
            return new ResponseEntity<>(HttpStatus.UNAUTHORIZED); 
        }

        try {
            // 2. 서비스를 통해 회원의 OCR 도서 제목 목록 조회
            List<String> ocrBookTitles = rService.getOcrBookTitles(member_idx);

            System.out.println(ocrBookTitles);
            
            if (ocrBookTitles == null || ocrBookTitles.isEmpty()) {
                logger.info(member_idx + "번 회원의 OCR 도서 기록이 없습니다.");
                // 내용 없음(204) 또는 빈 리스트와 함께 정상(200) 응답 가능
                return new ResponseEntity<>(HttpStatus.NO_CONTENT); 
            }

            // 3. 조회된 도서 제목들로 추천 카테고리 ID 목록 조회
            List<Integer> recommendedCategoryIds = rService.getRecommendedCategoryIdsByTitles(ocrBookTitles);

            logger.info("추천 카테고리 ID 목록: " + recommendedCategoryIds);
            
            // 4. 결과 반환
            return new ResponseEntity<>(recommendedCategoryIds, HttpStatus.OK);

        } catch (Exception e) {
            logger.error("영수증 기반 추천 조회 중 오류 발생", e);
            // 서버 내부 오류(500) 상태 코드 반환
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}