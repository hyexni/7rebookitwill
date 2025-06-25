package com.itwillbs.controller;

import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.itwillbs.domain.BookVO;
import com.itwillbs.domain.CategoryVO;
import com.itwillbs.domain.Criteria;
import com.itwillbs.domain.MemberVO;
import com.itwillbs.domain.ReviewVO;
import com.itwillbs.dto.BookPageDTO;
import com.itwillbs.service.BookService;
import com.itwillbs.service.CategoryService;
import com.itwillbs.service.ReviewService;

/**
 * 도서 관련 요청을 처리하는 Controller 클래스
 */
@Controller
@RequestMapping("/book/*")
public class BookController {

	// 로거(Logger) 선언
	private static final Logger logger = LoggerFactory.getLogger(BookController.class);

	@Inject
	private BookService bookService;

	@Inject
	private CategoryService categoryService;

	/**
	 * 도서 목록 조회 - 카테고리, 검색어, 정렬 기준, 페이지 번호를 Criteria로 전달 - 결과를 model에 담아
	 * book/BookList.jsp로 이동
	 */
	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public String bookList(@RequestParam(value = "category_id", required = false) String category_id,
			@RequestParam(value = "search", required = false) String search,
			@RequestParam(value = "sort", required = false, defaultValue = "recent") String sort,
			@RequestParam(value = "page", defaultValue = "1") int page, Model model) {

		logger.info("bookList() 호출 - category_id={}, search={}, sort={}, page={}",
				new Object[] { category_id, search, sort, page });

		// 1️⃣ 카테고리 목록 조회 (상단 필터용)
		List<CategoryVO> categoryList = categoryService.getCategoryList();
		model.addAttribute("categoryList", categoryList);

		// 2️⃣ Criteria 객체 생성 후 요청 파라미터 설정
		Criteria criteria = new Criteria();
		criteria.setCategory_id(category_id);
		criteria.setSearch(search);
		criteria.setSort(sort);
		criteria.setPage(page);
		criteria.setPerPageNum(10);

		// 3️⃣ 도서 목록 및 전체 개수 조회
		List<BookVO> bookList = bookService.getBookList(criteria);
		int totalCount = bookService.getBookCount(criteria);
		criteria.setTotalCount(totalCount);

		BookPageDTO pageDTO = new BookPageDTO(criteria, totalCount);
		model.addAttribute("pageDTO", pageDTO);     // 👉 BookPageDTO는 pageDTO로
		model.addAttribute("criteria", criteria);   // 👉 Criteria는 criteria 그대로
		
		// 4️⃣ JSP에서 사용할 데이터 추가
		model.addAttribute("bookList", bookList);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("page", page);
		model.addAttribute("selectedCategory", category_id);
		model.addAttribute("search", search);
		model.addAttribute("sort", sort);

		return "book/BookList";
	}

	/**
	 * 도서 상세 정보 페이지 요청 처리 - 도서 ID를 통해 상세 정보 조회 - 리뷰 목록도 함께 조회 (최신순/평점순 정렬 가능) - 결과를
	 * model에 담아 book/book-view.jsp로 이동
	 */
	@Inject
	private ReviewService reviewService;

	@RequestMapping(value = "/view", method = RequestMethod.GET)
	public String bookDetail(@RequestParam("book_id") int book_id,
			@RequestParam(value = "sort", defaultValue = "recent") String sort,
			@RequestParam(value = "page", defaultValue = "1") int page, Model model, HttpSession session) {

		logger.info("bookDetail() 호출 - book_id: {}, sort: {}", book_id, sort);

		// 로그인 유저 정보는 있을 경우만 추가 (로그인 안했으면 null)
		MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
		if (loginUser != null) {
			model.addAttribute("loginUser", loginUser);
		}

		BookVO book = bookService.getBookDetail(book_id);
		model.addAttribute("book", book);

		// ⭐ 평균 별점 조회
		Double averageRating = reviewService.getAverageRating(book_id);
		model.addAttribute("averageRating", averageRating);

		Criteria criteria = new Criteria();
		criteria.setBook_id(book_id);
		criteria.setSort(sort);
		criteria.setPage(page);
		criteria.setPerPageNum(5);

		List<ReviewVO> reviewList = reviewService.getReviewList(criteria);
		int reviewCount = reviewService.getReviewCount(criteria);
		criteria.setTotalCount(reviewCount);

		model.addAttribute("reviewList", reviewList);
		model.addAttribute("reviewCount", reviewCount);
		model.addAttribute("criteria", criteria);
		model.addAttribute("reviewSort", sort);

		return "book/BookView";
	}

}
