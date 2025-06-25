package com.itwillbs.persistence;

import java.util.List;

public interface ReceiptRecommendationDAO {

    /**
     * 특정 회원의 모든 ocr_booktitle을 조회합니다.
     * @param memberIdx 회원 ID
     * @return ocr_booktitle 목록
     */
    List<String> findOcrBookTitlesByMemberIdx(Integer member_idx);

    /**
     * 주어진 제목과 유사한(포함하는) 도서들의 category_id를 조회합니다.
     * @param title 검색할 도서 제목의 일부
     * @return category_id 목록
     */
    List<Integer> findCategoryIdsBySimilarTitle(String ocr_booktitle);
    
    
   
}