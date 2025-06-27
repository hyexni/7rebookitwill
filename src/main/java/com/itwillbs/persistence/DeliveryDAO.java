package com.itwillbs.persistence;

import java.util.Map;

public interface DeliveryDAO {

	// ✅ 배송 상태 업데이트
	void updateStatus(int order_id, String status_code);

	// ✅ 운송장 번호 + 택배사 등록
	void updateTrackingInfo(Map<String, Object> paramMap);
}