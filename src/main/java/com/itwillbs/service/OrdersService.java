package com.itwillbs.service;

import java.util.List;

import com.itwillbs.domain.Criteria;
import com.itwillbs.dto.OrderDTO;

public interface OrdersService {

  // ✅ 사용자: 주문 상세 조회
  OrderDTO getOrderDetailByMember(int order_id, int member_idx);

  // ✅ 사용자: 주문 목록 조회
  List<OrderDTO> getOrdersByMember(int member_idx);

  // ✅ 사용자: 페이징된 주문 목록 조회
  List<OrderDTO> getOrdersByMemberPaged(Criteria cri);

  // ✅ 사용자: 주문 수 조회
  int getOrderCountByMember(int member_idx);

  // ✅ 관리자: 주문 상세 조회
  OrderDTO getOrderDetailById(int order_id);

  // ✅ 관리자: 전체 주문 목록 조회
  List<OrderDTO> getAllOrders();

  // ✅ 관리자: 페이징된 주문 목록 조회
  List<OrderDTO> getPagedOrders(Criteria cri);

  // ✅ 관리자: 전체 주문 수 조회
  int getTotalOrderCount(Criteria cri);
}
