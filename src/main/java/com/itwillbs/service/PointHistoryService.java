package com.itwillbs.service;

import com.itwillbs.domain.PointVO;
import java.util.List;

public interface PointHistoryService {
    // 특정 회원의 포인트 내역을 가져오는 메서드
    public List<PointVO> getPointHistory(int memberIdx) throws Exception;

    // 회원의 현재 총 포인트를 가져오는 메서드 (추가)
    public Integer getTotalPoints(int memberIdx) throws Exception;

    // 포인트 적립 처리 메서드 (추가)
    public void earnPoint(PointVO pointVO) throws Exception;

    // 포인트 사용 처리 메서드 (추가)
    public void usePoint(PointVO pointVO) throws Exception;
}