package com.itwillbs.persistence;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.itwillbs.domain.Criteria;
import com.itwillbs.dto.OrderDTO;

@Repository
public class OrdersDAOImpl implements OrdersDAO {

	@Inject
	private SqlSession sqlSession;

	private static final String NAMESPACE = "com.itwillbs.mapper.OrdersMapper";

	// ✅ 사용자: 주문 상세 조회
	@Override
	public OrderDTO getOrderDetailByMember(int order_id, int member_idx) {
		// 두 개의 파라미터를 전달해야 하므로 Map 사용
		java.util.Map<String, Object> paramMap = new java.util.HashMap<>();
		paramMap.put("order_id", order_id);
		paramMap.put("member_idx", member_idx);
		return sqlSession.selectOne(NAMESPACE + ".getOrderDetailByMember", paramMap);
	}

	// ✅ 사용자: 페이징된 주문 목록 조회
	@Override
	public List<OrderDTO> getOrdersByMemberPaged(Criteria cri) {
		return sqlSession.selectList(NAMESPACE + ".getOrdersByMemberPaged", cri);
	}

	// ✅ 사용자: 주문 수 조회
	@Override
	public int getOrderCountByMember(int member_idx) {
		return sqlSession.selectOne(NAMESPACE + ".getOrderCountByMember", member_idx);
	}

	// ✅ 관리자: 주문 상세 조회
	@Override
	public OrderDTO getOrderDetailById(int order_id) {
		return sqlSession.selectOne(NAMESPACE + ".getOrderDetailById", order_id);
	}

	// 결제 상태 업데이트
	@Override
	public int updatePaymentStatus(int order_id, String status) {
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("order_id", order_id);
		paramMap.put("status", status);
		return sqlSession.update(NAMESPACE + ".updatePaymentStatus", paramMap);
	}

	// ✅ 관리자: 페이징된 주문 목록
	@Override
	public List<OrderDTO> getPagedOrders(Criteria cri) {
		return sqlSession.selectList(NAMESPACE + ".getPagedOrders", cri);
	}

	// ✅ 관리자: 전체 주문 수 (페이징용)
	@Override
	public int getTotalOrderCount(Criteria cri) {
		return sqlSession.selectOne(NAMESPACE + ".getTotalOrderCount", cri);
	}

	// ✅ 관리자: 배송 상태 업데이트
	@Override
	public void updateDeliveryStatus(int order_id, String status) {
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("order_id", order_id);
		paramMap.put("status", status);

		sqlSession.update(NAMESPACE + ".updateDeliveryStatus", paramMap);
	}

}
