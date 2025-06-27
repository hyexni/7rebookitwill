package com.itwillbs.service;

import java.util.List;

import com.itwillbs.domain.Criteria;
import com.itwillbs.dto.OrderDTO;

public interface OrdersService {

	// ✅ 사용자: 주문 상세 조회
	OrderDTO getOrderDetailByMember(int order_id, int member_idx);

	// ✅ 사용자: 페이징된 주문 목록 조회
	List<OrderDTO> getOrdersByMemberPaged(Criteria cri);

	// ✅ 사용자: 주문 수 조회
	int getOrderCountByMember(int member_idx);

	// ✅ 관리자: 주문 상세 조회
	OrderDTO getOrderDetailById(int order_id);

	// 결제 상태 변경
	boolean updatePaymentStatus(int order_id, String status);

	// ✅ 관리자: 페이징된 주문 목록 조회
	List<OrderDTO> getPagedOrders(Criteria cri);

	// ✅ 관리자: 전체 주문 수 조회
	int getTotalOrderCount(Criteria cri);

	// ✅ 관리자: 배송 상태 업데이트
	void updateDeliveryStatus(int order_id, String status);

}
