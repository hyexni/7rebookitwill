package com.itwillbs.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.itwillbs.domain.ReviewVO;

public interface AdminReviewDAO {
    List<ReviewVO> getReviewList(@Param("startRow") int startRow,
                                 @Param("pageSize") int pageSize,
                                 @Param("keyword") String keyword);

    int getReviewCount(@Param("keyword") String keyword);
    ReviewVO getReviewById(@Param("review_id") int review_id);

    void hideReview(@Param("review_id") int review_id);
    void deleteReview(@Param("review_id") int review_id);
}

