package com.itwillbs.persistence;

import java.util.List;
import java.util.Map;

import com.itwillbs.dto.OrderDTO;

public interface OrdersDAO {

	// ✅ 사용자: 주문 상세 조회 (order_id + member_idx)
	OrderDTO getOrderDetailByMember(Map<String, Object> paramMap);

	// ✅ 사용자: 주문 목록 조회
	List<OrderDTO> getOrdersByMember(int member_idx);

	// ✅ 관리자: 주문 상세 조회 (order_id)
	OrderDTO getOrderDetailById(int order_id);

	// ✅ 관리자: 전체 주문 목록 조회
	List<OrderDTO> getAllOrders();
}
