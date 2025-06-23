package com.itwillbs.persistence;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.itwillbs.domain.PointVO;
import com.itwillbs.domain.SearchCriteria;
import com.itwillbs.dto.PointHistoryDTO;

@Repository
public class PointHistoryDAOImpl implements PointHistoryDAO {

    @Inject
    private SqlSession sqlSession;

    private static final Logger logger = LoggerFactory.getLogger(PointHistoryDAOImpl.class);
    private static final String NAMESPACE = "com.itwillbs.mapper.PointHistoryMapper";

    @Override
    public List<PointVO> getPointHistory(int member_idx) throws Exception {
    	
        return sqlSession.selectList(NAMESPACE + ".getPointHistory", member_idx);
//        return null;
    }

    @Override
    public Integer getTotalPoints(int memberIdx) throws Exception {
        // 모든 포인트 내역의 change_amount를 합산하여 총 포인트를 계산합니다.
        // 또는 member 테이블에 total_point 컬럼이 있다면 해당 컬럼을 조회합니다.
        // 여기서는 내역 테이블에서 합산하는 방식을 가정합니다.
        return sqlSession.selectOne(NAMESPACE + ".getTotalPoints", memberIdx);
    }

    @Override
    public void insertPointHistory(PointVO pointVO) throws Exception {
        sqlSession.insert(NAMESPACE + ".insertPointHistory", pointVO);
    }
    
   @Override
	public void insertReceiptPoint(PointVO pointVO) throws Exception {
		sqlSession.insert(NAMESPACE + ".insertReceiptPoint", pointVO);
		
	}

	@Override
	public void updateMemberTotalPoints2(PointVO pointVO) throws Exception {
//		Map<String, Integer> pointmap = new HashMap<String, Integer>();
//		pointmap.put("member_idx", member_idx);
//		pointmap.put("pointsToCredit", pointsToCredit);
		logger.info("++++++++++++++++++++++++++++++++++++");
//		logger.info("pointmap"+pointmap);
//		sqlSession.update(NAMESPACE + ".updateMemberTotalPoints",pointmap);
		
	}
		
		
	@Override
	public int selectMemberPoints(int member_idx) throws Exception {
		return sqlSession.selectOne(NAMESPACE + ".selectMemberPoints", member_idx);
	}
	
	

	//관리자모드
    /**
     * 포인트 내역 목록을 조회합니다.
     */
    @Override
    public List<PointHistoryDTO> getPointHistoryAdmin(SearchCriteria cri) {
        // sqlSession 객체를 사용하여 Mapper의 SQL을 직접 호출합니다.
        // 첫 번째 파라미터: "namespace.id"
        // 두 번째 파라미터: SQL에 전달할 데이터
        return sqlSession.selectList(NAMESPACE + ".getPointHistory", cri);
    }



	/**
     * 포인트 내역의 총 개수를 조회합니다.
     */
    @Override
    public int getPointHistoryCount(SearchCriteria cri) {
        // 단일 행을 조회할 때는 selectOne 메서드를 사용합니다.
        return sqlSession.selectOne(NAMESPACE + ".getPointHistoryCount", cri);
    }
}