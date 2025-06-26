package com.itwillbs.service;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.itwillbs.dto.OrderDTO;
import com.itwillbs.persistence.OrdersDAO;

@Service
public class OrdersServiceImpl implements OrdersService {

	@Inject
	private OrdersDAO ordersDAO;

	// ✅ 사용자: 주문 상세 조회
	@Override
	public OrderDTO getOrderDetailByMember(Map<String, Object> paramMap) {
		return ordersDAO.getOrderDetailByMember(paramMap);
	}

	// ✅ 사용자: 주문 목록 조회
	@Override
	public List<OrderDTO> getOrdersByMember(int member_idx) {
		return ordersDAO.getOrdersByMember(member_idx);
	}

	// ✅ 관리자: 주문 상세 조회
	@Override
	public OrderDTO getOrderDetailById(int order_id) {
		return ordersDAO.getOrderDetailById(order_id);
	}

	// ✅ 관리자: 전체 주문 목록 조회
	@Override
	public List<OrderDTO> getAllOrders() {
		return ordersDAO.getAllOrders();
	}
}
