package com.itwillbs.dto;

import java.sql.Timestamp;
import lombok.Data;

@Data
public class AdminReceiptDTO {
    // ReceiptVO의 필드
    private int upload_id;
    private int member_idx;
    private String ocr_store;
    private int ocr_amount;
    private Timestamp ocr_date;
    private Timestamp upload_time;
    private String upload_status;
    
    // Member 테이블에서 JOIN해서 가져올 필드
    private String member_id; // 예시: 회원의 아이디
    private String member_name; // 예시: 회원의 이름
}