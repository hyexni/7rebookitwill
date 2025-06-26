package com.itwillbs.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Param;

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
   	public void insertReceiptPoint(PointVO pointVO) throws Exception;
   	
   	//멤버 테이블의 총 토탈포인트 업데이트   
    public int updateMemberTotalPoints(int memeber_idx) throws Exception;  
    
       	//회원 포인트 가져오기
   	public int selectMemberPoints(int member_idx) throws Exception;
    
    //-관리자 모드-//
    
    // 파라미터를 SearchCriteria 객체로 변경
    public List<PointHistoryDTO> getPointHistoryAdmin(SearchCriteria cri);;

    // 파라미터를 SearchCriteria 객체로 변경
    public int getPointHistoryCount(SearchCriteria cri);
	



}