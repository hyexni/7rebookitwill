package com.itwillbs.persistence;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.itwillbs.domain.BookStatsDTO;
import com.itwillbs.domain.GenreStatsDTO;

@Repository
public class AdminStatsDAOImpl implements AdminStatsDAO {
	
	@Inject
	private SqlSession sqlSession;
	
	private static final String NAMESPACE = "com.itwillbs.mapper.adminStatsMapper.";

	// 1. 가입자 수, 활성 회원 수 조회
	@Override
	public int getTotalMembers() {
		
		return sqlSession.selectOne(NAMESPACE + "getTotalMembers");
	}

	@Override
	public int getTodayNewMembers() {

		return sqlSession.selectOne(NAMESPACE + "getTodayNewMembers");
	}

	@Override
	public int getMonthNewMembers() {

		return sqlSession.selectOne(NAMESPACE + "getMonthNewMembers");
	}

	@Override
	public int getActiveMembers() {

		return sqlSession.selectOne(NAMESPACE + "getActiveMembers");
	}

	@Override
	public int getWithdrawnMembers() {

		return sqlSession.selectOne(NAMESPACE + "getWithdrawnMembers");
	}

	// 2. 인기 장르 추출
	@Override
	public List<GenreStatsDTO> getPopularGenres(Map<String, Object> dateMap) {

		return sqlSession.selectList(NAMESPACE + "getPopularGenres", dateMap);
	}

	@Override
	public List<BookStatsDTO> getTopSellingBooks() {

		return sqlSession.selectList("com.itwillbs.mapper.adminStatsMapper.getTopSellingBooks");
	}

	@Override
	public List<BookStatsDTO> getTopRatedBooks() {

		return sqlSession.selectList("com.itwillbs.mapper.adminStatsMapper.getTopRatedBooks");
	}
	
	
	
	
	

}