package com.itwillbs.persistence;

import java.util.List;

import com.itwillbs.domain.PointVO;
import com.itwillbs.domain.SearchCriteria;
import com.itwillbs.dto.PointHistoryDTO;

public interface PointHistoryDAO {
	
	//-사용자 모드-//
	
    // 특정 회원의 포인트 내역을 DB에서 가져오는 메서드
    public List<PointVO> getPointHistory(int member_idx) throws Exception;

    // 회원의 현재 총 포인트를 DB에서 가져오는 메서드 (추가)
    public Integer getTotalPoints(int member_idx) throws Exception;

    // 포인트 내역을 DB에 삽입하는 메서드 (추가)
    public void insertPointHistory(PointVO pointVO) throws Exception;
   
    //영수증에서 적립된 포인트를 포인트로 전환
   	public static void insertReceiptPoint(PointVO pointVO) {
   		// TODO Auto-generated method stub
   	}
   	//포인트 테이블의 총 포인트도 업데이트
   	public static void updateMemberTotalPoints(int member_idx, int pointsToCredit) {
		// TODO Auto-generated method stub
		
	}
   		
   	public static int selectMemberPoints(int member_idx) {
		// 
		return 0;
	}

    
    //-관리자 모드-//
    
    // 파라미터를 SearchCriteria 객체로 변경
    public List<PointHistoryDTO> getPointHistoryAdmin(SearchCriteria cri);;

    // 파라미터를 SearchCriteria 객체로 변경
    public int getPointHistoryCount(SearchCriteria cri);

	

	


	

	

   

    //회원 테이블의 총 포인트 필드 업데이트
	//public void updateMemberTotalPoints(int member_idx, int newTotal);

    
    
    
    

}