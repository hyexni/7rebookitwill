package com.itwillbs.controller;

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
                             Model model) {

        int pageSize = 10;
        int startRow = (page - 1) * pageSize;

        List<ReviewVO> reviewList = arService.getReviewList(startRow, pageSize, keyword);
        int totalCount = arService.getReviewCount(keyword);
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);

        model.addAttribute("reviewList", reviewList);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", pageSize);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("keyword", keyword);

        return "admin/review_list";
    }
    
    @PostMapping("/review_hide")
    public String hideReview(@RequestParam int review_id, @RequestParam String reason, RedirectAttributes rttr) {
        arService.hideReview(review_id, reason);
        rttr.addFlashAttribute("msg", "리뷰 숨김 처리 완료!");
        
        System.out.println("🔥 숨김 요청 review_id: " + review_id);
        System.out.println("🔥 숨김 사유: " + reason);

        
        return "redirect:/admin/review_list";
    }


    @PostMapping("/review_delete")
    public String deleteReview(@RequestParam("review_id") int reviewId,
                               @RequestParam("reason") String reason,
                               RedirectAttributes rttr) {
        arService.deleteReview(reviewId, reason);
        rttr.addFlashAttribute("msg", "리뷰 삭제 완료!");
        return "redirect:/admin/review_list";
    }


}
