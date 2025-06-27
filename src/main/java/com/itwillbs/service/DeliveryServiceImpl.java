package com.itwillbs.service;

import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.itwillbs.persistence.DeliveryDAO;

@Service
public class DeliveryServiceImpl implements DeliveryService {

	@Inject
	private DeliveryDAO deliveryDAO;

	// ✅ 배송 상태 업데이트 메서드 호출
	@Override
	public void updateStatusCode(int order_id, String status_code) {
		deliveryDAO.updateStatus(order_id, status_code);
	}

	// ✅ 운송장 번호 + 택배사 등록
	@Override
	public void updateTrackingInfo(Map<String, Object> paramMap) {
		deliveryDAO.updateTrackingInfo(paramMap);
	}
}
