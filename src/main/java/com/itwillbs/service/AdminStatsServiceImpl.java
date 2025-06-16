package com.itwillbs.service;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.itwillbs.domain.BookStatsDTO;
import com.itwillbs.domain.GenreStatsDTO;
import com.itwillbs.domain.MemberStatsDTO;
import com.itwillbs.persistence.AdminStatsDAO;

@Service // 서비스 객체라고 스프링에 알려주는 애노테이션!
public class AdminStatsServiceImpl implements AdminStatsService { // 인터페이스 구현

	@Inject
	private AdminStatsDAO asDAO;
	
	@Override
	public MemberStatsDTO getMemberStats() {
		
		// 통계 DTO 객체 생성 후, DAO에서 꺼낸 값 넣기!
		MemberStatsDTO dto = new MemberStatsDTO();
		
		dto.setTotalMembers(asDAO.getTotalMembers());
		dto.setTodayNewMembers(asDAO.getTodayNewMembers());
		dto.setMonthNewMembers(asDAO.getMonthNewMembers());
		dto.setActiveMembers(asDAO.getActiveMembers());
		dto.setWithdrawnMembers(asDAO.getWithdrawnMembers());
		
		
		return dto;
		
	}

	
	
	// 2. 인기 장르 추출
	@Override
	public List<GenreStatsDTO> getPopularGenres(Map<String, Object> dateMap) {

		return asDAO.getPopularGenres(dateMap);
	}



	@Override
	public List<BookStatsDTO> getTopSellingBooks() {
		
		return asDAO.getTopSellingBooks();
	}



	@Override
	public List<BookStatsDTO> getTopRatedBooks() {
		
		return asDAO.getTopRatedBooks();
	}
	
	
	
	
	
	

}