package com.itwillbs.dto;

import lombok.Data;

@Data
public class PaymentDTO {
	
	// 결제
	private int book_id;
	private int member_idx;
	private int unit_price;
	private int quantity;
	private int total_price;
	private int used_points;
	private int saved_points;
	private int pay_amount;
	private int order_id;
	private String pay_method;

	
	// 배송
	private String member_name;
	private String member_phone;
	private String member_address;
	private String member_address_detail;
	private DeliveryDTO deliveryInfo;


}
