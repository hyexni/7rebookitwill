package com.itwillbs.service;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.itwillbs.domain.Criteria;
import com.itwillbs.domain.ReviewVO;
import com.itwillbs.persistence.ReviewDAO;

@Service
public class ReviewServiceImpl implements ReviewService {

    @Inject
    private ReviewDAO reviewDAO;

    // [리뷰 목록 조회]
    @Override
    public List<ReviewVO> getReviewList(Criteria criteria) {
        return reviewDAO.getReviewList(criteria);
    }

    // [리뷰 개수 조회]
    @Override
    public int getReviewCount(Criteria criteria) {
        return reviewDAO.getReviewCount(criteria);
    }

    // [리뷰 등록 처리]
    @Override
    public void writeReview(ReviewVO vo) throws Exception {
        reviewDAO.insertReview(vo);
    }

}