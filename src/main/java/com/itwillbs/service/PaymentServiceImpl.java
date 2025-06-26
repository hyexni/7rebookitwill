package com.itwillbs.service;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.itwillbs.domain.BookVO;
import com.itwillbs.domain.DeliveryVO;
import com.itwillbs.domain.MemberVO;
import com.itwillbs.domain.OrdersVO;
import com.itwillbs.domain.PaymentVO;
import com.itwillbs.dto.DeliveryDTO;
import com.itwillbs.dto.PaymentDTO;
import com.itwillbs.persistence.PaymentDAO;

@Service
public class PaymentServiceImpl implements PaymentService {
	
	@Inject
	private PaymentDAO pDAO;

	// 책 정보 가져오기
	@Override
	public BookVO getBookInfo(int book_id) {

		return pDAO.selectBook(book_id);
	}

	// 포인트 정보 가져오기
	@Override
	public int getPointTotal(int member_idx) {

		return pDAO.getMemberPoint(member_idx);
	}
	
	
	// 결제 처리
	@Override
	public boolean processPayment(PaymentDTO dto,  DeliveryDTO deliveryDTO) {

		if (dto.getUsed_points() < 0) {
		        throw new IllegalArgumentException("포인트는 0 이상이어야 합니다.");
		    }
		
		// 1. 포인트 차감
	    if (dto.getUsed_points() > 0) {
	        pDAO.usePoints(dto);
	    }


	    // 2. 주문 정보 저장
	    pDAO.insertOrder(dto);

	    // 3. 방금 insert한 order_id 가져오기
	    int orderId = pDAO.getLastOrderId();
	    dto.setOrder_id(orderId);
	    deliveryDTO.setOrder_id(orderId); // delivery에도 order_id 필요

	    // 4. 주문 상세 저장
	    pDAO.insertOrderItem(dto);

	    // 5. 결제 정보 저장
	    pDAO.insertPayment(dto);
	    
	    // 6. 포인트 적립
	    if (dto.getSaved_points() > 0) {
	        pDAO.givePoints(dto);
	    }


	    // 7. 배송 정보 저장
	    pDAO.insertDelivery(deliveryDTO);

	    return true;
	}
	
	
	
	// 결제 완료
	@Override
	public PaymentDTO getLatestPaymentSummary(int member_idx) {
	    return pDAO.getLatestSummary(member_idx);
	}
	
	@Override
	public OrdersVO getLatestOrder(int member_idx) {
	    return pDAO.getLatestOrder(member_idx);
	}

	@Override
	public PaymentVO getLatestPayment(int member_idx) {
	    return pDAO.getLatestPayment(member_idx);
	}

	@Override
	public DeliveryVO getLatestDelivery(int order_id) {
	    return pDAO.getLatestDelivery(order_id);
	}
	
	
	
	// 배송 정보
	@Override
	public MemberVO getMemberInfo(int member_idx) {
	    return pDAO.getMemberInfo(member_idx);
	}
	
	
	// 결제시 포인트 차감/적립 이력
	@Override
	public void insertPointUsage(PaymentDTO dto) {
	    pDAO.insertPointUsage(dto);
	}

	@Override
	public void insertPointHistory(PaymentDTO dto) {
	    pDAO.insertPointHistory(dto);
	}
	
	
	
	



	
	

}
