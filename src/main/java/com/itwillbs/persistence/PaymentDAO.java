package com.itwillbs.persistence;

import com.itwillbs.domain.BookVO;
import com.itwillbs.domain.DeliveryVO;
import com.itwillbs.domain.MemberVO;
import com.itwillbs.domain.OrdersVO;
import com.itwillbs.domain.PaymentVO;
import com.itwillbs.dto.PaymentDTO;

public interface PaymentDAO {
	
	// 책 정보, 포인트 정보 가져오기
	BookVO selectBook(int book_id);
	int getMemberPoint(int member_idx);
	
	// 결제 처리
	// 1. 포인트 차감
	void usePoints(PaymentDTO dto);

	// 2. 주문 저장
	void insertOrder(PaymentDTO dto);
	int getLastOrderId();

	// 3. 주문 상세 저장
	void insertOrderItem(PaymentDTO dto);
	
	// 4. 결제 저장
	void insertPayment(PaymentDTO dto);

	// 5. 포인트 적립
	void givePoints(PaymentDTO dto);
	
	
	// 결제 완료
	PaymentDTO getLatestSummary(int member_idx);
	OrdersVO getLatestOrder(int member_idx);
	PaymentVO getLatestPayment(int member_idx);
	DeliveryVO getLatestDelivery(int member_idx);
	
	// 배송 정보
	public MemberVO getMemberInfo(int member_idx);



}
