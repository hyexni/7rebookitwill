package com.itwillbs.persistence;

import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.itwillbs.domain.BookReportVO;
import com.itwillbs.domain.ResponseVO;

@Repository
public class BookReportDAOImpl implements BookReportDAO {
	
	// mylog
	private static final Logger logger = LoggerFactory.getLogger(BookReportDAOImpl.class);

	// 디비연결 & mybatis 관련 정보를 처리하는 객체
	@Inject
	private SqlSession sqlSession;
	
	private static final String NAMESPACE="com.itwillbs.mapper.BookReportMapper.";

	@Override
	public void insertBookReport(BookReportVO vo) throws Exception {
		// 1:1 문의 글 입력하는 SQL 구문을 실행
		// 디비연결
		// SQL 구문 & pstmt 객체
		// SQL 실행
		sqlSession.insert(NAMESPACE + "insertBookReport", vo);
		logger.info(" SQL 실행 완료! ");
		logger.info(" 1:1 문의 글쓰기 완료! ");
		
	}

	
	// 1:1 문의 목록
	@Override
	public List<BookReportVO> getBookReportList(int member_idx) {
        // BookReportMapper.xml의 getBookReportList 쿼리 호출
        return sqlSession.selectList(NAMESPACE + "getBookReportList", member_idx);
    }


	@Override
    public BookReportVO getBookReport(int BookReport_id) {
        return sqlSession.selectOne(NAMESPACE + ".getBookReport", BookReport_id);
    }
	
	
	// 답변
	@Override
	public ResponseVO getResponse(int BookReport_id) {
	    return sqlSession.selectOne(NAMESPACE + "getResponse", BookReport_id);
	}
	
	// 수정
	@Override
	public void updateBookReport(BookReportVO vo) throws Exception {
	    sqlSession.update(NAMESPACE + "updateBookReport", vo);
	}

	// 삭제
	@Override
	public void deleteBookReport(int BookReport_id) throws Exception {
	    sqlSession.delete(NAMESPACE + "deleteBookReport", BookReport_id);
	}

	
	
	
	
	
	
	
	
	

}
