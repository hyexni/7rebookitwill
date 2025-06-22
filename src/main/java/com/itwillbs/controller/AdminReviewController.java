package com.itwillbs.controller;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.itwillbs.domain.ReviewVO;
import com.itwillbs.service.AdminReviewService;

@Controller
@RequestMapping("/admin")
public class AdminReviewController {

    @Inject
    private AdminReviewService reviewService;

    @GetMapping("/review_list")
    public String reviewList(@RequestParam(defaultValue = "1") int page,
                             @RequestParam(required = false) String keyword,
                             Model model) {

        int pageSize = 10;
        int startRow = (page - 1) * pageSize;

        List<ReviewVO> reviewList = reviewService.getReviewList(startRow, pageSize, keyword);
        int totalCount = reviewService.getReviewCount(keyword);
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);

        model.addAttribute("reviewList", reviewList);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", pageSize);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("keyword", keyword);

        return "admin/review_list";
    }
}
