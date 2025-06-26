package com.itwillbs.controller;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.itwillbs.domain.Criteria;
import com.itwillbs.dto.OrderDTO;
import com.itwillbs.service.OrdersService;

@Controller
@RequestMapping("/admin")
public class AdminOrdersController {

	private static final Logger logger = LoggerFactory.getLogger(AdminOrdersController.class);

	@Inject
	private OrdersService ordersService;

	// ✅ 관리자: 전체 주문 목록 조회 (페이징 + 필터링)
	@GetMapping("/orders_list")
	public String orderList(Criteria cri, Model model) {
		logger.debug("▶ 관리자 주문 목록 조회 요청: {}", cri);

		// 전체 주문 수 조회 → Criteria에 totalCount 세팅
		int totalCount = ordersService.getTotalOrderCount(cri);
		cri.setTotalCount(totalCount);

		// 주문 목록 조회
		model.addAttribute("orderList", ordersService.getPagedOrders(cri));
		model.addAttribute("cri", cri); // 페이징 바 출력용

		logger.debug("✅ 총 주문 수 = {}, 현재 페이지 = {}", totalCount, cri.getPage());

		return "admin/orders_list"; // 📄 /WEB-INF/views/admin/orders/list.jsp
	}

	// ✅ 관리자: 주문 상세 조회
	@GetMapping("/detail")
	public String orderDetail(int order_id, Model model) {
		logger.debug("▶ 관리자 주문 상세 요청: order_id = {}", order_id);

		OrderDTO order = ordersService.getOrderDetailById(order_id);
		if (order == null) {
			logger.warn("❌ 주문 정보 없음: order_id = {}", order_id);
			model.addAttribute("errorMsg", "해당 주문을 찾을 수 없습니다.");
			return "redirect:/admin/orders/list";
		}

		model.addAttribute("order", order);
		logger.debug("✅ 주문 상세 정보 로딩 완료");

		return "admin/orders_detail"; 
	}
}
