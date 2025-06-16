package com.itwillbs.domain;

import java.sql.Date;
import lombok.Data;

@Data
public class BookReportVO {
	
	private int report_id;
	private int member_idx;
	private int book_id;
	private String author_name;
	private String publisher;
	private Date read_date;
	private String report_text;
	private String report_image1;
	private String report_image2;
	private String report_image3;
	private boolean is_public;

}
