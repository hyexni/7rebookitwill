package com.itwillbs.persistence;

import java.util.List;
import java.util.Map;

import com.itwillbs.domain.BookStatsDTO;
import com.itwillbs.domain.GenreStatsDTO;

public interface AdminStatsDAO {
	
	// 1. 가입자 수, 활성 회원 수 조회
	int getTotalMembers();
	int getTodayNewMembers();
	int getMonthNewMembers();
	int getActiveMembers();
	int getWithdrawnMembers();
	
	// 2. 인기 장르 추출
	List<GenreStatsDTO> getPopularGenres(Map<String, Object> dateMap);
	
		// 1) 도서별 판매량 상위 5개
		List<BookStatsDTO> getTopSellingBooks();
	
		// 2) 별점 평균 높은 도서 상위 5개
		List<BookStatsDTO> getTopRatedBooks();
		
		
}