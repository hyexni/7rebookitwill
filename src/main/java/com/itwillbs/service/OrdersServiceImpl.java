package com.itwillbs.service;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.itwillbs.domain.Criteria;
import com.itwillbs.dto.OrderDTO;
import com.itwillbs.persistence.OrdersDAO;

@Service
public class OrdersServiceImpl implements OrdersService {

  @Inject
  private OrdersDAO ordersDAO;

  // ✅ 사용자: 주문 상세 조회
  @Override
  public OrderDTO getOrderDetailByMember(int order_id, int member_idx) {
    return ordersDAO.getOrderDetailByMember(order_id, member_idx);
  }

  // ✅ 사용자: 주문 목록 조회
  @Override
  public List<OrderDTO> getOrdersByMember(int member_idx) {
    return ordersDAO.getOrdersByMember(member_idx);
  }

  // ✅ 사용자: 페이징된 주문 목록 조회
  @Override
  public List<OrderDTO> getOrdersByMemberPaged(Criteria cri) {
    return ordersDAO.getOrdersByMemberPaged(cri);
  }

  // ✅ 사용자: 주문 수 조회
  @Override
  public int getOrderCountByMember(int member_idx) {
    return ordersDAO.getOrderCountByMember(member_idx);
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

  // ✅ 관리자: 페이징된 주문 목록 조회
  @Override
  public List<OrderDTO> getPagedOrders(Criteria cri) {
    return ordersDAO.getPagedOrders(cri);
  }

  // ✅ 관리자: 전체 주문 수 조회
  @Override
  public int getTotalOrderCount(Criteria cri) {
    return ordersDAO.getTotalOrderCount(cri);
  }
}
