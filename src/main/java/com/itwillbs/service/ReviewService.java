package com.itwillbs.service;

import java.util.List;

import com.itwillbs.domain.Criteria;
import com.itwillbs.domain.ReviewVO;

public interface ReviewService {

    // [리뷰 목록 조회]
    List<ReviewVO> getReviewList(Criteria criteria);

    // [리뷰 개수 조회]
    int getReviewCount(Criteria criteria);

    // [리뷰 등록 처리]
    void writeReview(ReviewVO vo) throws Exception;

}