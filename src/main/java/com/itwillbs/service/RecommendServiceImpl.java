package com.itwillbs.service;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import com.itwillbs.dto.BookStatsDTO;
import com.itwillbs.persistence.RecommendDAO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service
public class RecommendServiceImpl implements RecommendService {
	
	// mylog
	private static final Logger logger = LoggerFactory.getLogger(RecommendServiceImpl.class);
	
	// RecommendDAO 객체 필요 => 객체를 주입받아서 사용
	@Inject
	private RecommendDAO rDao;

	// 구매 이력 여부 확인
	@Override
	public boolean hasPurchaseHistory(int member_idx) {
		return rDao.countUserPurchases(member_idx) > 0;
	}

	// 찜 이력 여부 확인
	@Override
	public boolean hasWishHistory(int member_idx) {
		int count = rDao.countUserWishes(member_idx);
		System.out.println("찜 개수: " + count);
		return count > 0;
	}

	// 찜 기반 정렬 메서드 (6/16) 
    @Override
    public List<BookStatsDTO> findRecommendedBooksByPurchaseSorted(Map<String, Object> params) throws Exception {
        // DAO 쪽 XML id="findRecommendedBooksByPurchaseSorted" 호출
        return rDao.findRecommendedBooksByPurchaseSorted(params);
    }

    @Override
    public List<BookStatsDTO> findRecommendedBooksByWishSorted(Map<String, Object> params) throws Exception {
        // DAO 쪽 XML id="findRecommendedBooksByWishSorted" 호출
        return rDao.findRecommendedBooksByWishSorted(params);
    }
	
	
	
 // 영수증 OCR 기반 추천
    @Override
    public List<BookStatsDTO> findRecommendedBooksByOcrCategorized(Map<String, Object> params) throws Exception {
        return rDao.findRecommendedBooksByOcrCategorized(params);
    }
	

	
	
	
}