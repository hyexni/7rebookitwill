package com.itwillbs.persistence;

import com.itwillbs.domain.BookVO;

public interface PaymentDAO {
	
	// 책 정보, 포인트 정보 가져오기
	BookVO selectBook(int book_id);
	int getMemberPoint(int member_idx);

}
