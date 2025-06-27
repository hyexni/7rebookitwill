package com.itwillbs.persistence;

import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

@Repository
public class DeliveryDAOImpl implements DeliveryDAO {

	@Inject
	private SqlSession sqlSession;

	private static final String NAMESPACE = "com.itwillbs.mapper.DeliveryMapper";

	// ✅ 배송 상태 업데이트 구현
	@Override
	public void updateStatus(int order_id, String status_code) {
		// Mapper에 전달할 파라미터 구성
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("order_id", order_id);
		paramMap.put("status_code", status_code);

		sqlSession.update(NAMESPACE + ".updateStatus", paramMap);
	}

	// ✅ 운송장 번호 + 택배사 등록
	@Override
	public void updateTrackingInfo(Map<String, Object> paramMap) {
		sqlSession.update(NAMESPACE + ".updateTrackingInfo", paramMap);
	}

}
