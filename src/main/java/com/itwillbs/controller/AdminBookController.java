package com.itwillbs.controller;

import java.util.List;
import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.itwillbs.domain.BookVO;
import com.itwillbs.domain.CategoryVO;
import com.itwillbs.domain.Criteria;
import com.itwillbs.service.BookService;
import com.itwillbs.persistence.CategoryDAO;

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

        // 전체 도서 수 조회 (페이징용)
        int totalCount = bookService.getBookCount(cri);
        cri.setTotalCount(totalCount);

        // 도서 목록 조회
        List<BookVO> bookList = bookService.getBookList(cri);

        // ✅ 자동으로 품절 처리: 재고가 0인데 품절이 아닐 경우 업데이트
        for (BookVO book : bookList) {
            if (book.getBook_stock() == 0 && !"품절".equals(book.getStock_status())) {
                bookService.updateBookStatus(book.getBook_id(), "품절");
                logger.debug("🔁 자동 품절 처리됨 - book_id: {}", book.getBook_id());
            }
        }

        // 카테고리 목록 가져오기 (번호 + 이름 표시용)
        List<CategoryVO> categoryList = categoryDAO.getCategoryList();

        model.addAttribute("bookList", bookList);
        model.addAttribute("cri", cri);
        model.addAttribute("categoryList", categoryList);

        return "admin/book_list";
    }

    /**
     * ✅ 재고 상태 변경 처리 (판매중/품절/절판/예약판매)
     */
    @PostMapping("/book_update_status")
    public String updateStockStatus(@RequestParam("book_id") int book_id,
                                    @RequestParam("stock_status") String stock_status,
                                    RedirectAttributes redirect) {

        logger.debug("▶ 재고 상태 변경 - book_id: {}, stock_status: {}", book_id, stock_status);

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

        logger.debug("▶ 카테고리 변경 - book_id: {}, category_id: {}", book_id, category_id);

        bookService.updateBookCategory(book_id, category_id);
        redirect.addFlashAttribute("msg", "카테고리가 변경되었습니다.");
        redirect.addFlashAttribute("icon", "success");

        return "redirect:/admin/book_list";
    }

    // 🔜 book_add, book_edit, book_delete 기능은 이후 구현 예정
}
