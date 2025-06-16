package com.itwillbs.domain;

import java.sql.Timestamp;
import lombok.Data;

@Data
public class OrdersVO {
	
	private int order_id;
	private int member_idx;
	private int total_price;
	private String status;
	private Timestamp order_date;
	private String delivery_address;

}
