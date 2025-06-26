package com.itwillbs.service;

import java.util.List;
import java.util.Map;

import com.itwillbs.domain.ReviewVO;

public interface AdminReviewService {
    List<ReviewVO> getReviewList(int startRow, int pageSize, String keyword);
    int getReviewCount(String keyword);

    // ✅ 숨김 처리용 메서드
    boolean hideReview(int review_id, String reason);

    // ✅ 삭제 처리용 메서드
    boolean deleteReview(int review_id, String reason);
    
    // 리뷰 확인용 메서드
	void updateReviewChecked(int review_id);

	// ✅ 필터(상태 + 검색 + 페이징) 통합 목록
    List<ReviewVO> getReviewListFiltered(Map<String, Object> paramMap);

    // ✅ 필터 통합 총 개수
    int getReviewCountFiltered(Map<String, Object> paramMap);
    
    // 미확인 건수
    int getUncheckedReviewCount();

	
}
