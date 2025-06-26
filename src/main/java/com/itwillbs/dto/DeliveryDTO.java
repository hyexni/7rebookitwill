package com.itwillbs.dto;

import lombok.Data;

@Data
public class DeliveryDTO {

	private int order_id; // ✅ 꼭 추가해야 함
	private int member_idx;
	private String receiver_name;
	private String receiver_phone;
	private String zipcode;
	private String delivery_address;
	private String address_detail;
	private String memo;

	// 추가
	private String status_code; // 배송 상태
	private String tracking_number; // 운송장 번호

}
