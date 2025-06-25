package com.itwillbs.persistence;

import java.util.List;

import com.itwillbs.dto.OrderDTO;

public interface OrdersDAO {

    // 회원별 주문 목록 조회 (책 포함)
    List<OrderDTO> getOrdersByMember(int member_idx);
}
