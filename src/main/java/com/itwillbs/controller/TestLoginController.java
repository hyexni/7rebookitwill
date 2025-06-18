package com.itwillbs.controller;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class TestLoginController {

    private static final Logger logger = LoggerFactory.getLogger(TestLoginController.class);

    @GetMapping("/test-login")
    public String testLogin(HttpSession session) {
        // 🔐 로그인된 것처럼 세션에 저장
        session.setAttribute("member_idx", 1); // 실제 회원 번호 써도 돼!
        logger.info(" 테스트 로그인 완료 - member_idx: {}", session.getAttribute("member_idx"));
        
        // 테스트 끝나면 리뷰 작성 페이지로 이동
        return "redirect:/review/write?book_id=1";
    }
}
