package com.itwillbs.persistence;

import java.util.List;

import com.itwillbs.domain.ReceiptVO;

//ReceiptUploadDAO : 서비스의 요청을 받아서 SQL 구문을 실행

public interface ReceiptDAO {	
	
	public void ReceiptUploadInsert(ReceiptVO vo) throws Exception;
	 /**
     * 파일명이 DB에 이미 존재하는지 확인하는 메서드
     * @param originalFilename 확인할 원본 파일명
     * @return 중복이면 true, 아니면 false
     */
    // 서비스에서 사용하는 isDuplicate 메서드 선언 추가
    public boolean isDuplicate(String originalFilename);
    
    // 모든 영수증 목록을 조회하는 메서드 선언
    public List<ReceiptVO> selectAllReceipts() throws Exception;
    
    int countByFilename(String filename);
	public void insertReceipt(ReceiptVO vo);


}
