package com.itwillbs.controller;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.itwillbs.persistence.PointHistoryDAO;
import com.itwillbs.persistence.ReceiptRecommendationDAO;

//import com.itwillbs.persistence.PointHistoryDAO;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "file:src/main/webapp/WEB-INF/spring/root-context.xml" })
public class DAOTest {

	@Inject
	private PointHistoryDAO phDAO;
	@Inject
	private ReceiptRecommendationDAO rdao;

	@Inject
	private SqlSession sqlSession;

	@Test
	public void test1() throws Exception {
//		System.out.println(phDAO);
//		System.out.println(phDAO.toString());
//		System.out.println(phDAO.getPointHistory(1));
		// System.out.println(sqlSession.selectList("com.itwillbs.mapper.PointHistoryMapper.getPointHistory",1));
		//System.out.println(phDAO.getPointHistory(1));
//		System.out.println(rdao);
		System.out.println(rdao.findOcrBookTitlesByMemberIdx(1));
		System.out.println(rdao.findOcrBookTitlesByMemberIdx(1));
	}

}
