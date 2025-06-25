package com.itwillbs.domain;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;


@Data
public class BookReportVO {
	
	private int report_id;   
	private int member_idx;   
	private int book_id;	
	private String author_name;
	private String publisher;
	private String report_title; //
	
	//날짜
	@DateTimeFormat(pattern="yyyy/MM/dd")
	private Date read_date;	
	private String report_text;	
    private Date report_regdate;
	
}