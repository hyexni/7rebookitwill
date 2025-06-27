package com.itwillbs.controller;

import java.util.Collections;
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
    

    /**
     * 메인 검색창에서 키워드를 받아 검색 결과를 보여주는 메서드
     */
    @RequestMapping(value = "/search", method = RequestMethod.GET)
    public String search(
            @RequestParam(value = "keyword", required = false, defaultValue = "") String keyword,
            Model model) {

        logger.info("C: /search 호출, keyword: {}", keyword);

        try {
            // 예외 발생 가능성이 있는 코드를 try 블록으로 감쌉니다.
            if (keyword != null && !keyword.trim().isEmpty()) {
                // ServiceImpl 또는 DAO에서 Exception을 던지도록 수정되었을 가능성이 높습니다.
                // 여기서는 searchBooksByKeyword 메서드명을 그대로 사용하겠습니다.
                List<BookVO> searchResult = mainService.searchBooksByKeyword(keyword); 

                model.addAttribute("bookList", searchResult); 
                logger.info("Search Result Count: {}", (searchResult != null ? searchResult.size() : 0));
            }
        } catch (Exception e) {
            // 예외가 발생했을 때 실행될 코드
            logger.error("검색 처리 중 예외 발생", e); // 1. 서버 로그에 에러를 기록합니다 (개발자 확인용).
            model.addAttribute("errorMessage", "검색 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요."); // 2. 사용자에게 보여줄 에러 메시지를 Model에 담습니다.
        }
        
        // 검색 키워드는 try-catch와 상관없이 항상 View로 전달합니다.
        model.addAttribute("keyword", keyword);

        // 결과 또는 에러 메시지를 보여줄 JSP 페이지 경로를 반환합니다.
        return "include/searchResult";
    }
}



