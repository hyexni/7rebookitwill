package com.itwillbs.service;

import com.itwillbs.domain.ReceiptVO;

public interface AdminReceiptService {
  
	/**
     * 특정 영수증의 상세 정보를 조회합니다.
     * @param upload_id 조회할 영수증의 ID
     * @return 조회된 영수증 상세 정보
     * @throws Exception 데이터 조회 실패 시 예외 발생
     */
    ReceiptVO getReceiptDetail(int upload_id) throws Exception;
}
