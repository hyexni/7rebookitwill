package com.itwillbs.persistence;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.itwillbs.domain.BookVO;
import com.itwillbs.dto.BookStatsDTO;

public interface RecommendDAO {
    
    // 구매 기반 + 정렬 (Map 파라미터)
    List<BookStatsDTO> findRecommendedBooksByPurchaseSorted(Map<String,Object> params);

    // 찜 기반 + 정렬 (Map 파라미터)
    List<BookStatsDTO> findRecommendedBooksByWishSorted    (Map<String,Object> params);
    

    /**
     * 영수증 OCR 기반 추천 도서 조회 메서드 (신규 추가)
     * @param params 카테고리 ID 리스트(categoryIds)와 정렬(sort), 개수(limit)를 담은 Map
     * @return 추천 도서 DTO 리스트
     */
    public List<BookStatsDTO> findRecommendedBooksByOcrCategorized(Map<String, Object> params);
}
    

