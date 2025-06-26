package com.itwillbs.dto;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class OrderDTO {
	// 주문 정보
	private int order_id;
	private int member_idx;
	private Timestamp order_date;
	private int total_price;
	private String status;

	// 책 정보 (단일 주문 기준)
	private String book_title;
	private String book_cover;
	private int book_count;

	// 결제 정보
	private String payment_method;
	private int used_point;

	// 적립될 포인트
	private int earned_point;

	// 배송 정보 포함
	private DeliveryDTO delivery;
}