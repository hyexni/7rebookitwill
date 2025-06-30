package com.itwillbs.controller;

import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.itwillbs.domain.BookVO;
import com.itwillbs.domain.CategoryVO;
import com.itwillbs.domain.Criteria;
import com.itwillbs.dto.BookPageDTO;
import com.itwillbs.persistence.CategoryDAO;
import com.itwillbs.service.BookService;

@Controller
@RequestMapping("/admin")
public class AdminBookController {

    private static final Logger logger = LoggerFactory.getLogger(AdminBookController.class);

    @Inject
    private BookService bookService;

    @Inject
    private CategoryDAO categoryDAO;

    /**
     * ✅ 관리자 도서 목록
     */
    @GetMapping("/book_list")
    public String bookList(Criteria cri, Model model) {
        logger.debug("📘 관리자 도서 목록 요청: {}", cri);
        
        // ✅ "전체" 또는 "0"이면 조건에서 제외되도록 null 처리
        if (cri.getCategory_id() != null && (cri.getCategory_id().equals("0") || cri.getCategory_id().trim().isEmpty())) {
            cri.setCategory_id(null);
        }

        // 🔹 도서 전체 수 (삭제 포함)
        int totalCount = bookService.getBookCountForAdmin(cri);

        // 🔹 도서 목록 조회
        List<BookVO> bookList = bookService.getBookListForAdmin(cri);

        // 🔹 자동 품절 처리
        for (BookVO book : bookList) {
            if (book.getBook_stock() == 0 && !"품절".equals(book.getStock_status())) {
                bookService.updateBookStatus(book.getBook_id(), "품절");
                logger.debug("✅ 자동 품절 처리됨 - book_id: {}", book.getBook_id());
            }
        }

        // 🔹 카테고리 목록
        List<CategoryVO> categoryList = categoryDAO.getCategoryList();

        // 🔹 페이징 계산용 DTO
        BookPageDTO pageDTO = new BookPageDTO(cri, totalCount);

        // 🔹 모델 저장
        model.addAttribute("bookList", bookList);
        model.addAttribute("categoryList", categoryList);
        model.addAttribute("cri", cri);           // 검색 조건/정렬 등
        model.addAttribute("pageDTO", pageDTO);   // 페이지네이션 정보

        return "admin/book_list";
    }

    /**
     * ✅ 재고 상태 변경 처리 (판매중/품절/절판/예약판매)
     */
    @PostMapping("/book_update_status")
    public String updateStockStatus(@RequestParam("book_id") int book_id,
                                    @RequestParam("stock_status") String stock_status,
                                    RedirectAttributes redirect) {

        logger.debug(" 재고 상태 변경 - book_id: {}, stock_status: {}", book_id, stock_status);

        bookService.updateBookStatus(book_id, stock_status);
        redirect.addFlashAttribute("msg", "재고 상태가 변경되었습니다.");
        redirect.addFlashAttribute("icon", "success");

        return "redirect:/admin/book_list";
    }

    /**
     * ✅ 카테고리 변경 처리
     */
    @PostMapping("/book_update_category")
    public String updateCategory(@RequestParam("book_id") int book_id,
                                 @RequestParam("category_id") int category_id,
                                 RedirectAttributes redirect) {

        logger.debug(" 카테고리 변경 - book_id: {}, category_id: {}", book_id, category_id);

        bookService.updateBookCategory(book_id, category_id);
        redirect.addFlashAttribute("msg", "카테고리가 변경되었습니다.");
        redirect.addFlashAttribute("icon", "success");
        
        return "redirect:/admin/book_list";
    }

    /**
     * ✅ 도서 등록 폼 페이지
     */
    @GetMapping("/book_add")
    public String bookAddForm(Model model) {
        logger.debug("📘 도서 등록 폼 요청");

        // 카테고리 목록 가져오기
        List<CategoryVO> categoryList = categoryDAO.getCategoryList();
        model.addAttribute("categoryList", categoryList);

        return "admin/book_add";  
    }
    // ✅ 도서 등록 처리
    @PostMapping("/book_add")
    public String bookAddSubmit(@ModelAttribute BookVO bookVO,
                                RedirectAttributes rttr) throws Exception {

        logger.debug("📘 도서 등록 요청: {}", bookVO);


        // DB 저장
        bookService.insertBook(bookVO);

        rttr.addFlashAttribute("msg", "도서가 등록되었습니다.");
        rttr.addFlashAttribute("icon", "success");

        return "redirect:/admin/book_list";
    }
    

    // 📘 도서 수정 폼 열기
    @GetMapping("/book_edit")
    public String bookEditForm(@RequestParam("book_id") int book_id, Model model) {
        logger.debug(" 도서 수정 폼 요청 - book_id: {}", book_id);

        BookVO book = bookService.getBookDetail(book_id);
        List<CategoryVO> categoryList = categoryDAO.getCategoryList();

        model.addAttribute("book", book);
        model.addAttribute("categoryList", categoryList);

        return "admin/book_edit";
    }

    @PostMapping("/book_edit")
    public String bookEditSubmit(@ModelAttribute BookVO bookVO,
                                 RedirectAttributes rttr) throws Exception {

        logger.debug("📘 도서 수정 요청: {}", bookVO);

        if (bookVO.getCover_image() != null && !bookVO.getCover_image().isEmpty()) {
            logger.debug("✅ 새로운 커버 이미지 파일명: {}", bookVO.getCover_image());
        } else {
            logger.warn("⚠️ 커버 이미지가 비어 있음! 기존 이미지 유지하려면 값 유지 필수");
        }

        // ✅ DB 반영
        bookService.updateBook(bookVO);

        rttr.addFlashAttribute("msg", "도서 정보가 수정되었습니다.");
        rttr.addFlashAttribute("icon", "success");

        return "redirect:/admin/book_list";
    }

    // ✅ 도서 삭제
    @PostMapping("/book_delete")
    public String deleteBook(@RequestParam("book_id") int book_id,
                             @ModelAttribute("cri") Criteria cri,
                             RedirectAttributes rttr) {
        logger.debug("🗑 도서 삭제 요청: book_id = {}", book_id);

        try {
            bookService.deleteBook(book_id);
            logger.debug("✅ 도서 삭제 성공");

            rttr.addFlashAttribute("msg", "도서가 삭제되었습니다.");
            rttr.addFlashAttribute("icon", "success");

            // 🔹 삭제 후 마지막 페이지로 이동 (Criteria 기준)
            int totalCount = bookService.getBookCountForAdmin(cri);  // 관리자 전용 도서 수 조회
            int lastPage = (int) Math.ceil((double) totalCount / cri.getPerPageNum());

            return "redirect:/admin/book_list?page=" + lastPage;

        } catch (Exception e) {
            logger.error("❌ 도서 삭제 실패", e);
            rttr.addFlashAttribute("msg", "삭제 중 오류가 발생했습니다.");
            rttr.addFlashAttribute("icon", "error");
            return "redirect:/admin/book_list";
        }
    }

}
