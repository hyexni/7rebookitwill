package com.itwillbs.domain;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class ReviewVO {
	
	private int review_id;
	private int member_idx;
	private int book_id;
	private String review_image1;
	private String review_image2;
	private String review_image3;
	private String review_text;
	private Integer review_score;
	private Timestamp review_date;
	private String member_name;  // 작성자 이름 추가
	

}