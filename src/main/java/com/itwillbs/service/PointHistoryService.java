package com.itwillbs.service;

import com.itwillbs.domain.PointVO; // PointVO를 사용하도록 수정
import java.util.List;

public interface PointHistoryService {
    
    /**
     * [추가] 특정 회원의 포인트 내역을 조회하는 메서드 선언
     */
    public List<PointVO> getPointHistoryByMember(int memberIdx) throws Exception;

    /**
     * 포인트 변동 내역을 기록하는 메서드
     */
    public void addPointHistory(PointVO vo) throws Exception;

	public List<PointVO> getPointHistoryByMemberIdx(int member_idx);
}