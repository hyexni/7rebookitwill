package com.itwillbs.persistence;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.itwillbs.controller.AdminNoticeController;
import com.itwillbs.domain.NoticeVO;

@Repository
public class AdminNoticeDAOImpl implements AdminNoticeDAO{
	
	// mylog
	private static final Logger logger = LoggerFactory.getLogger(AdminNoticeController.class);
	
	@Inject
	private SqlSession sqlSession;
	
	// MyBatis 매퍼 namespace
	private static final String NAMESPACE = "com.itwillbs.persistence.AdminNoticeDAO.";

	 
	 ///////////////// 관리자 /////////////////
	@Override
	public void insertNotice(NoticeVO vo) throws Exception {
		sqlSession.insert(NAMESPACE + "insertNotice", vo);
		logger.info(" SQL 실행 완료! ");
		logger.info(" 관리자 공지사항 글쓰기 완료! ");
		
	}
	
	// 공지사항 상세/수정/삭제 메서드
	@Override
	public NoticeVO getNoticeById(int notice_id) throws Exception {
	    return sqlSession.selectOne(NAMESPACE + "getNoticeById", notice_id);
	}

	@Override
	public void updateNotice(NoticeVO vo) throws Exception {
	    sqlSession.update(NAMESPACE + "updateNotice", vo);
	}

	@Override
	public void deleteNotice(int notice_id) throws Exception {
	    sqlSession.delete(NAMESPACE + "deleteNotice", notice_id);
	}

	
	// 페이징된 목록 가져오기
	@Override
	public List<NoticeVO> getNoticeListPage(int startRow, int pageSize) {
	    Map<String, Object> paramMap = new HashMap<>();
	    paramMap.put("startRow", startRow);
	    paramMap.put("pageSize", pageSize);
	    return sqlSession.selectList(NAMESPACE + "getNoticeListPage", paramMap);
	}

	// 전체 개수
	@Override
	public int getNoticeCount() {
	    return sqlSession.selectOne(NAMESPACE + "getNoticeCount");
	}

	
	
	
	 
	 
	 
	 
	 
	
	
	
}