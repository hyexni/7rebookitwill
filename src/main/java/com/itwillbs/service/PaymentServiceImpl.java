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
	public boolean processPayment(PaymentDTO dto, DeliveryDTO deliveryDTO) {
		// 포인트 유효성 검사만 여기서 하고
	    if (dto.getUsed_points() < 0) {
	        throw new IllegalArgumentException("포인트는 0 이상이어야 합니다.");
	    }

	    // 나머지 DB 처리 전부 DAO에 위임
	    return pDAO.processPayment(dto, deliveryDTO);
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
	public DeliveryVO getLatestDelivery(int member_idx) {
	    return pDAO.getLatestDelivery(member_idx);
	}
	
	
	
	// 배송 정보
	@Override
	public MemberVO getMemberInfo(int member_idx) {
	    return pDAO.getMemberInfo(member_idx);
	}



	
	

}
