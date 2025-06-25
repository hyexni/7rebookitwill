package com.itwillbs.service;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.itwillbs.domain.ReviewVO;
import com.itwillbs.persistence.AdminReviewDAO;

@Service
public class AdminReviewServiceImpl implements AdminReviewService {

    @Inject
    private AdminReviewDAO arDAO;

    @Override
    public List<ReviewVO> getReviewList(int startRow, int pageSize, String keyword) {
        return arDAO.getReviewList(startRow, pageSize, keyword);
    }

    @Override
    public int getReviewCount(String keyword) {
        return arDAO.getReviewCount(keyword);
    }
    
    // 리뷰 숨김
    @Override
    public boolean hideReview(int review_id, String reason) {
        try {
            arDAO.hideReview(review_id, reason);
            arDAO.updateReviewChecked(review_id); // ✅ 확인 처리 추가
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean deleteReview(int review_id, String reason) {
        try {
            arDAO.deleteReview(review_id, reason);
            arDAO.updateReviewChecked(review_id); // ✅ 확인 처리 추가
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    

	@Override
	public void updateReviewChecked(int reviewId) {
		arDAO.updateReviewChecked(reviewId);
		
	}

    
}


