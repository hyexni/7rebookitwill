package com.itwillbs.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;
import org.springframework.ui.Model;

import com.itwillbs.dto.BookStatsDTO;

import javax.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import com.itwillbs.service.RecommendService;

@Controller
@RequestMapping(value = "/recommend")
public class RecommendController {

	@Inject
	private RecommendService recommendService;
	
	// mylog
	private static final Logger logger = LoggerFactory.getLogger(RecommendController.class);

	// http://localhost:8088/recommend/byPurchase
	// 구매 기반 추천 (GET)
	@RequestMapping(value = "/byPurchase", method = RequestMethod.GET)
	public String recommendByPurchase(
			HttpSession session, 
			@RequestParam(value="sort", required=false, defaultValue="") String sort,
			Model model) throws Exception {
		logger.info(" recommendByPurchase() 호출 ");

		// member_idx가 없으면 로그인 페이지로 이동
		Integer memberIdx = (Integer) session.getAttribute("member_idx");
		    if (memberIdx == null) {
		        return "redirect:/member/login?needLogin=true";
	    }
		
	    // 파라미터 구성
	    Map<String, Object> param = new HashMap<>();
	    param.put("member_idx", memberIdx);
	    param.put("sort", sort);
	    param.put("limit", 10);

	    // 구매 기반 추천만 사용
	    List<BookStatsDTO> purchaseList = recommendService.findRecommendedBooksByPurchaseSorted(param);

	    model.addAttribute("purchaseList", purchaseList);
	    model.addAttribute("currentSort", sort);
		  
		  return "recommend/purchase";
	}
	
	// ================================================================================
	// http://localhost:8088/recommend/byWishlist
	// 찜한 도서 기반 추천 (GET)
	@RequestMapping(value = "/byWishlist", method = RequestMethod.GET)
	public String recommendByWishlist(HttpSession session,
						            @RequestParam(value = "sort", required = false, defaultValue="") String sort,
						            Model model) throws Exception {
		logger.info(" recommendByWishlist() 호출 ");
		
		// member_idx가 없으면 로그인 페이지로 이동
		Integer memberIdx = (Integer) session.getAttribute("member_idx");
		    if (memberIdx == null) {
		        return "redirect:/member/login?needLogin=true";
	    }
		
	    Map<String, Object> param = new HashMap<>();
	    param.put("member_idx", memberIdx);
	    param.put("sort", sort);
	    param.put("limit", 10);

	    List<BookStatsDTO> wishList = recommendService.findRecommendedBooksByWishSorted(param);

	    model.addAttribute("wishList", wishList);
	    model.addAttribute("currentSort", sort);
		
		return "recommend/wishlist";
	}
	
	// ================================================================================
	// http://localhost:8088/recommend/sort
	// 추천 리스트 정렬 기능 (GET)
	@RequestMapping(value = "/sort", method = RequestMethod.GET)
	public String sortPage(HttpSession session) {
		Integer member_idx = (Integer) session.getAttribute("member_idx");
	    if (member_idx == null) {
	        return "redirect:/member/login?needLogin=true";
	    }
		
	    return "recommend/sort"; 
	}
	
	
	// ========================================================================
	// http://localhost:8088/recommend/all
	// 추가함!!! 6/16 (로그인 기능이 현재 없어 강제로 세팅)
	@GetMapping("/all")
	public String recommendAll(HttpSession session,
	                           @RequestParam(value = "sort", required = false, defaultValue="") String sort,
	                           Model model) throws Exception {

		Integer memberIdx = (Integer) session.getAttribute("member_idx");
	    if (memberIdx == null) {
	        return "redirect:/member/login?needLogin=true";
	    }

	    // null-safe sort
	    String safeSort = sort == null ? "" : sort;
	    
	    // (2) 파라미터 맵 구성
	    Map<String,Object> param = new HashMap<>();
	    param.put("member_idx", memberIdx);
	    param.put("sort",      sort);
	    param.put("limit",     10);   // 원하는 개수

	    // 1) 구매 기반 추천 + 정렬
	    List<BookStatsDTO> purchaseList
	        = recommendService.findRecommendedBooksByPurchaseSorted(param);

	    // 2) 찜 기반 추천 + 정렬
	    List<BookStatsDTO> wishList
	        = recommendService.findRecommendedBooksByWishSorted(param);

	    // 뷰로 넘기기
	    model.addAttribute("purchaseList", purchaseList);
	    model.addAttribute("wishList",     wishList);
	    model.addAttribute("currentSort",  sort);
	    return "recommend/recommend_page";

	}
	

} // RecommendController