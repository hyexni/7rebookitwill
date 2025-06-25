package com.itwillbs.service;

import java.util.List;
import com.itwillbs.dto.OrderDTO;

public interface OrdersService {
    //  회원별 주문 목록 조회
    List<OrderDTO> getOrdersByMember(int member_idx);
}
