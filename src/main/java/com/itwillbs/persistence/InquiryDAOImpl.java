package com.itwillbs.persistence;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.itwillbs.domain.NoticeVO;

@Repository
public class InquiryDAOImpl implements InquiryDAO {
	
	// mylog
	private static final Logger logger = LoggerFactory.getLogger(InquiryDAOImpl.class);

	// 디비연결 & mybatis 관련 정보를 처리하는 객체
	@Inject
	private SqlSession sqlSession;
	
	private static final String NAMESPACE="com.itwillbs.mapper.BoardMapper.";

	
	
	
	@Override
	public void inquiryInsert(NoticeVO vo) throws Exception {
		// 1:1 문의 글 입력하는 SQL 구문을 실행
		// 디비연결
		// SQL 구문 & pstmt 객체
		// SQL 실행
		sqlSession.insert(NAMESPACE + "insertInquiry", vo);
		logger.info(" SQL 실행 완료! ");
		logger.info(" 1:1 문의 글쓰기 완료! ");
		
	}
	
	
	
	
	
	
	

}
