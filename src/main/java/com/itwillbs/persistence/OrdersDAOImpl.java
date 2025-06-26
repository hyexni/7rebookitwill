package com.itwillbs.persistence;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.itwillbs.dto.OrderDTO;

@Repository
public class OrdersDAOImpl implements OrdersDAO {

	@Inject
	private SqlSession sqlSession;

	// ✅ Mapper 네임스페이스 경로 (OrdersMapper.xml)
	private static final String NAMESPACE = "com.itwillbs.mapper.OrdersMapper";

	// ✅ 사용자: 주문 상세 조회
	@Override
	public OrderDTO getOrderDetailByMember(Map<String, Object> paramMap) {
		return sqlSession.selectOne(NAMESPACE + ".getOrderDetailByMember", paramMap);
	}

	// ✅ 사용자: 주문 목록 조회
	@Override
	public List<OrderDTO> getOrdersByMember(int member_idx) {
		return sqlSession.selectList(NAMESPACE + ".getOrdersByMember", member_idx);
	}

	// ✅ 관리자: 주문 상세 조회
	@Override
	public OrderDTO getOrderDetailById(int order_id) {
		return sqlSession.selectOne(NAMESPACE + ".getOrderDetailById", order_id);
	}

	// ✅ 관리자: 전체 주문 목록 조회
	@Override
	public List<OrderDTO> getAllOrders() {
		return sqlSession.selectList(NAMESPACE + ".getAllOrders");
	}

}
