package com.itwillbs.dto;

import lombok.Data;

@Data
public class DeliveryDTO {
	
	private String member_name;
	private String member_phone;
	private String member_address;
	private String member_address_detail;
	private String member_zipcode;
	private String delivery_memo;

}
