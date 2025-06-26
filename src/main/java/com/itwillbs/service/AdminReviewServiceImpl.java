package com.itwillbs.service;

import java.util.List;
import java.util.Map;

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
	public void updateReviewChecked(int review_id) {
		arDAO.updateReviewChecked(review_id);
		
	}
	
	
	
	// ✅ 필터 + 검색 + 페이징 목록 조회
    @Override
    public List<ReviewVO> getReviewListFiltered(Map<String, Object> paramMap) {
        return arDAO.selectReviewListFiltered(paramMap);
    }

    // ✅ 필터 + 검색 카운트
    @Override
    public int getReviewCountFiltered(Map<String, Object> paramMap) {
        return arDAO.selectReviewCountFiltered(paramMap);
    }
    
    // 미확인 건수
    @Override
    public int getUncheckedReviewCount() {
        return arDAO.countUncheckedReviews();
    }

    
    
}














