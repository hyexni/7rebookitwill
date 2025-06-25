package com.itwillbs.domain;

import java.sql.Timestamp;
import lombok.Data;

@Data
public class InquiryVO {
	
	private int inquiry_id;				// 문의ID
	private int member_idx;				// 회원 고유번호
	private String member_id;
	private String category; 			// 문의 분류 (이용문의, 배송문의 등)
	private String title;				// 문의 제목
	private String content;				// 문의 내용
	private String status;				// 처리 상태
	private Timestamp created_at;		// 작성 일시
	private Timestamp processed_at;

	
}