package com.itwillbs.controller;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.itwillbs.domain.BookVO;
import com.itwillbs.domain.MemberVO;
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

  
    
    /**
     * 리뷰 작성 폼 이동
     * - 도서 ID를 받아 해당 도서 정보를 조회 후 화면에 전달
     * - 로그인 여부는 JSP에서 체크 (이미 로그인 상태로 가정)
     */
    @GetMapping("/write")
    public String writeReviewForm(@RequestParam("book_id") int book_id,
                                   Model model) {
        logger.info(" 리뷰 작성 폼 요청 - book_id: {}", book_id);

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
    	MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
        if (loginUser == null) {
            logger.warn("⚠ 비로그인 상태에서 리뷰 등록 시도");
            return "redirect:/member/login";
        }
        int member_idx = loginUser.getMember_idx();

        // VO 객체 수동 세팅
        ReviewVO vo = new ReviewVO();
        vo.setBook_id(book_id);
        vo.setMember_idx(member_idx);
        vo.setReview_score(review_score);
        vo.setReview_text(review_text);
        
        // 파일 저장 경로 설정
        String uploadDir = session.getServletContext().getRealPath("/resources/upload");

        // 폴더 없으면 자동 생성
        File uploadFolder = new File(uploadDir);
        if (!uploadFolder.exists()) {
            uploadFolder.mkdirs(); // 자동 생성
        }
        
        // file1 저장
        if (file1 != null && !file1.isEmpty()) {
            String fileName1 = UUID.randomUUID().toString() + "_" + file1.getOriginalFilename();
            try {
                file1.transferTo(new File(uploadDir, fileName1));
                vo.setReview_image1(fileName1);
            } catch (IOException e) {
                logger.error("❌ 이미지1 저장 실패: {}", e.getMessage());
            }
        }

        // file2 저장
        if (file2 != null && !file2.isEmpty()) {
            String fileName2 = UUID.randomUUID().toString() + "_" + file2.getOriginalFilename();
            try {
                file2.transferTo(new File(uploadDir, fileName2));
                vo.setReview_image2(fileName2);
            } catch (IOException e) {
                logger.error("❌ 이미지2 저장 실패: {}", e.getMessage());
            }
        }

        // file3 저장
        if (file3 != null && !file3.isEmpty()) {
            String fileName3 = UUID.randomUUID().toString() + "_" + file3.getOriginalFilename();
            try {
                file3.transferTo(new File(uploadDir, fileName3));
                vo.setReview_image3(fileName3);
            } catch (IOException e) {
                logger.error("❌ 이미지3 저장 실패: {}", e.getMessage());
            }
        }
        
      
        try {
            reviewService.writeReview(vo);
            logger.info(" 리뷰 등록 성공!");
            rttr.addFlashAttribute("msg", "리뷰가 등록되었습니다.");
        } catch (Exception e) {
            logger.error(" 리뷰 등록 실패 - " + e.getMessage());
            rttr.addFlashAttribute("errorMsg", "리뷰 등록에 실패했습니다.");
        }

        return "redirect:/book/view?book_id=" + book_id + "&sort=recent";
    }
    
  
    // ✅ 리뷰 수정 처리 (POST 요청)
    // ✅ 리뷰 수정 처리 (POST 요청, 이미지 삭제 체크박스 추가!)
    @PostMapping("/update")
    public String updateReview(
        @RequestParam("review_id") int review_id,
        @RequestParam("book_id") int book_id,
        @RequestParam("review_score") int review_score,
        @RequestParam("review_text") String review_text,
        @RequestParam(value = "review_image1", required = false) MultipartFile file1,
        @RequestParam(value = "review_image2", required = false) MultipartFile file2,
        @RequestParam(value = "review_image3", required = false) MultipartFile file3,
        @RequestParam(value = "delete_image1", required = false) String deleteImage1, // 체크박스(체크시 "on", 미체크시 null)
        @RequestParam(value = "delete_image2", required = false) String deleteImage2,
        @RequestParam(value = "delete_image3", required = false) String deleteImage3,
        HttpSession session,
        RedirectAttributes rttr
    ) {
        // 🔐 로그인 사용자 확인
    	 MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
        if (loginUser == null) {
            rttr.addFlashAttribute("msg", "로그인이 필요합니다.");
            return "redirect:/member/login";
        }

        // 기존 리뷰 정보 가져오기
        ReviewVO original = reviewService.getReviewById(review_id);

        int member_idx = loginUser.getMember_idx();
        
        // 📦 VO 객체 생성 및 값 설정
        ReviewVO vo = new ReviewVO();
        vo.setReview_id(review_id);
        vo.setBook_id(book_id);
        vo.setReview_score(review_score);
        vo.setReview_text(review_text);
        vo.setMember_idx(member_idx);

        try {
            // 📂 업로드 경로
            String uploadDir = session.getServletContext().getRealPath("/resources/upload");
            File folder = new File(uploadDir);
            if (!folder.exists()) folder.mkdirs();

            // --- 이미지 1 ---
            if ("on".equals(deleteImage1)) { // 삭제 체크시 null
                vo.setReview_image1(null);
            } else if (file1 != null && !file1.isEmpty()) { // 새 이미지 업로드시
                String name1 = UUID.randomUUID() + "_" + file1.getOriginalFilename();
                file1.transferTo(new File(uploadDir, name1));
                vo.setReview_image1(name1);
            } else { // 그대로 유지
                vo.setReview_image1(original.getReview_image1());
            }

            // --- 이미지 2 ---
            if ("on".equals(deleteImage2)) {
                vo.setReview_image2(null);
            } else if (file2 != null && !file2.isEmpty()) {
                String name2 = UUID.randomUUID() + "_" + file2.getOriginalFilename();
                file2.transferTo(new File(uploadDir, name2));
                vo.setReview_image2(name2);
            } else {
                vo.setReview_image2(original.getReview_image2());
            }

            // --- 이미지 3 ---
            if ("on".equals(deleteImage3)) {
                vo.setReview_image3(null);
            } else if (file3 != null && !file3.isEmpty()) {
                String name3 = UUID.randomUUID() + "_" + file3.getOriginalFilename();
                file3.transferTo(new File(uploadDir, name3));
                vo.setReview_image3(name3);
            } else {
                vo.setReview_image3(original.getReview_image3());
            }

            logger.info("🎯 최종 저장할 리뷰 VO: {}", vo.toString());

            // 💾 리뷰 업데이트
            reviewService.updateReview(vo);
            rttr.addFlashAttribute("msg", "리뷰가 성공적으로 수정되었습니다!");

        } catch (Exception e) {
            e.printStackTrace();
            rttr.addFlashAttribute("msg", "리뷰 수정 중 오류가 발생했습니다.");
        }

        // 🔁 도서 상세 페이지로 이동
        return "redirect:/book/view?book_id=" + book_id;
    }

    // [리뷰 수정 페이지 이동]
    @GetMapping("/edit")
    public String editReview(@RequestParam("review_id") int review_id,
                             HttpSession session,
                             Model model,
                             RedirectAttributes rttr) {

        logger.info("리뷰 수정 페이지 진입 - review_id: {}", review_id);

        // ✅ 로그인 유저 확인 - loginUser로 통일
        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
        if (loginUser == null) {
            rttr.addFlashAttribute("msg", "로그인이 필요합니다.");
            return "redirect:/member/login";
        }
        int member_idx = loginUser.getMember_idx();

        // 리뷰 가져오기
        ReviewVO review = reviewService.getReviewById(review_id);

        // 리뷰가 없거나, 작성자가 본인이 아닌 경우 차단
        if (review == null || review.getMember_idx() != member_idx) {
            rttr.addFlashAttribute("msg", "리뷰를 수정할 수 없습니다.");
            return "redirect:/";
        }

        // 책 정보도 함께 조회
        BookVO book = bookService.getBookDetail(review.getBook_id());

        // model에 함께 담기
        model.addAttribute("book", book);
        model.addAttribute("review", review);
        return "review/review-edit"; 
    }
    // 삭제 
    @PostMapping("/delete")
    public String deleteReview(@RequestParam("review_id") int review_id,
                               HttpSession session,
                               RedirectAttributes rttr) {

        logger.info("📌 리뷰 삭제 요청: review_id = {}", review_id);

        // ✅ 로그인 여부 확인
        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
        if (loginUser == null) {
            logger.warn("🚫 로그인되지 않은 사용자 요청 - 삭제 불가");
            rttr.addFlashAttribute("msg", "로그인 후 이용 가능합니다.");
            return "redirect:/member/login";
        }

        // ✅ 리뷰 단건 조회 (작성자와 도서 ID 확인)
        ReviewVO review = reviewService.getReviewById(review_id);
        if (review == null) {
            logger.warn("❌ 존재하지 않는 리뷰 요청");
            rttr.addFlashAttribute("msg", "리뷰가 존재하지 않습니다.");
            return "redirect:/";
        }

     // ✅ 작성자 본인인지 검증
     if (review.getMember_idx() != loginUser.getMember_idx()) {
         logger.warn("🚫 작성자 불일치 - 삭제 차단");
         rttr.addFlashAttribute("msg", "삭제 권한이 없습니다.");
         return "redirect:/book/view?book_id=" + review.getBook_id();
     }

     // ✅ 삭제를 위한 VO 준비
     ReviewVO vo = new ReviewVO();
     vo.setReview_id(review_id);
     vo.setMember_idx(loginUser.getMember_idx());

     // ✅ 삭제 실행
     int result = reviewService.deleteReview(vo);
     if (result > 0) {
         rttr.addFlashAttribute("msg", "리뷰가 삭제되었습니다.");
     } else {
         rttr.addFlashAttribute("msg", "리뷰 삭제에 실패했습니다.");
     }

     // ✅ 도서 상세 페이지로 이동
     return "redirect:/book/view?book_id=" + review.getBook_id();


    }
}