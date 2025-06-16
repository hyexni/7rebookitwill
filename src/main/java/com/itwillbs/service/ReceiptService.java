package com.itwillbs.service;

import java.util.List;

import com.itwillbs.domain.ReceiptVO;

public interface ReceiptService {
   
	public boolean isDuplicate(String originalFilename); 
	public void ReceiptUpload(ReceiptVO vo) throws Exception;

	// 모든 영수증 목록을 가져오는 메서드
    public List<ReceiptVO> getAllReceipts() throws Exception;
}
