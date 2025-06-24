package com.itwillbs.controller;

import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

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
import com.itwillbs.domain.DeliveryVO;
import com.itwillbs.domain.MemberVO;
import com.itwillbs.domain.OrdersVO;
import com.itwillbs.domain.PaymentVO;
import com.itwillbs.dto.DeliveryDTO;
import com.itwillbs.dto.PaymentDTO;
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
        
        // 1. 도서 정보
        BookVO book = pService.getBookInfo(book_id);
        if (book == null) {
            throw new IllegalArgumentException("해당 도서가 존재하지 않습니다.");
        }
        model.addAttribute("book", book);
        
        // 2. 포인트 정보
        int point_total = pService.getPointTotal(member_idx);
        model.addAttribute("point_total", point_total);
        
        // ✅ 3. 회원 정보 가져오기 (배송 기본값용)
        MemberVO member = pService.getMemberInfo(member_idx); 
        model.addAttribute("member", member);
        
        return "payment/payment_page"; // view_20
    }
	
	
    
    // 결제 처리
    // 포인트 차감, 주문 정보 저장, 주문 상세 저장, 결제 정보 저장, 포인트 적립, 완료 페이지로 이동
    @PostMapping("/process")
    public String processPayment(PaymentDTO paymentDTO, 
    							@ModelAttribute DeliveryDTO deliveryDTO,
    							HttpSession session, 
    							RedirectAttributes rttr) {
    	
    	Integer member_idx = (Integer) session.getAttribute("member_idx");
    	
        // ✅ 로그인 안 했으면 로그인 페이지로 리다이렉트
        if (member_idx == null) {
            session.setAttribute("redirectAfterLogin", "/payment?book_id=" + paymentDTO.getBook_id());
            return "redirect:/member/login";
        }

        // ✅ 로그인 상태면 결제 처리 진행
        paymentDTO.setMember_idx(member_idx);
        deliveryDTO.setMember_idx(member_idx); // ✅ 필수

        int totalPrice = paymentDTO.getUnit_price() * paymentDTO.getQuantity();
        int payAmount = totalPrice - paymentDTO.getUsed_points();
        int savedPoints = (int)(payAmount * 0.1);
        
        paymentDTO.setTotal_price(totalPrice);
        paymentDTO.setPay_amount(payAmount);
        paymentDTO.setSaved_points(savedPoints);
        
        boolean result = pService.processPayment(paymentDTO, deliveryDTO);

        
        

        if (result) {
        	// 포인트 사용 이력 기록 (사용한 경우만)
            if (paymentDTO.getUsed_points() > 0) {
                pService.insertPointUsage(paymentDTO);
            }

            // 포인트 적립 이력 기록 (saved_points > 0 인 경우)
            if (paymentDTO.getSaved_points() > 0) {
                pService.insertPointHistory(paymentDTO);
            }
            
            return "redirect:/payment/complete";
        } else {
            rttr.addFlashAttribute("errorMsg", "결제에 실패했습니다. 다시 시도해주세요.");
            return "redirect:/payment?book_id=" + paymentDTO.getBook_id();
        }
    }

    
    
    
    
    // 결제 완료
    @GetMapping("/complete")
    public String paymentComplete(HttpSession session, Model model) {
        Integer member_idx = (Integer) session.getAttribute("member_idx");

        if (member_idx == null) {
            return "redirect:/member/login";
        }

        PaymentDTO summary = pService.getLatestPaymentSummary(member_idx);
        model.addAttribute("summary", summary);
        
        int orderId = summary.getOrder_id();

        // ✅ 주문, 결제, 배송, 회원 정보 VO 가져오기 (서비스에서)
        OrdersVO orders = pService.getLatestOrder(member_idx);
        PaymentVO payment = pService.getLatestPayment(member_idx);
        DeliveryVO delivery = pService.getLatestDelivery(orderId);  // 기존엔 member_idx 넘겼을 수도 있음
        
        model.addAttribute("orders", orders);           // 주문 정보
        model.addAttribute("payment", payment);         // 결제 정보
        model.addAttribute("delivery", delivery);     	  // 배송 정보 (optional)

        return "payment/payment_complete"; // view_21
    }

    
    @GetMapping("/success")
    public String kakaoPaySuccess(@RequestParam Map<String, String> params,
                                  HttpSession session, RedirectAttributes rttr) {
    	
        Integer member_idx = (Integer) session.getAttribute("member_idx");
        if (member_idx == null) {
            rttr.addFlashAttribute("errorMsg", "로그인이 필요합니다.");
            return "redirect:/member/login";
        }

        // 1. PaymentDTO 매핑
        PaymentDTO paymentDTO = new PaymentDTO();
        paymentDTO.setMember_idx(member_idx);
        paymentDTO.setBook_id(Integer.parseInt(params.get("book_id")));
        paymentDTO.setUnit_price(Integer.parseInt(params.get("unit_price")));
        paymentDTO.setQuantity(Integer.parseInt(params.get("quantity")));
        paymentDTO.setUsed_points(Integer.parseInt(params.get("used_points")));

        int totalPrice = paymentDTO.getUnit_price() * paymentDTO.getQuantity();
        int payAmount = totalPrice - paymentDTO.getUsed_points();
        int savedPoints = (int)(payAmount * 0.1);

        paymentDTO.setTotal_price(totalPrice);
        paymentDTO.setPay_amount(payAmount);
        paymentDTO.setSaved_points(savedPoints);
        paymentDTO.setPay_method("카카오페이");

        // 2. DeliveryDTO 매핑
        DeliveryDTO deliveryDTO = new DeliveryDTO();
        deliveryDTO.setReceiver_name(params.get("receiver_name"));
        deliveryDTO.setReceiver_phone(params.get("receiver_phone"));
        deliveryDTO.setZipcode(params.get("zipcode"));
        deliveryDTO.setDelivery_address(params.get("address"));
        deliveryDTO.setAddress_detail(params.get("address_detail"));
        deliveryDTO.setMemo(params.get("memo"));
        deliveryDTO.setMember_idx(member_idx); // ✅ 필수

        // 3. 결제 처리
        boolean result = pService.processPayment(paymentDTO, deliveryDTO); // DeliveryDTO는 별도로 넘김

        if (result) {
            // 포인트 사용 이력 기록 (사용한 경우만)
            if (paymentDTO.getUsed_points() > 0) {
                pService.insertPointUsage(paymentDTO);
            }

            // 포인트 적립 이력 기록 (saved_points > 0 인 경우)
            if (paymentDTO.getSaved_points() > 0) {
                pService.insertPointHistory(paymentDTO);
            }
            
            return "redirect:/payment/complete";
        } else {
            rttr.addFlashAttribute("errorMsg", "결제 처리에 실패했습니다.");
            return "redirect:/payment?book_id=" + paymentDTO.getBook_id();
        }
    }



    
    
    
    

} // PaymentController 끝





