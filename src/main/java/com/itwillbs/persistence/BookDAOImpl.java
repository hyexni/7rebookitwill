package com.itwillbs.persistence;

import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.itwillbs.domain.BookVO;
import com.itwillbs.domain.Criteria;

@Repository
public class BookDAOImpl implements BookDAO {

	@Inject
	private SqlSession sqlSession;

	private static final String NAMESPACE = "com.itwillbs.mapper.BookMapper";
	private static final Logger logger = LoggerFactory.getLogger(BookDAOImpl.class);

	/**
	 * [도서 목록 조회] - 검색, 카테고리, 정렬, 페이징 등 Criteria 기반
	 */
	@Override
	public List<BookVO> getBookList(Criteria criteria) {
		logger.info("getBookList() 호출됨");
		return sqlSession.selectList(NAMESPACE + ".getBookList", criteria);
	}

	/**
	 * [도서 총 개수 조회] - Criteria 기반 (페이징 계산용)
	 */
	@Override
	public int getBookCount(Criteria criteria) {
		logger.info("getBookCount() 호출됨");
		return sqlSession.selectOne(NAMESPACE + ".getBookCount", criteria);
	}

}