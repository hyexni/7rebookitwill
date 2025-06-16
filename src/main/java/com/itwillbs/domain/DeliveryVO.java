package com.itwillbs.domain;

import java.sql.Date;
import lombok.Data;

@Data
public class DeliveryVO {
	
	private int delivery_id;
	private int order_id;
	private String status_code;
	private String shipper_name;
	private Date delivery_date;
	private String tracking_number;
	private String delivery_address;

}
