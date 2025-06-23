package com.itwillbs.domain;

import java.sql.Timestamp;
import lombok.Data;

@Data
public class PaymentVO {
	
	private int payment_id;
	private int order_id;
	private int member_idx;
	private int pay_amount;
	private String pay_method;
	private int used_points;
	private Timestamp paid_at;
	private String status;
	private int saved_points;

}
