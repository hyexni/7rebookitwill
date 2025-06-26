package com.itwillbs.persistence;

import com.itwillbs.domain.ReceiptVO;

public interface AdminReceiptDAO {
	 /**
     * 데이터베이스에서 특정 영수증 정보를 조회합니다.
     * @param upload_id 조회할 영수증의 ID
     * @return 조회된 영수증 정보
     */
    ReceiptVO selectReceiptDetail(int upload_id);

}
