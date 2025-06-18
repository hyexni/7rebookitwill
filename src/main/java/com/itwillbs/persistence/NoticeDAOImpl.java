package com.itwillbs.persistence;

import java.util.List;

import javax.inject.Inject;
import javax.xml.stream.events.Namespace;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.itwillbs.domain.NoticeVO;

@Repository
public class NoticeDAOImpl implements NoticeDAO{
	
	@Inject
	private SqlSession sqlSession;
	
	// MyBatis 매퍼 namespace
	private static final String NAMESPACE = "com.itwillbs.mapper.noticeMapper.";

	@Override
	public List<NoticeVO> getAllNotices() throws Exception {
		// noticeMapper.xml에 정의된 id="getAllNotices" 호출
		return sqlSession.selectList(NAMESPACE + "getAllNotices");
	}
	
	

}
