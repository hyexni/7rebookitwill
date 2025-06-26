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

    /**
     * [가장 간단한 방식]
     * 포인트 변동 내역을 DB에 기록하기만 하는 메소드입니다.
     */
    @Transactional
    @Override
    public void addPoint(int member_idx, int change_amount, String change_reason) throws Exception {
        
    	 // 특정 사유일 경우 실행하지 않음
        if ("영수증 인증 적립".equals(change_reason)) {
            return; // 메소드 종료
        }
    	
        // 1. 전달받은 정보로 PointVO 객체를 만듭니다.
        PointVO pointVO = new PointVO();
        pointVO.setMember_idx(member_idx);
        pointVO.setChange_amount(change_amount);
        pointVO.setChange_reason(change_reason);
        
        // 2. DAO를 호출하여 DB에 '내역'만 기록하고 끝냅니다.
        pointHistoryDAO.insertPointHistory(pointVO);
    }


    
   //영수증으로 적립된 포인트 가져오기
	@Override
	public int earnPointsFromReceipt(ReceiptVO receipt) throws Exception {
		
		return 0;
	}
    
		
    //포인트를 멤버테이블에 업데이트 하는 메서드
	  @Transactional
	  @Override
	  public void updateMemberTotalPoints(int member_idx) throws Exception {
						
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