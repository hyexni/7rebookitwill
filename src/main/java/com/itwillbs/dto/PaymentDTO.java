package com.itwillbs.dto;

import lombok.Data;

@Data
public class PaymentDTO {
	
	// 결제
	private int member_idx;
	private int book_id;
	private int quantity;
	private int unit_price;
	private int used_points;
	private int pay_amount;
	private String pay_method;
	private int order_id;
	
	// 배송
	private String member_name;
	private String member_phone;
	private String member_address;
	private String member_address_detail;
	private DeliveryDTO deliveryInfo;


}
