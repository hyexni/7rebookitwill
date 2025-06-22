package com.itwillbs.service;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.itwillbs.domain.ReviewVO;
import com.itwillbs.persistence.AdminReviewDAO;

@Service
public class AdminReviewServiceImpl implements AdminReviewService {

    @Inject
    private AdminReviewDAO reviewDAO;

    @Override
    public List<ReviewVO> getReviewList(int startRow, int pageSize, String keyword) {
        return reviewDAO.getReviewList(startRow, pageSize, keyword);
    }

    @Override
    public int getReviewCount(String keyword) {
        return reviewDAO.getReviewCount(keyword);
    }
}
