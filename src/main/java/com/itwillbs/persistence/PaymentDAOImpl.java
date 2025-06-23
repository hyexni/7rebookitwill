package com.itwillbs.persistence;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.itwillbs.domain.BookVO;

@Repository
public class PaymentDAOImpl implements PaymentDAO {
	
	@Inject
	private SqlSession sqlSession;
	
	private static final String NAMESPACE = "com.itwillbs.persistence.PaymentDAO.";

	
	
	// 책 정보 가져오기
	@Override
	public BookVO selectBook(int book_id) {

		return sqlSession.selectOne(NAMESPACE + "selectBook", book_id);
	}

	
	// 포인트 정보 가져오기
	@Override
	public int getMemberPoint(int member_idx) {

		return sqlSession.selectOne(NAMESPACE + "getMemberPoint", member_idx);
	}
	
	

	
	
}

















