package com.itwillbs.service;

import java.util.List;
import java.util.Map;

import com.itwillbs.domain.BookVO;
import com.itwillbs.dto.BookStatsDTO;

public interface RecommendService {
    
	// 구매 이력 여부 확인
	boolean hasPurchaseHistory(int member_idx);
	
	// 찜 이력 여부 확인
	boolean hasWishHistory(int member_idx);
	
    // 구매 기반(파라미터 Map) 정렬용
    List<BookStatsDTO> findRecommendedBooksByPurchaseSorted(Map<String, Object> params) throws Exception;

    // 찜 기반(파라미터 Map) 정렬용 */
    List<BookStatsDTO> findRecommendedBooksByWishSorted    (Map<String, Object> params) throws Exception;

    /**
     * 영수증 OCR 기반 추천 도서 조회 서비스 
     */
    public List<BookStatsDTO> findRecommendedBooksByOcrCategorized(Map<String, Object> params) throws Exception;

}






