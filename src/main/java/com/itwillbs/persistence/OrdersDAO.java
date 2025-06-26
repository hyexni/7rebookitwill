package com.itwillbs.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.itwillbs.domain.Criteria;
import com.itwillbs.dto.OrderDTO;

public interface OrdersDAO {

	  // ✅ [사용자] 주문 상세 조회 (내가 주문한 상세 정보 1건 조회)
		OrderDTO getOrderDetailByMember(@Param("order_id") int order_id,
        @Param("member_idx") int member_idx);
	

	  // ✅ [사용자] 전체 주문 목록 조회 (내가 주문한 목록 전체 조회)
	  List<OrderDTO> getOrdersByMember(int member_idx);

	  // ✅ [사용자] 페이징된 주문 목록 조회 (내가 주문한 목록 + 페이징 처리)
	  List<OrderDTO> getOrdersByMemberPaged(Criteria cri);

	  // ✅ [사용자] 주문 수 조회  (내가 주문한 총 건수 (페이징용))
	  int getOrderCountByMember(int member_idx);

	  // ✅ [관리자] 주문 상세 조회 (관리자: 특정 주문 상세 보기)
	  OrderDTO getOrderDetailById(int order_id);

	  // ✅ [관리자] 전체 주문 목록 조회 (전체 주문 목록 (페이징 X))
	  List<OrderDTO> getAllOrders();

	  // ✅ [관리자] 페이징된 주문 목록 조회 (전체 주문 목록 + 페이징 처리)
	  List<OrderDTO> getPagedOrders(Criteria cri);

	  // ✅ [관리자] 전체 주문 수 조회 (전체 주문 수 조회 (페이징용))
	  int getTotalOrderCount(Criteria cri);
	}
