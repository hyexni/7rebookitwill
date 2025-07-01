package com.itwillbs.service;

import java.sql.Timestamp; // Timestamp 사용을 위해 추가
import java.time.LocalDateTime; // LocalDateTime 사용을 위해 추가
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
    public void addPoint(int member_idx, int change_amount, String change_reason, String point_status) throws Exception {
        
    	 // 특정 사유일 경우 실행하지 않음
        if ("영수증 인증 적립".equals(change_reason)) {
            return; // 메소드 종료
        }
    	
        // 1. 전달받은 정보로 PointVO 객체를 만듭니다.
        PointVO pointVO = new PointVO();
        pointVO.setMember_idx(member_idx);
        pointVO.setChange_amount(change_amount);
        pointVO.setChange_reason(change_reason);
        pointVO.setPoint_status("적립 완료");
        
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

    @Override
    public Map<String, Long> getMonthlyAccrualStats() {
        // DAO로부터 DB 조회 결과를 List<Map<...>> 형태로 받음
        List<Map<String, Object>> statsList = pointHistoryDAO.getMonthlyAccrualStats(); // pointMapper -> pointDAO
        
        // 이하 데이터 가공 로직은 동일
        Map<String, Long> statsMap = new HashMap<>();
        statsMap.put("신규 회원가입 축하", 0L);
        statsMap.put("영수증 인증 적립", 0L);
        statsMap.put("결제 적립금", 0L);

        for (Map<String, Object> stat : statsList) {
            String reason = (String) stat.get("reason");
            Long total = ((Number) stat.get("total")).longValue();
            
            if (reason != null) {
                statsMap.put(reason, total);
            }
        }
        return statsMap;
    }

    @Override
    public Map<String, Long> getMonthlyUsageStats() {
        List<Map<String, Object>> statsList = pointHistoryDAO.getMonthlyUsageStats(); // pointMapper -> pointDAO
        
        // 이하 데이터 가공 로직은 동일
        Map<String, Long> statsMap = new HashMap<>();
        statsMap.put("적립", 0L);
        statsMap.put("사용", 0L);

        for (Map<String, Object> stat : statsList) {
            String type = (String) stat.get("type");
            Long total = ((Number) stat.get("total")).longValue();

            if ("accrual".equals(type)) {
                statsMap.put("적립", total);
            } else if ("usage".equals(type)) {
                statsMap.put("사용", total);
            }
        }
        return statsMap;
    }
    
    /**
     * [관리자] 특정 회원에게 포인트를 수동으로 지급하는 트랜잭션 메소드
     */
    // 데이터 변경이 2회 이상 발생하므로 반드시 트랜잭션 처리를 해야 합니다.
    // 작업 중 하나라도 실패하면 모든 DB 변경사항이 롤백됩니다.
    @Transactional(rollbackFor = Exception.class)
    @Override
    public void addPointByAdmin(int member_idx, int change_amount, String change_reason) throws Exception {
        
        // 1. 대상 회원이 있는지, 현재 포인트는 얼마인지 조회
        //    (회원 존재 여부 체크 로직은 필요에 따라 추가)
        Integer currentPoints = pointHistoryDAO.selectMemberPoints(member_idx);
        if (currentPoints == null) {
            // 포인트 내역이 없는 신규 회원일 경우 0으로 처리
            currentPoints = 0; 
        }

        // 2. 지급 후 새로운 총 포인트 계산
        int newTotalPoints = currentPoints + change_amount;

        // 3. 포인트 내역(point) 테이블에 기록할 정보를 PointVO에 담기
        PointVO pointVO = new PointVO();
        pointVO.setMember_idx(member_idx);
        pointVO.setChange_amount(change_amount);
        pointVO.setPoint_amount(newTotalPoints);  
        pointVO.setChange_reason(change_reason);
        pointVO.setPoint_status("관리자 지급");
        
        // 2. DAO를 호출하여 DB에 '내역'만 기록하고 끝냅니다.
        pointHistoryDAO.insertPointHistory(pointVO);
    }

    
}