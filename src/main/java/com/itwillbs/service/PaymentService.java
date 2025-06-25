package com.itwillbs.service;

import com.itwillbs.domain.BookVO;
import com.itwillbs.domain.DeliveryVO;
import com.itwillbs.domain.MemberVO;
import com.itwillbs.domain.OrdersVO;
import com.itwillbs.domain.PaymentVO;
import com.itwillbs.dto.DeliveryDTO;
import com.itwillbs.dto.PaymentDTO;

public interface PaymentService {
	
	// 책 정보, 포인트 정보 가져오기
	BookVO getBookInfo(int book_id);
	int getPointTotal(int member_idx);
	
	// 결제 처리
	boolean processPayment(PaymentDTO dto, DeliveryDTO deliveryDTO);
	
	// 결제 완료
	PaymentDTO getLatestPaymentSummary(int member_idx);
	OrdersVO getLatestOrder(int member_idx);
	PaymentVO getLatestPayment(int member_idx);
	DeliveryVO getLatestDelivery(int order_id);
	
	// 배송 정보
	public MemberVO getMemberInfo(int member_idx);
	
	// 포인트 이력 저장
	void insertPointUsage(PaymentDTO dto);
	void insertPointHistory(PaymentDTO dto);
	



}
