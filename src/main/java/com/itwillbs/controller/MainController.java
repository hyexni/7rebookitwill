package com.itwillbs.controller;

import java.util.List;
import javax.inject.Inject; // 또는 @Autowired
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import com.itwillbs.domain.BookVO;
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
    @RequestMapping(value = "", method = RequestMethod.GET)
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
}