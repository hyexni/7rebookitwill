package com.itwillbs.service;

import java.util.List;
import java.util.Map;

import com.itwillbs.domain.BookStatsDTO;
import com.itwillbs.domain.GenreStatsDTO;
import com.itwillbs.domain.MemberStatsDTO;

public interface AdminStatsService {
	
	// 1. 가입자 수, 활성 회원 수 조회
	MemberStatsDTO getMemberStats();
	
	// 2. 인기 장르 추출
	List<GenreStatsDTO> getPopularGenres(Map<String, Object> dateMap);
	
	public List<BookStatsDTO> getTopSellingBooks();
	public List<BookStatsDTO> getTopRatedBooks();
	
	
}