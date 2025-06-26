package com.itwillbs.controller;

import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.itwillbs.dto.OrderDTO;
import com.itwillbs.service.OrdersService;

@Controller
@RequestMapping("/admin/orders")
public class AdminOrdersController {

	private static final Logger logger = LoggerFactory.getLogger(AdminOrdersController.class);

	@Inject
	private OrdersService ordersService;

	// ✅ 관리자: 전체 주문 목록 조회
	@GetMapping("/list")
	public String orderList(Model model) {
		logger.debug("▶ 관리자 주문 목록 조회 요청");

		List<OrderDTO> orderList = ordersService.getAllOrders();
		model.addAttribute("orderList", orderList);

		logger.debug("✅ 전체 주문 수: {}", orderList.size());

		return "admin/order_list"; // 📄 /WEB-INF/views/admin/order_list.jsp
	}

	// ✅ 관리자: 주문 상세 조회
	@GetMapping("/detail")
	public String orderDetail(@RequestParam("order_id") int order_id, Model model) {
		logger.debug("▶ 관리자 주문 상세 조회 요청: order_id = {}", order_id);

		OrderDTO order = ordersService.getOrderDetailById(order_id);
		if (order == null) {
			logger.warn("❌ 주문 정보 없음: order_id = {}", order_id);
			model.addAttribute("errorMsg", "해당 주문을 찾을 수 없습니다.");
			return "redirect:/admin/orders/list";
		}

		model.addAttribute("order", order);
		logger.debug("✅ 주문 상세 정보 로딩 완료");

		return "admin/order_detail"; // 📄 /WEB-INF/views/admin/order_detail.jsp
	}
}
