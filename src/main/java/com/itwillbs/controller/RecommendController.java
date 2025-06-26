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
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

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
	    boolean hasPurchaseHistory = recommendService.hasPurchaseHistory(memberIdx); // ✅ 추가!
	    
	    model.addAttribute("purchaseList", purchaseList);
	    model.addAttribute("currentSort", sort);
	    model.addAttribute("hasPurchaseHistory", hasPurchaseHistory); // ✅ 추가!
	    
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
	    boolean hasWishHistory = recommendService.hasWishHistory(memberIdx); // ✅ 추가!

	    model.addAttribute("wishList", wishList);
	    model.addAttribute("currentSort", sort);
	    model.addAttribute("hasWishHistory", hasWishHistory); // ✅ 추가!
		
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
	    
	    // 🟡 이력 여부
	    boolean hasPurchaseHistory = recommendService.hasPurchaseHistory(memberIdx);
	    boolean hasWishHistory = recommendService.hasWishHistory(memberIdx);
	    
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
	    
	    // ⬇️ 이거 추가하면 문제 해결
	    model.addAttribute("hasPurchaseHistory", hasPurchaseHistory);
	    model.addAttribute("hasWishHistory", hasWishHistory);
	    
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
    
 // ========================================================================
    // [신규 추가] 팝업을 위한 영수증 기반 추천 "데이터(JSON)"를 제공하는 API
    // JavaScript(AJAX)가 이 주소를 호출하여 팝업에 표시할 데이터를 가져갑니다.
    @GetMapping("/api/receipt-for-popup")
    @ResponseBody // 중요! 이 어노테이션이 붙으면 JSP가 아닌 순수 데이터(JSON)를 반환합니다.
    public ResponseEntity<List<BookStatsDTO>> getReceiptRecommendationsForPopup(HttpSession session) {
        logger.info(" getReceiptRecommendationsForPopup() API 호출 ");
        
        // 1. 로그인 확인
        Integer memberIdx = (Integer) session.getAttribute("member_idx");
        if (memberIdx == null) {
            // 로그인하지 않은 사용자에게는 권한 없음(401) 상태를 반환합니다.
            return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
        }

        try {
            // 2. 영수증 서비스로 추천 카테고리 ID 조회
            List<String> ocrBookTitles = receiptService.getOcrBookTitles(memberIdx);
            if (ocrBookTitles == null || ocrBookTitles.isEmpty()) {
                // 추천할 내용이 없으면 내용 없음(204) 상태를 반환합니다.
                return new ResponseEntity<>(HttpStatus.NO_CONTENT); 
            }
            List<Integer> recommendedCategoryIds = receiptService.getRecommendedCategoryIdsByTitles(ocrBookTitles);
            if (recommendedCategoryIds == null || recommendedCategoryIds.isEmpty()) {
                return new ResponseEntity<>(HttpStatus.NO_CONTENT);
            }

            // 3. 추천 서비스로 최종 도서 목록 조회
            Map<String, Object> param = new HashMap<>();
            param.put("categoryIds", recommendedCategoryIds);
            // param.put("sort", "popular"); // 팝업에서는 인기순 또는 최신순으로 고정하는 것이 좋음
            param.put("limit", 4); // 팝업에는 4개 정도만 간결하게 보여줌

            List<BookStatsDTO> receiptList = recommendService.findRecommendedBooksByOcrCategorized(param);

            // 4. 조회된 도서 목록을 성공(200 OK) 상태와 함께 반환합니다.
            return new ResponseEntity<>(receiptList, HttpStatus.OK);

        } catch (Exception e) {
            logger.error("팝업용 추천 데이터 조회 중 오류 발생", e);
            // 서버 내부 오류(500)가 발생했음을 알립니다.
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
    
    
	

} // RecommendController