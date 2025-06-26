package com.itwillbs.controller;

import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.itwillbs.domain.Criteria;
import com.itwillbs.domain.MemberVO;
import com.itwillbs.dto.OrderDTO;
import com.itwillbs.service.OrdersService;

@Controller
@RequestMapping("/orders")
public class OrdersController {

	private static final Logger logger = LoggerFactory.getLogger(OrdersController.class);

	@Inject
	private OrdersService ordersService;

	// ✅ 사용자 주문 목록 조회
	@GetMapping("/list")
	public String orderList(HttpSession session, Criteria cri, Model model) {

		logger.debug("▶▶▶ 주문 목록 조회 요청");

		MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
		if (loginUser == null) {
			logger.warn("⛔ 로그인 안 된 사용자 접근 시도");
			return "redirect:/member/login";
		}

		int member_idx = loginUser.getMember_idx();
		logger.debug("▶ 사용자 member_idx = {}", member_idx);

		// 전체 주문 수 조회 + 세팅
		int totalCount = ordersService.getOrderCountByMember(member_idx);
		cri.setMember_idx(member_idx);         // 검색 조건 추가
		cri.setTotalCount(totalCount);         // 블록 페이징 계산

		// 페이징된 목록 조회
		List<OrderDTO> orderList = ordersService.getOrdersByMemberPaged(cri);

		model.addAttribute("orderList", orderList);
		model.addAttribute("cri", cri);

		logger.debug("✅ 페이징된 주문 목록 조회 완료");

		return "orders/list";
	}
	// ✅ 사용자 주문 상세 조회
	// ✅ 사용자 주문 상세 조회
	@GetMapping("/detail")
	public String orderDetail(@RequestParam("order_id") int order_id, HttpSession session, Model model) {

		logger.debug("▶▶▶ 주문 상세 조회 요청: order_id = {}", order_id);

		// 로그인 체크
		MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
		if (loginUser == null) {
			logger.warn("⛔ 로그인 안 된 사용자 접근 시도");
			return "redirect:/member/login";
		}

		// 주문 상세 조회
		OrderDTO order = ordersService.getOrderDetailByMember(order_id, loginUser.getMember_idx());
		if (order == null) {
			logger.warn("❌ 해당 주문이 없거나 권한이 없음: order_id={}, member_idx={}", order_id, loginUser.getMember_idx());
			model.addAttribute("errorMsg", "주문 정보를 찾을 수 없습니다.");
			return "redirect:/orders/list";
		}

		model.addAttribute("order", order);
		logger.debug("✅ 주문 정보 조회 완료: {}", order);

		return "orders/detail";
	}

}
