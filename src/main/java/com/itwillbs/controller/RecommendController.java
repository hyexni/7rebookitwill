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

import com.itwillbs.service.ReceiptRecommendationService;
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
	    param.put("limit", 5);

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
	    param.put("limit", 5);

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
	    param.put("limit",     5);   // 원하는 개수

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
	
	
	 // (신규) 영수증 카테고리 분석용 서비스
    @Inject
    private ReceiptRecommendationService receiptService;
    
   
    // [신규 추가] http://localhost:8088/recommend/byReceipt
    // 영수증 기반 추천 (GET)
    @GetMapping("/byReceipt")
    public String recommendByReceipt(HttpSession session,
                                     @RequestParam(value = "sort", required = false, defaultValue = "") String sort,
                                     Model model) throws Exception {
        logger.info(" recommendByReceipt() 호출 ");

        // 1. 로그인 확인
        Integer memberIdx = (Integer) session.getAttribute("member_idx");
        if (memberIdx == null) {
            return "redirect:/member/login?needLogin=true";
        }

        // 2. [영수증 서비스 호출] 회원의 OCR 도서 제목 목록 조회
        List<String> ocrBookTitles = receiptService.getOcrBookTitles(memberIdx);

        if (ocrBookTitles == null || ocrBookTitles.isEmpty()) {
            logger.info(memberIdx + "번 회원의 OCR 도서 기록이 없어 추천할 수 없습니다.");
            model.addAttribute("receiptList", null); // View에서 분기 처리를 위해 null 전달
            return "recommend/receipt"; // 영수증 추천 결과 페이지로 이동
        }

        // 3. [영수증 서비스 호출] 도서 제목들로 추천 카테고리 ID 목록 조회
        List<Integer> recommendedCategoryIds = receiptService.getRecommendedCategoryIdsByTitles(ocrBookTitles);
        
        if (recommendedCategoryIds == null || recommendedCategoryIds.isEmpty()) {
            logger.info("OCR 기반 추천 카테고리를 찾을 수 없습니다.");
            model.addAttribute("receiptList", null);
            return "recommend/receipt";
        }
        
        logger.info("추천 대상 카테고리 ID 목록: " + recommendedCategoryIds);

        // 4. [추천 서비스 호출] 카테고리 ID 목록으로 최종 도서 추천
        Map<String, Object> param = new HashMap<>();
        param.put("categoryIds", recommendedCategoryIds); // MyBatis foreach에서 사용할 리스트
        param.put("sort", sort);
        param.put("limit", 5); // 추천할 도서 개수

        List<BookStatsDTO> receiptList = recommendService.findRecommendedBooksByOcrCategorized(param);

        // 5. 뷰에 결과 전달
        model.addAttribute("receiptList", receiptList);
        model.addAttribute("currentSort", sort);

        return "recommend/receipt"; // recommend 폴더 밑의 receipt.jsp
    }
	

} // RecommendController