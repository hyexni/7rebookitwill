package com.itwillbs.persistence;

import com.itwillbs.domain.PointVO;
import java.util.List;

public interface PointHistoryDAO {

    /**
     * [추가] 특정 회원의 포인트 내역을 조회하는 메서드 선언
     */
    public List<PointVO> selectPointHistoryByMember(int memberIdx) throws Exception;
    
    /**
     * 포인트 변동 내역을 기록하는 메서드
     */
    public void insertPointHistory(PointVO vo) throws Exception;
}