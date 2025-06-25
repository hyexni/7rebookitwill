package com.itwillbs.domain;

import java.sql.Date;
import lombok.Data;

@Data
public class DeliveryVO {
	
	private int delivery_id;
	private int order_id;
	private int member_idx;
	private String receiver_name;
	private String receiver_phone;
	private String zipcode;
	private String delivery_address;
	private String address_detail;
	private String memo;
	private String status_code;
	private String shipper_name;
	private Date delivery_date;
	private String tracking_number;

}
