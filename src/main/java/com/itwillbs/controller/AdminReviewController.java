package com.itwillbs.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.itwillbs.domain.ReviewVO;
import com.itwillbs.service.AdminReviewService;

@Controller
@RequestMapping("/admin")
public class AdminReviewController {

    @Inject
    private AdminReviewService arService;

    @GetMapping("/review_list")
    public String reviewList(@RequestParam(defaultValue = "1") int page,
                             @RequestParam(required = false) String keyword,
                             @RequestParam(value = "status", required = false) String status,
                             @RequestParam(value = "checked", required = false) String checked,
                             Model model) {

        int pageSize = 10;
        int startRow = (page - 1) * pageSize;

     // ✅ 통합 파라미터 Map
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("startRow", startRow);
        paramMap.put("pageSize", pageSize);
        paramMap.put("keyword", keyword);
        paramMap.put("status", status);
        paramMap.put("checked", checked); 

        // ✅ 조건에 맞는 리뷰 목록 + 카운트
        List<ReviewVO> reviewList = arService.getReviewListFiltered(paramMap);
        int totalCount = arService.getReviewCountFiltered(paramMap);
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);

        // 미확인 건수
        int uncheckedCount = arService.getUncheckedReviewCount();
        
        // ✅ 모델에 전달
        model.addAttribute("reviewList", reviewList);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", pageSize);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("keyword", keyword);
        model.addAttribute("status", status);
        model.addAttribute("checked", checked);
        model.addAttribute("uncheckedCount", uncheckedCount);

        return "admin/review_list";
    }
    
    @PostMapping("/review_hide")
    public String hideReview(@RequestParam int review_id, @RequestParam String reason, RedirectAttributes rttr) {
        arService.hideReview(review_id, reason);
        rttr.addFlashAttribute("msg", "리뷰 숨김 처리 완료!");
        rttr.addFlashAttribute("icon", "success");
        return "redirect:/admin/review_list";
    }


    @PostMapping("/review_delete")
    public String deleteReview(@RequestParam("review_id") int review_id,
                               @RequestParam("reason") String reason,
                               RedirectAttributes rttr) {
        arService.deleteReview(review_id, reason);
        rttr.addFlashAttribute("msg", "리뷰 삭제 완료!");
        rttr.addFlashAttribute("icon", "success");
        return "redirect:/admin/review_list";
    }
    
    
    @PostMapping("/review_check")
    public String checkReview(@RequestParam("review_id") int review_id,
    						  @RequestParam(value = "checked", required = false) String checked,
    						  @RequestParam(value = "status",  required = false) String status,
    						  @RequestParam(value = "keyword", required = false) String keyword,
    						  RedirectAttributes rttr) {
    	
    	// 리뷰 확인 처리
        arService.updateReviewChecked(review_id);

        // 성공 메시지 (Flash)
        rttr.addFlashAttribute("msg",  "리뷰 확인 완료!");
        rttr.addFlashAttribute("icon", "success");

        // 필터 상태 유지
        rttr.addAttribute("page",     1);
        rttr.addAttribute("status",   status);
        rttr.addAttribute("checked",  checked);
        rttr.addAttribute("keyword",  keyword);

        return "redirect:/admin/review_list";
    }



}
