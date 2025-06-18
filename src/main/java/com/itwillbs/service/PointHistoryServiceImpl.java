package com.itwillbs.service;

import com.itwillbs.domain.PointVO;
// [임시 주석 처리] MemberDAO가 준비될 때까지 import하지 않습니다.
// import com.itwillbs.persistence.MemberDAO; 
import com.itwillbs.persistence.PointHistoryDAO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.inject.Inject;
import java.util.List;

@Service
public class PointHistoryServiceImpl implements PointHistoryService {
    
    private static final Logger logger = LoggerFactory.getLogger(PointHistoryServiceImpl.class);

    // [수정] 변수명은 소문자 카멜 케이스로 변경 (PDao -> pdao)
    @Inject
    private PointHistoryDAO pdao;
    
    // [임시 주석 처리] MemberDAO가 준비될 때까지 주입받지 않습니다.
    // @Inject
    // private MemberDAO mdao; 

    /**
     * 특정 회원의 포인트 내역을 조회하는 메서드
     */
    @Override
    public List<PointVO> getPointHistoryByMember(int memberIdx) throws Exception {
        logger.info("사용자 {}의 포인트 내역 조회", memberIdx);
        return pdao.selectPointHistoryByMember(memberIdx);
    }
    
    /**
     * [수정] 포인트 변동 내역을 기록하는 메서드 (메서드명 변경: Point -> addPointHistory)
     */
    @Override
    @Transactional
    public void addPointHistory(PointVO vo) throws Exception {
        // 1. 포인트 변동 내역을 point_history 테이블에 기록 (이 기능은 정상 동작)
        pdao.insertPointHistory(vo);
        
        // [임시 주석 처리] MemberDAO가 없으므로, 회원의 총 포인트를 업데이트하는 로직은 잠시 제외합니다.
        // mdao.updateMemberPoint(vo.getMemberIdx(), vo.getPointChange());
        
        // [수정] 로그 메시지도 현재 상황에 맞게 변경
        logger.info("{}번 회원 포인트 {} 변동 내역 기록 완료", vo.getMember_idx(), vo.getChange_amount());
    }

	@Override
	public List<PointVO> getPointHistoryByMemberIdx(int member_idx) {
		// TODO Auto-generated method stub
		return null;
	}
    
    
}