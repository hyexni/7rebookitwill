package com.itwillbs.domain;

import java.sql.Timestamp;
import lombok.Data;

@Data
public class RefundRequestVO {
	
	private int refund_id;
	private int order_id;
	private String reason;
	private String status;
	private Timestamp requested_at;

}