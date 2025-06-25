package com.itwillbs.service;

import com.itwillbs.domain.PointVO;
import com.itwillbs.domain.ReceiptVO;
import com.itwillbs.domain.SearchCriteria;
import com.itwillbs.dto.PointHistoryDTO;

import java.util.List;

public interface PointHistoryService {
	
	//--사용자 모드--//
    // 특정 회원의 포인트 내역을 가져오는 메서드
    public List<PointVO> getPointHistory(int memberIdx) throws Exception;

    // 회원의 현재 총 포인트를 가져오는 메서드 
    public Integer getTotalPoints(int memberIdx) throws Exception;

   // ✨ 포인트 적립/사용 메서드
    public void addPoint(int member_idx, int change_amount, String change_reason) throws Exception;

    // 포인트 사용 처리 메서드 
    public void usePoint(PointVO pointVO) throws Exception;
    
    
    /**
     * [기능 추가] 처리된 영수증 정보를 바탕으로 포인트를 계산하고 적립합니다.
     * 포인트 적립과 관련된 모든 비즈니스 로직(계산, 내역 저장, 총액 업데이트)은 이 메서드 안에서 트랜잭션으로 처리됩니다.
     * * @param receipt 포인트 적립의 근거가 되는, 처리가 완료된 영수증 객체
     * @return 실제로 적립된 포인트. 적립이 없으면 0을 반환.
     * @throws Exception
     */
    int earnPointsFromReceipt(ReceiptVO receipt) throws Exception;
    
    //--관리자 모드--//
 // [수정] 파라미터를 SearchCriteria 객체로 변경
    public List<PointHistoryDTO> getPointHistoryList(SearchCriteria cri);

    // [수정] 파라미터를 SearchCriteria 객체로 변경
    public int getPointHistoryCount(SearchCriteria cri);
    
}