package com.itwillbs.domain;

import java.sql.Timestamp;
import java.util.List;

import com.itwillbs.dto.ReceiptItemDTO;

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
    private String verification_status;
    private int earnedPoints; 

    // 여러 개의 구매 품목 정보를 담는 리스트
    private List<ReceiptItemDTO> items;

    // 파일 해시와 검증 상태를 담을 필드
    private String fileHash;
	//public void setFileHash(String fileHash) {
	
		
	
}
 

