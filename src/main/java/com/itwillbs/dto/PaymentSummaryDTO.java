package com.itwillbs.dto;

import lombok.Data;

@Data
public class PaymentSummaryDTO {
	
	private int order_id;
	private int pay_amount;
	private String pay_method;
	private int used_points;

}
