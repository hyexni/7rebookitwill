package com.itwillbs.domain;

import java.sql.Date;
import lombok.Data;

@Data
public class NoticeVO {
	
	private int notice_id;
	private String ad_id;
	private String notice_title;
	private String notice_content;
	private Date notice_date;
	private boolean is_fixed;
	

}