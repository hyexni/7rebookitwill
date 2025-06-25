package com.itwillbs.dto;

import java.sql.Timestamp;
import lombok.Data;

@Data
public class OrderDTO {
  private int order_id;
  private Timestamp order_date;
  private int total_price;
  private String status;

  // 책 정보
  private String book_title;
  private String book_cover;
  private int book_count;
}
