package com.itwillbs.controller;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.itwillbs.domain.BookVO;
import com.itwillbs.domain.ReviewVO;
import com.itwillbs.service.BookService;
import com.itwillbs.service.ReviewService;

@Controller
@RequestMapping("/review")
public class ReviewController {

    @Inject
    private BookService bookService;
    
    @Inject
    private ReviewService reviewService;

    // 📌 로그 객체 생성 - 콘솔에 출력할 로그를 위한 설정
    private static final Logger logger = LoggerFactory.getLogger(ReviewController.class);

    @GetMapping("/test-login")
    public String testLogin(HttpSession session) {
        session.setAttribute("member_idx", 1); // 세션에 테스트 회원 idx 저장
        return "redirect:/review/write?book_id=1"; // 리뷰 작성 페이지로 이동
    }
    
    /**
     * 리뷰 작성 폼 이동
     * - 도서 ID를 받아 해당 도서 정보를 조회 후 화면에 전달
     * - 로그인 여부는 JSP에서 체크 (이미 로그인 상태로 가정)
     */
    @GetMapping("/write")
    public String writeReviewForm(@RequestParam("book_id") int book_id,
                                   Model model, HttpSession session) {
        logger.info("▶ 리뷰 작성 폼 요청 - book_id: {}", book_id);

        // 도서 정보 조회
        BookVO book = bookService.getBookDetail(book_id);
        model.addAttribute("book", book);

        return  "review/review-write"; 
    }
    
    /**
     * 리뷰 등록 처리
     * - 로그인된 사용자의 member_idx를 세션에서 받아 ReviewVO에 설정
     * - 서비스 계층을 통해 DB에 등록 요청
     * - 성공 여부에 따라 메시지 전달 및 리다이렉트
     */
    @PostMapping("/write")
    public String writeReview(@RequestParam("book_id") int book_id,
                              @RequestParam("review_score") int review_score,
                              @RequestParam("review_text") String review_text,
                              @RequestParam(value = "review_image1", required = false) MultipartFile file1,
                              @RequestParam(value = "review_image2", required = false) MultipartFile file2,
                              @RequestParam(value = "review_image3", required = false) MultipartFile file3,
                              HttpSession session,
                              RedirectAttributes rttr) {
        Integer member_idx = (Integer) session.getAttribute("member_idx");
        if (member_idx == null) {
            logger.warn("⚠ 비로그인 상태에서 리뷰 등록 시도");
            return "redirect:/member/login";
        }

        // VO 객체 수동 세팅
        ReviewVO vo = new ReviewVO();
        vo.setBook_id(book_id);
        vo.setMember_idx(member_idx);
        vo.setReview_score(review_score);
        vo.setReview_text(review_text);
        // 이미지 저장 로직은 여기서 생략 가능

        logger.info("▶ 리뷰 등록 요청 - book_id: " + book_id +
                ", member_idx: " + member_idx +
                ", score: " + review_score +
                ", 내용: " + review_text);

        try {
            reviewService.writeReview(vo);
            logger.info("✅ 리뷰 등록 성공!");
            rttr.addFlashAttribute("msg", "리뷰가 등록되었습니다.");
        } catch (Exception e) {
            logger.error("❌ 리뷰 등록 실패 - {}", e.getMessage());
            rttr.addFlashAttribute("errorMsg", "리뷰 등록에 실패했습니다.");
        }

        return "redirect:/book/view?book_id=" + book_id;
    }
}