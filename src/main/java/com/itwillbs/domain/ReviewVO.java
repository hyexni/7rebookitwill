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
	private String member_name; // 작성자 이름 추가
	private String review_status; // 리뷰 상태 추가 (관리자 필요)
	private String member_nick; // 작성자 닉네임
	private String book_title;
	private String member_id;
	private String reason;

}