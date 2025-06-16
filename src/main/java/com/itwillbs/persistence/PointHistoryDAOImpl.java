package com.itwillbs.persistence;

import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.itwillbs.domain.PointVO;

// ... imports ...

@Repository
public class PointHistoryDAOImpl implements PointHistoryDAO {
    
    @Inject
    private SqlSession sqlSession;
    private static final String NAMESPACE = "com.itwillbs.mapper.PointMapper.";

    /**
     * [확인] 인터페이스에 선언된 메서드를 여기서 실제로 구현합니다.
     */
    @Override
    public List<PointVO> selectPointHistoryByMember(int memberIdx) throws Exception {
        return sqlSession.selectList(NAMESPACE + "selectPointHistoryByMember", memberIdx);
    }
    
    @Override
    public void insertPointHistory(PointVO vo) throws Exception {
        sqlSession.insert(NAMESPACE + "insertPointHistory", vo);
    }
}