package com.itwillbs.service;

import java.util.List;
import java.util.Map;

import com.itwillbs.domain.BookVO;
import com.itwillbs.dto.BookStatsDTO;

public interface RecommendService {
    
    // 구매 기반(파라미터 Map) 정렬용
    List<BookStatsDTO> findRecommendedBooksByPurchaseSorted(Map<String, Object> params) throws Exception;

    // 찜 기반(파라미터 Map) 정렬용 */
    List<BookStatsDTO> findRecommendedBooksByWishSorted    (Map<String, Object> params) throws Exception;

}






