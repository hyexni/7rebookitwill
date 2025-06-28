package com.itwillbs.persistence;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.itwillbs.domain.InquiryVO;
import com.itwillbs.domain.ResponseVO;

@Repository
public class InquiryDAOImpl implements InquiryDAO {
	
	// mylog
	private static final Logger logger = LoggerFactory.getLogger(InquiryDAOImpl.class);

	// 디비연결 & mybatis 관련 정보를 처리하는 객체
	@Inject
	private SqlSession sqlSession;
	
	private static final String NAMESPACE="com.itwillbs.persistence.InquiryDAO.";

	@Override
	public void insertInquiry(InquiryVO vo) throws Exception {
		// 1:1 문의 글 입력하는 SQL 구문을 실행
		// 디비연결
		// SQL 구문 & pstmt 객체
		// SQL 실행
		sqlSession.insert(NAMESPACE + "insertInquiry", vo);
		logger.info(" SQL 실행 완료! ");
		logger.info(" 1:1 문의 글쓰기 완료! ");
		
	}

	
	// 1:1 문의 목록
	@Override
	public List<InquiryVO> getInquiryListPage(Map<String, Object> paramMap) {
		
        return sqlSession.selectList(NAMESPACE + "getInquiryListPage", paramMap);
    }
	
	@Override
	public int getInquiryCount(int member_idx) {
	    return sqlSession.selectOne(NAMESPACE + "getInquiryCount", member_idx);
	}


	@Override
    public InquiryVO getInquiry(int inquiry_id) {
        return sqlSession.selectOne(NAMESPACE + ".getInquiry", inquiry_id);
    }
	
	
	// 답변
	@Override
	public ResponseVO getResponse(int inquiry_id) {
	    return sqlSession.selectOne(NAMESPACE + "getResponse", inquiry_id);
	}
	
	// 수정
	@Override
	public void updateInquiry(InquiryVO vo) throws Exception {
	    sqlSession.update(NAMESPACE + "updateInquiry", vo);
	}

	// 삭제
	@Override
	public void deleteInquiry(int inquiry_id) throws Exception {
	    sqlSession.delete(NAMESPACE + "deleteInquiry", inquiry_id);
	}

	
	
	
	
	
	
	
	
	

}
