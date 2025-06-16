package com.itwillbs.domain;

import java.sql.Date;
import java.sql.Timestamp;
import java.util.List;

// [해결] OcrUtil 내부에 있는 ReceiptItem 클래스를 import 합니다.
import com.itwillbs.service.OcrUtil.ReceiptItem;

import jdk.jfr.DataAmount;
import lombok.Data;

@Data
public class ReceiptVO {
	
	private int upload_id;
	private int member_idx;
	private Timestamp upload_time;
	private String upload_status;	
	private String originalfilename;
	private String savedfilename;
	private String filepath;
	private int file_size;
	private String file_type;
	private String ocr_text;
    
  	private String ocr_booktitle; 
	
    private Timestamp ocr_date;
	private int ocr_amount;
	private String ocr_store;
	private String approvalnumber;
	
	// 여러 개의 구매 품목 정보를 담는 리스트
	private List<ReceiptItem> items;
	
	// 파일 해시와 검증 상태를 담을 필드
    private String fileHash;
    private String verification_status;
}