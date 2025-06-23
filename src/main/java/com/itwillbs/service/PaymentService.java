package com.itwillbs.service;

import com.itwillbs.domain.BookVO;

public interface PaymentService {
	
	// 책 정보, 포인트 정보 가져오기
	BookVO getBookInfo(int book_id);
	int getPointTotal(int member_idx);

}
