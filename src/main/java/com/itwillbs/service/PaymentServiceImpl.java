package com.itwillbs.service;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.itwillbs.domain.BookVO;
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
	
	

}
