package com.itwillbs.controller;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.itwillbs.domain.Criteria;
import com.itwillbs.dto.OrderDTO;
import com.itwillbs.service.DeliveryService;
import com.itwillbs.service.OrdersService;

@Controller
@RequestMapping("/admin")
public class AdminOrdersController {

	private static final Logger logger = LoggerFactory.getLogger(AdminOrdersController.class);

	@Inject
	private OrdersService ordersService;

	@Inject
	private DeliveryService deliveryService;

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
		model.addAttribute("deliveryStatusList", Arrays.asList("배송준비중", "배송중", "배송완료"));
		model.addAttribute("paymentStatusList", Arrays.asList("결제완료", "결제대기", "결제취소"));

		logger.debug("✅ 총 주문 수 = {}, 현재 페이지 = {}", totalCount, cri.getPage());

		return "admin/orders_list";
	}

	// ✅ 관리자: 배송 상태 업데이트 (AJAX)
	@PostMapping("/orders/updateDeliveryStatus")
	@ResponseBody
	public String updateDeliveryStatus(@RequestBody Map<String, Object> payload) {
		logger.debug("📦 배송 상태 변경 요청 수신: {}", payload);

		try {
			Object idObj = payload.get("order_id");
			int orderId = (idObj instanceof Number) ? ((Number) idObj).intValue() : Integer.parseInt(idObj.toString());

			String status = payload.get("delivery_status_code").toString();

			logger.debug("➡️ 주문번호 [{}]의 배송 상태를 '{}'로 변경 시도", orderId, status);

			ordersService.updateDeliveryStatus(orderId, status);

			logger.info("✅ 배송 상태 변경 완료 - orderId: {}, status: {}", orderId, status);
			return "SUCCESS";
		} catch (Exception e) {
			logger.error("❌ 배송 상태 변경 중 예외 발생", e);
			return "FAIL";
		}
	}

	// ✅ 필터된 목록 반환 (Ajax)
	@GetMapping("/orders/filter")
	@ResponseBody
	public List<OrderDTO> getFilteredOrders(Criteria cri) {
		return ordersService.getPagedOrders(cri);
	}

	// ✅ 관리자: 주문 상세 조회
	@GetMapping("/orders/detail")
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

	// 결제 바꾸기
	@PostMapping("/orders/updateStatus")
	public String updatePaymentStatus(@RequestParam int order_id, @RequestParam String status,
			RedirectAttributes rttr) {
		logger.debug("🔄 결제 상태 변경 요청: order_id={}, status={}", order_id, status);

		boolean result = ordersService.updatePaymentStatus(order_id, status);

		if (result) {
			rttr.addFlashAttribute("msg", "결제 상태가 변경되었습니다.");
			rttr.addFlashAttribute("icon", "success"); // ✅ 성공 아이콘
		} else {
			rttr.addFlashAttribute("msg", "결제 상태 변경에 실패했습니다.");
			rttr.addFlashAttribute("icon", "error"); // ✅ 실패 아이콘
		}

		return "redirect:/admin/orders/detail?order_id=" + order_id;
	}

	// ✅ 운송장 번호 등록 처리 (AJAX)
	@PostMapping("/updateTracking")
	@ResponseBody
	public Map<String, Object> updateTracking(@RequestBody Map<String, Object> map) {
		logger.debug("📦 운송장 등록 요청 수신: {}", map);

		try {
			int order_id = Integer.parseInt(map.get("order_id").toString());
			String tracking_number = map.get("tracking_number").toString();
			String shipper_name = "우체국택배"; // 고정

			// 전달값 로그 확인
			logger.debug("✅ 운송장 등록 = order_id: " + order_id + ", tracking_number: " + tracking_number + ", shipper: "
					+ shipper_name);

			// Map으로 서비스에 전달
			Map<String, Object> paramMap = new HashMap<>();
			paramMap.put("order_id", order_id);
			paramMap.put("tracking_number", tracking_number);
			paramMap.put("shipper_name", shipper_name);

			deliveryService.updateTrackingInfo(paramMap);

			Map<String, Object> result = new HashMap<>();
			result.put("success", true);
			return result;
		} catch (Exception e) {
			logger.error("❌ 운송장 등록 중 오류 발생", e);
			Map<String, Object> result = new HashMap<>();
			result.put("success", false);
			result.put("message", e.getMessage());
			return result;
		}
	}
}
