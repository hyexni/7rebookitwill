package com.itwillbs.persistence;

import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.itwillbs.domain.PointVO;

@Repository
public class PointHistoryDAOImpl implements PointHistoryDAO {

    @Inject
    private SqlSession sqlSession;

    private static final Logger logger = LoggerFactory.getLogger(PointHistoryDAOImpl.class);
    private static final String NAMESPACE = "com.itwillbs.mapper.PointHistoryMapper";

    @Override
    public List<PointVO> getPointHistory(int memberIdx) throws Exception {
    	System.out.println("2222222222222222222222222");
        return sqlSession.selectList(NAMESPACE + ".getPointHistory", memberIdx);
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

    // (선택 사항)
    // @Override
    // public void updateMemberTotalPoints(int memberIdx, int totalPoints) throws Exception {
    //    sqlSession.update(NAMESPACE + ".updateMemberTotalPoints", new HashMap<String, Object>() {{
    //        put("memberIdx", memberIdx);
    //        put("totalPoints", totalPoints);
    //    }});
    // }
}