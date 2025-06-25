package com.itwillbs.controller;

import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import com.itwillbs.domain.MemberVO;
import com.itwillbs.dto.OrderDTO;
import com.itwillbs.service.OrdersService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/orders")
public class OrdersController {

    private static final Logger logger = LoggerFactory.getLogger(OrdersController.class);

    @Inject
    private OrdersService ordersService;

    // 🟡 주문/배송 조회 페이지
    @GetMapping("/list")
    public String orderList(HttpSession session, Model model) {
        logger.info("▶ OrdersController: /orders/list 호출");

        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/member/login";
        }

        int member_idx = loginUser.getMember_idx();

        List<OrderDTO> orderList = ordersService.getOrdersByMember(member_idx);
        model.addAttribute("orderList", orderList);

        return "orders/list";
    }
}
