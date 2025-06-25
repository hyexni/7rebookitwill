package com.itwillbs.domain;

import java.sql.Timestamp;

import lombok.Data;


@Data
public class BookReportVO {
	
	private int report_id;   
	private int member_idx;  	
	private String author_name;
	private String publisher;
	private String report_title; 
	private String report_text;	
    private Timestamp report_regdate;
    private String rbook_title;
   
    
	
}