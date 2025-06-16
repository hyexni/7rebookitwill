package com.itwillbs.domain;

import lombok.Data;

@Data
public class OrderitemVO {
	
	private int order_item_id;
	private int order_id;
	private int book_id;
	private int quantity;
	private int unit_price;

}
