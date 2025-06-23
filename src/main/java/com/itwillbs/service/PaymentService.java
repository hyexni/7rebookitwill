package com.itwillbs.service;

import com.itwillbs.domain.BookVO;
import com.itwillbs.dto.PaymentDTO;

public interface PaymentService {
	
	// 책 정보, 포인트 정보 가져오기
	BookVO getBookInfo(int book_id);
	int getPointTotal(int member_idx);
	
	// 결제 처리
	boolean processPayment(PaymentDTO dto);
	
	// 결제 완료
	PaymentDTO getLatestPaymentSummary(int member_idx);


}
