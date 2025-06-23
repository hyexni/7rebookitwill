package com.itwillbs.service;

import java.sql.Timestamp; // Timestamp 사용을 위해 추가
import java.time.LocalDateTime; // LocalDateTime 사용을 위해 추가
import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional; // 트랜잭션 관리를 위해 추가

import com.itwillbs.domain.PointVO;
import com.itwillbs.domain.ReceiptVO;
import com.itwillbs.domain.SearchCriteria;
import com.itwillbs.dto.PointHistoryDTO;
import com.itwillbs.persistence.PointHistoryDAO;
import com.itwillbs.persistence.ReceiptDAO;

@Service
public class PointHistoryServiceImpl implements PointHistoryService {

    @Inject
    private PointHistoryDAO pointHistoryDAO;
    

    private static final Logger logger = LoggerFactory.getLogger(PointHistoryServiceImpl.class);
    
    @Override
    public List<PointVO> getPointHistory(int memberIdx) throws Exception {
    	
    	System.out.println(pointHistoryDAO.getPointHistory(memberIdx));
    	
        return pointHistoryDAO.getPointHistory(memberIdx);
    }

    @Override
    public Integer getTotalPoints(int memberIdx) throws Exception {
        return pointHistoryDAO.getTotalPoints(memberIdx);
    }

//    // 포인트 적립 트랜잭션 처리
//    @Transactional
//    @Override
//    public void earnPoint(PointVO pointVO) throws Exception {
//        // 1. 현재 총 포인트 조회
//        Integer currentTotal = pointHistoryDAO.getTotalPoints(pointVO.getMember_idx());
//        if (currentTotal == null) {
//            currentTotal = 0; // 포인트 내역이 없으면 0으로 시작
//        }
//
//        // 2. 새로운 총 포인트 계산
//        int newTotal = currentTotal + pointVO.getChange_amount();
//
//        // 3. PointVO에 최종 포인트 잔액 및 현재 시간 설정
//        pointVO.setPoint_amount(newTotal); // 현재 시점의 총 포인트
//        pointVO.setChange_date(Timestamp.valueOf(LocalDateTime.now())); // 현재 시간 기록
//
//        // 4. 포인트 내역 DB에 삽입
//        pointHistoryDAO.insertPointHistory(pointVO);
//
//        // 5. (선택) 회원 테이블의 총 포인트 필드 업데이트 (만약 회원 테이블에 총 포인트 필드가 있다면)
//        // pointHistoryDAO.updateMemberTotalPoints(pointVO.getMember_idx(), newTotal);
//        // 이 부분은 시스템 설계에 따라 달라질 수 있습니다.
//        // 일반적으로는 포인트 내역 테이블만 관리하고, 총 포인트는 내역을 합산하여 조회하는 방식이 더 유연합니다.
//    }

    // 포인트 사용 트랜잭션 처리
    @Transactional
    @Override
    public void usePoint(PointVO pointVO) throws Exception {
        // 1. 현재 총 포인트 조회
        Integer currentTotal = pointHistoryDAO.getTotalPoints(pointVO.getMember_idx());
        if (currentTotal == null || currentTotal < Math.abs(pointVO.getChange_amount())) {
            throw new Exception("포인트가 부족합니다."); // 사용하려는 포인트보다 현재 포인트가 적을 경우 예외 발생
        }

        // 2. 새로운 총 포인트 계산
        int newTotal = currentTotal + pointVO.getChange_amount(); // change_amount는 이미 음수

        // 3. PointVO에 최종 포인트 잔액 및 현재 시간 설정
        pointVO.setPoint_amount(newTotal); // 현재 시점의 총 포인트
        pointVO.setChange_date(Timestamp.valueOf(LocalDateTime.now())); // 현재 시간 기록

        // 4. 포인트 내역 DB에 삽입
        pointHistoryDAO.insertPointHistory(pointVO);

        // 5. 회원 테이블의 총 포인트 필드 업데이트 (만약 회원 테이블에 총 포인트 필드가 있다면)
       // pointHistoryDAO.updateMemberTotalPoints(pointVO.getMember_idx(), newTotal);
    
    }
    
   //영수증으로 적립된 포인트 가져오기
	@Override
	public int earnPointsFromReceipt(ReceiptVO receipt) throws Exception {
		
		return 0;
	}
    
    
    
 // 수정된 DAO 메서드를 호출하도록 변경
    @Override
    public List<PointHistoryDTO> getPointHistoryList(SearchCriteria cri) {
        return pointHistoryDAO.getPointHistoryAdmin(cri);
    }

    //수정된 DAO 메서드를 호출하도록 변경
    @Override
    public int getPointHistoryCount(SearchCriteria cri) {
        return pointHistoryDAO.getPointHistoryCount(cri);
    }

    
    
    
    
    
}