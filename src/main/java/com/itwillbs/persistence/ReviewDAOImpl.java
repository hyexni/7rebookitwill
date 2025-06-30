package com.itwillbs.persistence;

import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.itwillbs.domain.Criteria;
import com.itwillbs.domain.ReviewVO;

@Repository
public class ReviewDAOImpl implements ReviewDAO {

	@Inject
	private SqlSession sqlSession;

	// MyBatis 매퍼 네임스페이스 상수
	private static final String NAMESPACE = "com.itwillbs.mapper.ReviewMapper";

	/**
	 * [리뷰 목록 조회] - 특정 도서의 리뷰 리스트를 조건(Criteria)에 따라 조회
	 */
	@Override
	public List<ReviewVO> getReviewList(Criteria criteria) {
		return sqlSession.selectList(NAMESPACE + ".getReviewList", criteria);
	}

	/**
	 * [리뷰 개수 조회] - 페이징 처리를 위한 전체 리뷰 수 조회
	 */
	@Override
	public int getReviewCount(Criteria criteria) {
		return sqlSession.selectOne(NAMESPACE + ".getReviewCount", criteria);
	}

	/**
	 * [리뷰 등록] - 사용자가 작성한 리뷰 정보를 DB에 저장
	 */
	@Override
	public void insertReview(ReviewVO vo) throws Exception {
		sqlSession.insert(NAMESPACE + ".insertReview", vo);
	}

	// [리뷰 수정 처리] - SqlSession을 이용해서 실제 SQL 실행
	@Override
	public void updateReview(ReviewVO vo) throws Exception {
		// Mapper에 정의된 updateReview SQL문을 실행하고, ReviewVO 데이터 전달
		sqlSession.update(NAMESPACE + ".updateReview", vo);
	}

	// [리뷰 단건 조회 - 리뷰 수정 페이지에서 기존 내용 불러오기]
	@Override
	public ReviewVO getReviewById(int review_id) {
		return sqlSession.selectOne(NAMESPACE + ".getReviewById", review_id);
	}

	// 리뷰 삭제
	@Override
	public int deleteReview(ReviewVO vo) {
		return sqlSession.delete(NAMESPACE + ".deleteReview", vo);
	}

	// 평균 별점
	@Override
	public Double getAverageRating(int book_id) {
		return sqlSession.selectOne(NAMESPACE + "getAverageRating", book_id);
	}
	
	   // ✅ [회원별 리뷰 목록 조회]
    @Override
    public List<ReviewVO> getReviewsByMember(int member_idx) {
        return sqlSession.selectList(NAMESPACE + ".getReviewsByMember", member_idx);
    }
    
    // [회원별 리뷰 목록 페이징 처리]
    @Override
    public List<ReviewVO> getReviewsByMemberPaging(Criteria cri) {
        return sqlSession.selectList(NAMESPACE + ".getReviewsByMemberPaging", cri);
    }

    @Override
    public int getReviewCountByMember(int member_idx) {
        return sqlSession.selectOne(NAMESPACE + ".getReviewCountByMember", member_idx);
    }
}
