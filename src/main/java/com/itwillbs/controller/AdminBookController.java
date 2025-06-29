package com.itwillbs.controller;

import java.io.File;
import java.util.List;
import java.util.UUID;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.itwillbs.domain.BookVO;
import com.itwillbs.domain.CategoryVO;
import com.itwillbs.domain.Criteria;
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
        logger.debug(" 관리자 도서 목록 요청: {}", cri);

        // 전체 도서 수 조회 (페이징용)
        int totalCount = bookService.getBookCount(cri);
        cri.setTotalCount(totalCount);

        // 도서 목록 조회
        List<BookVO> bookList = bookService.getBookList(cri);

        // ✅ 자동으로 품절 처리: 재고가 0인데 품절이 아닐 경우 업데이트
        for (BookVO book : bookList) {
            if (book.getBook_stock() == 0 && !"품절".equals(book.getStock_status())) {
                bookService.updateBookStatus(book.getBook_id(), "품절");
                logger.debug(" 자동 품절 처리됨 - book_id: {}", book.getBook_id());
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

        return "admin/book_add";  // → /WEB-INF/views/admin/book_add.jsp
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

    // 📘 도서 수정 처리
    @PostMapping("/book_edit")
    public String bookEditSubmit(@ModelAttribute BookVO bookVO,
                                 @RequestParam("upload") MultipartFile upload,
                                 HttpServletRequest request,
                                 RedirectAttributes rttr) throws Exception {

        logger.debug(" 도서 수정 요청: {}", bookVO);

        if (!upload.isEmpty()) {
            String uploadPath = request.getSession().getServletContext().getRealPath("/resources/img/product-img");
            String fileName = UUID.randomUUID().toString() + "_" + upload.getOriginalFilename();
            upload.transferTo(new File(uploadPath, fileName));
            bookVO.setCover_image(fileName);
        }

        bookService.updateBook(bookVO);

        rttr.addFlashAttribute("msg", "도서 정보가 수정되었습니다.");
        return "redirect:/admin/book_list";
    }

    // ✅ 도서 삭제
    @PostMapping("/book_delete")
    public String deleteBook(@RequestParam("book_id") int book_id,
                             RedirectAttributes rttr) {
        logger.debug("🗑 도서 삭제 요청: book_id = {}", book_id);

        try {
            bookService.deleteBook(book_id);
            rttr.addFlashAttribute("msg", "도서가 삭제되었습니다.");
            rttr.addFlashAttribute("icon", "success");
        } catch (Exception e) {
            logger.error("도서 삭제 실패", e);
            rttr.addFlashAttribute("msg", "삭제 중 오류가 발생했습니다.");
            rttr.addFlashAttribute("icon", "error");
        }

        return "redirect:/admin/book_list";
    }

}
