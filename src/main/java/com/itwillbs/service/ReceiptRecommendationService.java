package com.itwillbs.service;

import java.util.List;

public interface ReceiptRecommendationService {

    /**
     * 특정 회원의 영수증 기반 도서 제목 목록을 가져옵니다.
     * @param memberIdx 회원 ID
     * @return 도서 제목 목록
     */
    List<String> getOcrBookTitles(Long member_idx);

    /**
     * 주어진 도서 제목들과 유사한 도서들의 카테고리 ID 목록을 가져옵니다.
     * @param bookTitles 도서 제목 목록
     * @return 중복이 제거된 카테고리 ID 목록
     */
    List<Integer> getRecommendedCategoryIdsByTitles(List<String> book_title);
    
    /**
     *"/"로 구분된 문자열 형태의 도서 제목들을 리스트로 변환합니다.
     * @param bookTitlesString 쉼표로 구분된 도서 제목 문자열
     * @return 도서 제목 리스트
     */
    List<String> parseBookTitles(String bookTitlesString);
    
    /*도서 제목 세분화하기*/
   List<String> splitBookTitlesFromString(String booktitlesString);

}