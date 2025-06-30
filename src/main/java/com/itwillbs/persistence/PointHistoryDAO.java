package com.itwillbs.persistence;

import java.util.List;
import java.util.Map;

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
	
    // [차트용] 월간 사유별 적립 통계
    List<Map<String, Object>> getMonthlyAccrualStats();

    // [차트용] 월간 적립/사용 통계
    List<Map<String, Object>> getMonthlyUsageStats();
    
 // ==============================================================================
    // ================ 관리자 포인트 지급 기능에 필요한 메소드 추가 =======================
    // ==============================================================================
    /**
     * [관리자용] 계산된 최종 포인트를 member 테이블에 직접 업데이트합니다.
     * 서비스단에서 '기존 포인트 + 지급 포인트' 계산을 마친 후 호출됩니다.
     * @param pointVO member_idx와 최종 포인트인 point_amount를 담고 있어야 합니다.
     * @throws Exception
     */
    public void updateMemberTotalPointByAdmin(PointVO pointVO) throws Exception;


}