package com.itwillbs.service;

import java.util.List;
import java.util.Map;

import com.itwillbs.dto.OrderDTO;

public interface OrdersService {

	// ✅ 사용자: 주문 상세 조회
	OrderDTO getOrderDetailByMember(Map<String, Object> paramMap);

	// ✅ 사용자: 주문 목록 조회
	List<OrderDTO> getOrdersByMember(int member_idx);

	// ✅ 관리자: 주문 상세 조회
	OrderDTO getOrderDetailById(int order_id);

	// ✅ 관리자: 전체 주문 목록 조회
	List<OrderDTO> getAllOrders();
}
