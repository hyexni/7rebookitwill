package com.itwillbs.dto;

import lombok.Data;

@Data
public class PaymentDTO {
	
	private int member_idx;
	private int book_id;
	private int quantity;
	private int unit_price;
	private int used_points;
	private int pay_amount;
	private String pay_method;
	private int order_id;

}
