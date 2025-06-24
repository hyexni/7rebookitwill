package com.itwillbs.persistence;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.itwillbs.domain.BookVO;
import com.itwillbs.domain.DeliveryVO;
import com.itwillbs.domain.MemberVO;
import com.itwillbs.domain.OrdersVO;
import com.itwillbs.domain.PaymentVO;
import com.itwillbs.dto.PaymentDTO;

@Repository
public class PaymentDAOImpl implements PaymentDAO {
	
	@Inject
	private SqlSession sqlSession;
	
	private static final String NAMESPACE = "com.itwillbs.persistence.PaymentDAO.";

	
	
	// 책 정보 가져오기
	@Override
	public BookVO selectBook(int book_id) {

		return sqlSession.selectOne(NAMESPACE + "selectBook", book_id);
	}

	
	// 포인트 정보 가져오기
	@Override
	public int getMemberPoint(int member_idx) {

		return sqlSession.selectOne(NAMESPACE + "getMemberPoint", member_idx);
	}
	
	// 결제 처리
	// 1. 포인트 차감
	@Override
	public void usePoints(PaymentDTO dto) {
	    sqlSession.update(NAMESPACE + "usePoints", dto);
	}

	// 2. 주문 저장
	@Override
	public void insertOrder(PaymentDTO dto) {
	    sqlSession.insert(NAMESPACE + "insertOrder", dto);
	}

	@Override
	public int getLastOrderId() {
	    return sqlSession.selectOne(NAMESPACE + "getLastOrderId");
	}

	// 3. 주문 상세 저장
	@Override
	public void insertOrderItem(PaymentDTO dto) {
	    sqlSession.insert(NAMESPACE + "insertOrderItem", dto);
	}

	// 4. 결제 저장
	@Override
	public void insertPayment(PaymentDTO dto) {
	    sqlSession.insert(NAMESPACE + "insertPayment", dto);
	}

	// 5. 포인트 적립
	@Override
	public void givePoints(PaymentDTO dto) {
	    sqlSession.update(NAMESPACE + "givePoints", dto);
	}

	
	// 결제 완료
	@Override
	public PaymentDTO getLatestSummary(int member_idx) {
	    return sqlSession.selectOne(NAMESPACE + "getLatestSummary", member_idx);
	}
	
	@Override
	public OrdersVO getLatestOrder(int member_idx) {
		return sqlSession.selectOne("payment.getLatestOrder", member_idx);
	}

	@Override
	public PaymentVO getLatestPayment(int member_idx) {
		return sqlSession.selectOne("payment.getLatestPayment", member_idx);
	}

	@Override
	public DeliveryVO getLatestDelivery(int member_idx) {
		return sqlSession.selectOne("payment.getLatestDelivery", member_idx);
	}


	// 배송 정보
	@Override
	public MemberVO getMemberInfo(int member_idx) {
	    return sqlSession.selectOne("payment.getMemberInfo", member_idx);
	}


	@Override
    public boolean processPayment(PaymentDTO dto) {
        try {
            sqlSession.update(NAMESPACE + "usePoints", dto);
            sqlSession.insert(NAMESPACE + "insertOrder", dto);
            int order_id = sqlSession.selectOne(NAMESPACE + "getLastOrderId");
            dto.setOrder_id(order_id);
            sqlSession.insert(NAMESPACE + "insertOrderItem", dto);
            sqlSession.insert(NAMESPACE + "insertPayment", dto);
            sqlSession.update(NAMESPACE + "givePoints", dto);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}


	
	
}

















