package com.itwillbs.controller;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.itwillbs.domain.GenreStatsDTO;
import com.itwillbs.domain.MemberStatsDTO;
import com.itwillbs.dto.BookStatsDTO;
import com.itwillbs.service.AdminStatsService;

@Controller
public class AdminStatsController {
	
	@Inject
	private AdminStatsService statsService;
	
	// http://localhost:8088/admin/stats
	// 1. 가입자 수 / 활성 회원 수 조회 기능 
	
	@RequestMapping(value = "/admin/stats", method = RequestMethod.GET)
	public String showAllrStats(
			@RequestParam(value = "startDate", required = false) String startDate,
			@RequestParam(value = "endDate", required = false) String endDate,
			Model model) {
		
		// 날짜 기본값 설정
		LocalDate end = (endDate == null || endDate.isEmpty()) ? 
				LocalDate.now() : LocalDate.parse(endDate);
				
		LocalDate start = (startDate == null || startDate.isEmpty()) ? 
				end.minusMonths(1) : LocalDate.parse(startDate);
		
		String startStr = start.toString();
		String endStr = end.toString();
		
		Map<String, Object> dateMap = new HashMap<>();
		dateMap.put("startDate", startStr);
		dateMap.put("endDate", endStr);
		
		
		// 1. 회원 통계
		MemberStatsDTO stats = statsService.getMemberStats();
		model.addAttribute("stats", stats);
		
		
		// 2. 인기 장르 통계
		List<GenreStatsDTO> genreList = statsService.getPopularGenres(dateMap);
		model.addAttribute("genreList", genreList);
		model.addAttribute("startDate", startDate);
		model.addAttribute("endDate", endDate);
		
		List<BookStatsDTO> topSellingBooks = statsService.getTopSellingBooks();
		List<BookStatsDTO> topRatedBooks = statsService.getTopRatedBooks();
		
		model.addAttribute("topSellingBooks", topSellingBooks);
		model.addAttribute("topRatedBooks", topRatedBooks);
		

		
		return "admin/stats";
	}

}
