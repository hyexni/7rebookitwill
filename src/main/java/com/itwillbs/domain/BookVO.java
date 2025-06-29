package com.itwillbs.domain;

import java.sql.Date;
import java.sql.Timestamp;
import lombok.Data;

@Data
public class BookVO {
	
	//  도서 기본 정보 (DB 매핑 필드)
	private int book_id;
	private String book_title;
	private String author_name;
	private String publisher;
	private Date publish_date;
	private int book_price;
	private String stock_status;
	private String book_summary;
	private String cover_image;
	private int category_id;
	private String isbn;
	private int book_stock;
	private Timestamp created_at;
	private Timestamp updated_at;
	
	// 정렬용 조회 필드 (JOIN 결과 매핑용)
	private int salesCount;        // 판매 수량 (orderitem 기반)
	private double averageRating;  // 평균 평점 (review 기반)
	private int reviewCount;       // 리뷰 개수 (review 기반)
	
	// 관리자
	private String category_name_ko;

}