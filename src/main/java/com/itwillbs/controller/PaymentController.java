package com.itwillbs.controller;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.itwillbs.domain.BookVO;
import com.itwillbs.domain.MemberVO;
import com.itwillbs.service.AdminInquiryService;
import com.itwillbs.service.PaymentService;

/**
 * 매핑 /payment로 시작하는 주소를 처리
 *
 */

@Controller
@RequestMapping(value = "/payment")
public class PaymentController {
	
	// mylog
	private static final Logger logger = LoggerFactory.getLogger(PaymentController.class);

	@Inject
	private PaymentService pService;
	
	// 결제 페이지
    @GetMapping("")
    public String paymentPage(@RequestParam("book_id") int book_id, Model model, HttpSession session) {
    	Integer member_idx = (Integer) session.getAttribute("member_idx");
    	// 로그인 안 했으면 로그인 페이지로 리다이렉트 + 현재 주소 세션에 저장
        if (member_idx == null) {
            String redirectUrl = "/payment?book_id=" + book_id;
            session.setAttribute("redirectAfterLogin", redirectUrl);
            return "redirect:/member/login";
        }
        
        // 책 정보, 포인트 정보 가져오기
        BookVO book = pService.getBookInfo(book_id);
        if (book == null) {
            throw new IllegalArgumentException("해당 도서가 존재하지 않습니다.");
        }
        model.addAttribute("book", book);
        
        int pointTotal = pService.getPointTotal(member_idx);
        model.addAttribute("pointTotal", pointTotal);
        
        return "payment/payment_page"; // view_20
    }
	
	
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

} // PaymentController 끝


































