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
    
    @PostMapping("review_hide")
    @ResponseBody
    public String hideReview(@RequestBody Map<String, Object> data) {
        try {
            int reviewId = (int) data.get("review_id");
            String reason = (String) data.get("reason");
            boolean result = arService.hideReview(reviewId, reason);
            return result ? "success" : "fail";
        } catch (Exception e) {
            e.printStackTrace();
            return "fail";
        }
    }


    @PostMapping("review_delete")
    @ResponseBody
    public String deleteReview(@RequestBody Map<String, Object> data) {
        try {
            int reviewId = (int) data.get("review_id");
            String reason = (String) data.get("reason");
            boolean result = arService.deleteReview(reviewId, reason);
            return result ? "success" : "fail";
        } catch (Exception e) {
            e.printStackTrace();
            return "fail";
        }
    }

}
