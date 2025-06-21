package com.itwillbs.domain;

import java.sql.Timestamp;
import lombok.Data;

@Data
public class NoticeVO {
	
	private int notice_id;
	private String ad_id;
	private String notice_title;
	private String notice_content;
	private Timestamp notice_date;
	private Timestamp updated_at;
	private boolean fixed;
	

}