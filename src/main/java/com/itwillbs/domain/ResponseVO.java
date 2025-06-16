package com.itwillbs.domain;

import java.sql.Timestamp;
import lombok.Data;

@Data
public class ResponseVO {
	
	private int response_id;
	private int inquiry_id;
	private String ad_id;
	private String response_content;
	private Timestamp created_at;

}