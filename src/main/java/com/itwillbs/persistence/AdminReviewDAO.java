package com.itwillbs.persistence;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.itwillbs.domain.ReviewVO;

public interface AdminReviewDAO {
    List<ReviewVO> getReviewList(@Param("startRow") int startRow,
                                 @Param("pageSize") int pageSize,
                                 @Param("keyword") String keyword);

    int getReviewCount(@Param("keyword") String keyword);
    ReviewVO getReviewById(@Param("review_id") int review_id);

    void hideReview(@Param("review_id") int review_id, @Param("reason") String reason);
    void deleteReview(@Param("review_id") int review_id, @Param("reason") String reason);

    void updateReviewChecked(int review_id);
    
    
    // 필터 + 검색 + 페이징 전체 포함된 리뷰 목록 조회
    List<ReviewVO> selectReviewListFiltered(Map<String, Object> paramMap);

    // 필터 + 검색 포함된 전체 개수 조회
    int selectReviewCountFiltered(Map<String, Object> paramMap);

    // 미확인 건수
    int countUncheckedReviews();

}

