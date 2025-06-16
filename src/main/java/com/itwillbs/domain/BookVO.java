package com.itwillbs.domain;

import java.sql.Date;
import java.sql.Timestamp;
import lombok.Data;

@Data
public class BookVO {
	
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

}