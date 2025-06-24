package com.itwillbs.persistence;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.itwillbs.domain.BookVO;
import com.itwillbs.dto.BookStatsDTO;

@Repository
public class RecommendDAOImpl implements RecommendDAO {
	
	// mylog
	private static final Logger logger = LoggerFactory.getLogger(RecommendDAOImpl.class);
	
	@Inject
	private SqlSession sqlSession;
	
	private static final String NAMESPACE="com.itwillbs.persistence.RecommendDAO.";

	// 구매 기반 + 정렬 (Map 파라미터)
	@Override
	public List<BookStatsDTO> findRecommendedBooksByPurchaseSorted(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return sqlSession.selectList(
		        NAMESPACE + "findRecommendedBooksByPurchaseSorted",
		        params);
	}

	// 찜 기반 + 정렬 (Map 파라미터)
	@Override
	public List<BookStatsDTO> findRecommendedBooksByWishSorted(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return sqlSession.selectList(
		        NAMESPACE + "findRecommendedBooksByWishSorted",
		        params
	    );
	}
	
	
	
	
	

	
	
	

}