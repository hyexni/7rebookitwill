package com.itwillbs.persistence;

import java.util.List;

import com.itwillbs.domain.Criteria;
import com.itwillbs.domain.ReviewVO;

public interface ReviewDAO {
	List<ReviewVO> getReviewList(Criteria criteria);

	int getReviewCount(Criteria criteria);

	// [리뷰 등록]
	void insertReview(ReviewVO vo) throws Exception;

	// [리뷰 수정 처리] - DB에 리뷰 내용을 수정하는 메서드 선언
	void updateReview(ReviewVO vo) throws Exception;

	// [리뷰 단건 조회 - 수정폼에서 사용할 리뷰 1건 조회]
	ReviewVO getReviewById(int review_id);

	// 리뷰 삭제
	int deleteReview(ReviewVO vo);

	// 평균 별점
	public Double getAverageRating(int book_id);
	
	// [회원별 리뷰 목록 조회]
	List<ReviewVO> getReviewsByMember(int member_idx);
	
	// [회원별 리뷰 목록 페이징 처리]
	List<ReviewVO> getReviewsByMemberPaging(Criteria cri);
	int getReviewCountByMember(int member_idx);

}