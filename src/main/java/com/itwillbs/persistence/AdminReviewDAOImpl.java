package com.itwillbs.persistence;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.itwillbs.domain.ReviewVO;

@Repository
public class AdminReviewDAOImpl implements AdminReviewDAO {

    private static final String NAMESPACE = "com.itwillbs.persistence.AdminReviewDAO";

    @Inject
    private SqlSession sqlSession;

    @Override
    public List<ReviewVO> getReviewList(int startRow, int pageSize, String keyword) {
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("startRow", startRow);
        paramMap.put("pageSize", pageSize);
        paramMap.put("keyword", keyword);
        return sqlSession.selectList(NAMESPACE + ".getReviewList", paramMap);
    }


    @Override
    public int getReviewCount(String keyword) {
        return sqlSession.selectOne(NAMESPACE + "getReviewCount", keyword);
    }

    @Override
    public ReviewVO getReviewById(int review_id) {
        return sqlSession.selectOne(NAMESPACE + "getReviewById", review_id);
    }

    @Override
    public void hideReview(int review_id) {
        sqlSession.update(NAMESPACE + "hideReview", review_id);
    }

    @Override
    public void deleteReview(int review_id) {
        sqlSession.delete(NAMESPACE + "deleteReview", review_id);
    }
}
