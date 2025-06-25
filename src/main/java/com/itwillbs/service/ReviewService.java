package com.itwillbs.service;

import java.util.List;

import com.itwillbs.domain.Criteria;
import com.itwillbs.domain.ReviewVO;

public interface ReviewService {

	// [리뷰 목록 조회]
	List<ReviewVO> getReviewList(Criteria criteria);

	// [리뷰 개수 조회]
	int getReviewCount(Criteria criteria);

	// [리뷰 등록 처리]
	void writeReview(ReviewVO vo) throws Exception;

	// [리뷰 수정 처리] 메서드 정의 - 리뷰 수정 로직을 서비스 계층에 선언만 해둠
	void updateReview(ReviewVO vo) throws Exception;

	// [리뷰 단건 조회 - 리뷰 수정 폼에 기존 데이터 출력용]
	ReviewVO getReviewById(int review_id);

	// 리뷰 삭제
	int deleteReview(ReviewVO vo);

	// 평균 별점
	public Double getAverageRating(int book_id);

}