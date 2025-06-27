package com.itwillbs.controller;

import java.util.List;
import javax.inject.Inject; // 또는 @Autowired
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.itwillbs.domain.BookVO;
import com.itwillbs.service.BookService;
import com.itwillbs.service.MainService;

@Controller
@RequestMapping("") // /include/ 으로 시작하는 모든 요청을 처리
public class MainController {

    private static final Logger logger = LoggerFactory.getLogger(MainController.class);

    @Inject
    private MainService mainService; // MainService 객체 주입

    /**
     * 메인 페이지를 표시합니다.
     * GET 방식으로 /main/main 주소에 매핑됩니다.
     * @param model View에 데이터를 전달하기 위한 Model 객체
     * @return 뷰 페이지의 경로
     */
    @RequestMapping(value = "/aa", method = RequestMethod.GET)
    public String mainPage(Model model) throws Exception {
        logger.info("mainPage() 호출 - 메인 페이지 표시");

        // 서비스 계층을 호출하여 도서 목록을 가져옴
        List<BookVO> bookList = mainService.getBookList();
        logger.info(bookList.size() + "개의 도서 정보를 가져옴");
        
        // "bookList"라는 이름으로 Model 객체에 도서 목록을 저장
        // 이렇게 저장된 데이터는 View(JSP)에서 사용할 수 있음
        model.addAttribute("bookList", bookList);

        // /WEB-INF/views/main/main.jsp 파일을 View로 지정
        return "/include/main";
    }
    
    

    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String main(Model model) {

        // 신간 도서 목록 (5개)
        List<BookVO> newBookList = mainService.getNewBookList(10);
        
        // 베스트셀러 목록 (5개)
        List<BookVO> bestSellerList = mainService.getBestSellerList(10);

        model.addAttribute("newBookList", newBookList);
        model.addAttribute("bestSellerList", bestSellerList);

        return "/include/main";
    }
    
    

    
    // 메인화면 검색창 실행
    
 // AJAX 검색 요청을 처리하는 메서드
    @GetMapping("/main/searchAjax")
    public String searchAjax(String keyword, Model model) throws Exception {
        
        logger.info("AJAX Search Start! Keyword: " + keyword);

        // 1. 키워드로 도서를 검색합니다. (수정된 서비스 메서드 호출)
        List<BookVO> searchResult = mainService.searchBooksByKeyword(keyword);
        model.addAttribute("bookList", searchResult); 
        logger.info("Search Result Count: " + (searchResult != null ? searchResult.size() : 0));

        // 2. 검색 결과가 있을 경우, 연관 도서 추천 로직을 실행합니다.
        if (searchResult != null && !searchResult.isEmpty()) {
            // 검색된 첫 번째 책을 추천의 기준으로 삼습니다.
            BookVO baseBook = searchResult.get(0); 
            logger.info("Base book for recommendation: " + baseBook.getBook_title());
            
            // 새롭게 추가한 추천 도서 서비스 메서드를 호출합니다.
            List<BookVO> recommendedList = mainService.getRecommendedBooks(baseBook);
            
            // 추천 도서 목록을 모델에 추가합니다.
            model.addAttribute("recommendedList", recommendedList);
            logger.info("Recommended Book Count: " + (recommendedList != null ? recommendedList.size() : 0));
        }

        // 3. 결과를 표시할 JSP (부분 뷰)로 이동합니다.
        return "/main/searchResult"; 
    }
}