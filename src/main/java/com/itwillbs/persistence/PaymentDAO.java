package com.itwillbs.persistence;

import com.itwillbs.domain.BookVO;
import com.itwillbs.domain.DeliveryVO;
import com.itwillbs.domain.MemberVO;
import com.itwillbs.domain.OrdersVO;
import com.itwillbs.domain.PaymentVO;
import com.itwillbs.dto.DeliveryDTO;
import com.itwillbs.dto.PaymentDTO;

public interface PaymentDAO {
	
	// 책 정보, 포인트 정보 가져오기
	BookVO selectBook(int book_id);
	int getMemberPoint(int member_idx);
	
	// 결제 처리
	// 2. 주문 저장
	void insertOrder(PaymentDTO dto);
	int getLastOrderId();

	// 3. 주문 상세 저장
	void insertOrderItem(PaymentDTO dto);
	
	// 4. 결제 저장
	void insertPayment(PaymentDTO dto);

	// 배송 저장
	void insertDelivery(DeliveryDTO dto);
	
	
	
	// 결제 완료
	PaymentDTO getLatestSummary(int member_idx);
	OrdersVO getLatestOrder(int member_idx);
	PaymentVO getLatestPayment(int member_idx);
	DeliveryVO getLatestDelivery(int member_idx);
	
	// 배송 정보
	public MemberVO getMemberInfo(int member_idx);
	
	// 간편결제
	boolean processPayment(PaymentDTO dto, DeliveryDTO deliveryDTO);
	
	// 결제 시 포인트 차감/적립 이력
	void insertPointUsage(PaymentDTO dto);
	void insertPointHistory(PaymentDTO dto);


}
