package com.itwillbs.domain;

import java.time.LocalDate;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;


@Data
public class BookReportVO {
	
	private Integer report_id;   // [수정] int -> Integer : 글 작성 시 id는 null이므로 반드시 변경해야 합니다.
	private Integer member_idx;  // [수정] int -> Integer : 안전성을 위해 변경합니다.
	private Integer book_id;     // [수정] int -> Integer : 선택사항이므로 null을 허용해야 합니다.
	
	private String author_name;
	private String publisher;
	private String book_title; // book_title 필드 추가 (JSP 폼 name과 일치)
	
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private LocalDate read_date;
	
	
	private String report_text;
	private String report_image1;
	private String report_image2;
	private String report_image3;
	private boolean is_public;

	/**
	 * JSP의 name="status" 파라미터를 받아 is_public 필드를 설정하는 커스텀 Setter.
	 * Lombok을 사용하더라도 이 메소드는 직접 작성해야 합니다.
	 */
	public void setStatus(String status) {
        // "public"이라는 문자열이 넘어왔을 때만 is_public을 true로 설정
        this.is_public = "public".equals(status);
    }
}