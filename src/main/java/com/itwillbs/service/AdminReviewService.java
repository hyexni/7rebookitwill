package com.itwillbs.service;

import java.util.List;

import com.itwillbs.domain.ReviewVO;

public interface AdminReviewService {
    List<ReviewVO> getReviewList(int startRow, int pageSize, String keyword);
    int getReviewCount(String keyword);

    // ✅ 숨김 처리용 메서드
    boolean hideReview(int review_id, String reason);

    // ✅ 삭제 처리용 메서드
    boolean deleteReview(int review_id, String reason);
    
    // 리뷰 확인용 메서드
	void updateReviewChecked(int reviewId);

}
