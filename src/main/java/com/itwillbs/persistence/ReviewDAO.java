package com.itwillbs.persistence;

import java.util.List;
import com.itwillbs.domain.ReviewVO;
import com.itwillbs.domain.Criteria;

public interface ReviewDAO {
    List<ReviewVO> getReviewList(Criteria criteria);
    int getReviewCount(Criteria criteria);

    // [리뷰 등록]
    void insertReview(ReviewVO vo) throws Exception;
}