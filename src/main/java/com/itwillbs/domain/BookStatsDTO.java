package com.itwillbs.domain;

import lombok.Data;

@Data
public class BookStatsDTO {
	
	private int bookId;
	private String bookTitle;
	private String categoryName;
	private String coverImage;	  // 도서 커버 이미지

	private int totalSales;       // 도서별 판매량
	private int totalReviews;     // 도서별 리뷰 수
	private double avgRating;     // 도서별 평균 평점
	
	private String authorName;
	private int bookPrice;


}