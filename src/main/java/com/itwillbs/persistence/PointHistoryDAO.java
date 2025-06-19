package com.itwillbs.persistence;

import java.util.List;

import com.itwillbs.domain.PointVO;
import com.itwillbs.domain.SearchCriteria;
import com.itwillbs.dto.PointHistoryDTO;

public interface PointHistoryDAO {
	
	//-사용자 모드-//
	
    // 특정 회원의 포인트 내역을 DB에서 가져오는 메서드
    public List<PointVO> getPointHistory(int memberIdx) throws Exception;

    // 회원의 현재 총 포인트를 DB에서 가져오는 메서드 (추가)
    public Integer getTotalPoints(int memberIdx) throws Exception;

    // 포인트 내역을 DB에 삽입하는 메서드 (추가)
    public void insertPointHistory(PointVO pointVO) throws Exception;

    // (선택 사항) 회원 테이블의 총 포인트를 업데이트하는 메서드 (필요시 추가)
    // public void updateMemberTotalPoints(@Param("memberIdx") int memberIdx, @Param("totalPoints") int totalPoints) throws Exception;

    //-관리자 모드-//
    
    // 파라미터를 SearchCriteria 객체로 변경
    public List<PointHistoryDTO> getPointHistoryAdmin(SearchCriteria cri);;

    // 파라미터를 SearchCriteria 객체로 변경
    public int getPointHistoryCount(SearchCriteria cri);

	
    
    
    
    

}