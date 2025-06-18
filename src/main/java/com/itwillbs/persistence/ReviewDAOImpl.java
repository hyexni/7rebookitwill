package com.itwillbs.persistence;

import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.itwillbs.domain.ReviewVO;
import com.itwillbs.domain.Criteria;

@Repository
public class ReviewDAOImpl implements ReviewDAO {

    @Inject
    private SqlSession sqlSession;

    // MyBatis 매퍼 네임스페이스 상수
    private static final String NAMESPACE = "com.itwillbs.mapper.ReviewMapper";

    /**
     * [리뷰 목록 조회]
     * - 특정 도서의 리뷰 리스트를 조건(Criteria)에 따라 조회
     */
    @Override
    public List<ReviewVO> getReviewList(Criteria criteria) {
        return sqlSession.selectList(NAMESPACE + ".getReviewList", criteria);
    }

    /**
     * [리뷰 개수 조회]
     * - 페이징 처리를 위한 전체 리뷰 수 조회
     */
    @Override
    public int getReviewCount(Criteria criteria) {
        return sqlSession.selectOne(NAMESPACE + ".getReviewCount", criteria);
    }

    /**
     * [리뷰 등록]
     * - 사용자가 작성한 리뷰 정보를 DB에 저장
     */
    @Override
    public void insertReview(ReviewVO vo) throws Exception {
        sqlSession.insert(NAMESPACE + ".insertReview", vo);
    }
}
