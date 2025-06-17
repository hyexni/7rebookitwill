package com.itwillbs.persistence;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.itwillbs.domain.BookStatsDTO;
import com.itwillbs.domain.BookVO;

@Repository
public class RecommendDAOImpl implements RecommendDAO {
	
	// mylog
	private static final Logger logger = LoggerFactory.getLogger(RecommendDAOImpl.class);
	
	@Inject
	private SqlSession sqlSession;
	
	private static final String NAMESPACE="com.itwillbs.mapper.recommendMapper.";
	
	// 회원 번호(member_idx)를 기반으로 추천 도서 목록 조회
	@Override
	public List<BookVO> findRecommendedBooks(int member_idx) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectList(NAMESPACE + "findRecommendedBooks", member_idx);
	}

	// 찜 기반 도서 추천
	@Override
	public List<BookVO> getRecommendByWishList(int member_idx) {
		// TODO Auto-generated method stub
		return sqlSession.selectList(NAMESPACE + "getRecommendByWishList", member_idx);
	}

	// 추천 정렬 기능
	@Override
	public List<BookVO> getRecommendBooksSorted(String sort) {
		// TODO Auto-generated method stub
		return sqlSession.selectList(NAMESPACE + "getRecommendBooksSorted", sort);
	}

	// 추천 정렬 출력 기능
	@Override
	public List<BookVO> getRecommendList(String sort) {
		// TODO Auto-generated method stub
		return sqlSession.selectList(NAMESPACE + "getRecommendList", sort);
	}

	// 새로 추가 ..
	@Override
	public List<BookVO> findRecommendedBooksSorted(int member_idx, String sort) throws Exception {
	    Map<String,Object> param = new HashMap<>();
	    param.put("member_idx", member_idx);
	    param.put("sort", sort);
	    return sqlSession.selectList(
	        NAMESPACE + "findRecommendedBooksByPurchaseSorted",  // <-- 기존 id
	        param
	    );
	}
	
	// 찜 기반 정렬
	@Override
	public List<BookVO> findRecommendedBooksByWishSorted(int member_idx, String sort) throws Exception {
	    Map<String,Object> param = new HashMap<>();
	    param.put("member_idx", member_idx);
	    param.put("sort", sort);
	    return sqlSession.selectList(
	        NAMESPACE + "findRecommendedBooksByWishSorted",      // <-- 기존 id
	        param
	    );
	}

	@Override
	public List<BookStatsDTO> findRecommendedBooksByPurchaseSorted(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return sqlSession.selectList(
		        NAMESPACE + "findRecommendedBooksByPurchaseSorted",
		        params);
	}

	@Override
	public List<BookStatsDTO> findRecommendedBooksByWishSorted(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return sqlSession.selectList(
		        NAMESPACE + "findRecommendedBooksByWishSorted",
		        params
	    );
	}
	
	
	
	
	

	
	
	

}