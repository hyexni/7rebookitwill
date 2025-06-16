package com.itwillbs.domain;

import java.sql.Timestamp;
import lombok.Data;

@Data
public class InquiryVO {
	
	private int inquiry_id;
	private int member_idx;
	private String title;
	private String content;
	private String status;
	private Timestamp created_at;

}