package com.itwillbs.persistence;

import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.itwillbs.domain.BookVO;
import com.itwillbs.domain.Criteria;

/**
 * BookDAO 인터페이스 구현체
 * - MyBatis SqlSession을 사용한 실제 DB 접근 처리
 */
@Repository
public class BookDAOImpl implements BookDAO {

	// MyBatis SqlSession 주입
	@Inject
	private SqlSession sqlSession;

	// BookMapper.xml namespace 상수
	private static final String NAMESPACE = "com.itwillbs.mapper.BookMapper";

	// 로그 출력용 Logger 객체
	private static final Logger logger = LoggerFactory.getLogger(BookDAOImpl.class);

	/**
	 * [도서 목록 조회]
	 * - 검색, 카테고리, 정렬, 페이징 등 Criteria 기반
	 */
	@Override
	public List<BookVO> getBookList(Criteria criteria) {
		logger.info("getBookList() 호출됨");
		return sqlSession.selectList(NAMESPACE + ".getBookList", criteria);
	}

	/**
	 * [도서 총 개수 조회]
	 * - 페이징 처리를 위한 전체 개수 반환
	 */
	@Override
	public int getBookCount(Criteria criteria) {
		logger.info("getBookCount() 호출됨");
		return sqlSession.selectOne(NAMESPACE + ".getBookCount", criteria);
	}

	/**
	 * [도서 상세 조회]
	 * - 도서 ID(bookId)를 기준으로 1권의 상세 정보 반환
	 */
	@Override
	public BookVO getBookDetail(int bookId) {
		logger.info("getBookDetail() 호출됨 - bookId: {}", bookId);
		return sqlSession.selectOne(NAMESPACE + ".selectBookDetail", bookId);
	}
}