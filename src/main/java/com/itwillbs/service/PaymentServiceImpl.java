package com.itwillbs.service;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.itwillbs.domain.BookVO;
import com.itwillbs.domain.DeliveryVO;
import com.itwillbs.domain.MemberVO;
import com.itwillbs.domain.OrdersVO;
import com.itwillbs.domain.PaymentVO;
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
	public boolean processPayment(PaymentDTO dto) {
	    try {
	        // 1. 포인트 차감
	        pDAO.usePoints(dto);

	        // 2. 주문 저장
	        pDAO.insertOrder(dto);
	        int order_id = pDAO.getLastOrderId();
	        dto.setOrder_id(order_id);

	        // 3. 주문 상세 저장
	        pDAO.insertOrderItem(dto);

	        // 4. 결제 저장
	        pDAO.insertPayment(dto);

	        // 5. 포인트 적립
	        pDAO.givePoints(dto);

	        return true;
	    } catch (Exception e) {
	        e.printStackTrace();
	        return false;
	    }
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
