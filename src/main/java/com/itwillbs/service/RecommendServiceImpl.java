package com.itwillbs.service;

import java.util.List;
import javax.inject.Inject;
import com.itwillbs.domain.BookVO;
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
	
	// 회원 번호(member_idx)를 기반으로 추천 도서 목록 조회
	@Override
	public List<BookVO> getRecommendBooks(int member_idx) throws Exception {
		
		return rDao.findRecommendedBooks(member_idx);
	}
	

	// 찜 기반 도서 추천
	@Override
	public List<BookVO> getRecommendWishList(int member_idx) {

		return rDao.getRecommendByWishList(member_idx);
	}
	

	// 추천 정렬 기능
	@Override
	public List<BookVO> getRecommendBooks(String sort) {
		// TODO Auto-generated method stub
		return rDao.getRecommendBooksSorted(sort);
	}


	// 추천 정렬 출력 기능
	@Override
	public List<BookVO> getRecommendList(String sort) {
		// TODO Auto-generated method stub
		return rDao.getRecommendList(sort);
	}


	@Override
	public List<BookVO> getRecommendBooksSorted(int member_idx, String sort) throws Exception {
		// DAO에 파라미터 두 개 넘기기
        return rDao.findRecommendedBooksSorted(member_idx, sort);
	}


	 // 통합페이지에서도 정렬 제대로 되게 하려고 새로 만드는 중 (6/16)
	 @Override
	    public List<BookVO> findRecommendedBooksSorted(int member_idx, String sort) throws Exception {
	        return rDao.findRecommendedBooksSorted(member_idx, sort);
    }


	 @Override
	    public List<BookVO> findRecommendedBooks(int member_idx) throws Exception {
	        return rDao.findRecommendedBooks(member_idx);
    }


	// 찜 기반 정렬 메서드 (6/16) 
	@Override
	public List<BookVO> findRecommendedBooksByWishSorted(Integer member_idx, String sort) throws Exception {
		// TODO Auto-generated method stub
		return rDao.findRecommendedBooksByWishSorted(member_idx, sort);
	}
	
	
	

	
	
	
}