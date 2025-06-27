package com.itwillbs.service;

import java.util.Map;

public interface DeliveryService {

	// ✅ 배송 상태(status_code) 업데이트 요청
	void updateStatusCode(int order_id, String status_code);

	// ✅ 운송장 번호 + 택배사 등록
	void updateTrackingInfo(Map<String, Object> paramMap);

}
