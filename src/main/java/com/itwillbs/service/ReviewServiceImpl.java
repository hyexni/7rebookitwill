package com.itwillbs.service;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.itwillbs.domain.Criteria;
import com.itwillbs.domain.ReviewVO;
import com.itwillbs.persistence.ReviewDAO;

@Service
public class ReviewServiceImpl implements ReviewService {

	@Inject
	private ReviewDAO reviewDAO;

	// [리뷰 목록 조회]
	@Override
	public List<ReviewVO> getReviewList(Criteria criteria) {
		return reviewDAO.getReviewList(criteria);
	}

	// [리뷰 개수 조회]
	@Override
	public int getReviewCount(Criteria criteria) {
		return reviewDAO.getReviewCount(criteria);
	}

	// [리뷰 등록 처리]
	@Override
	public void writeReview(ReviewVO vo) throws Exception {
		reviewDAO.insertReview(vo);
	}

	// [리뷰 수정 처리] - DAO 호출해서 실제 리뷰 내용 DB에 반영하는 메서드
	@Override
	public void updateReview(ReviewVO vo) throws Exception {
		// DAO 계층의 updateReview() 호출 (DB로 수정 요청 전달)
		reviewDAO.updateReview(vo);
	}

	// [리뷰 단건 조회 - 리뷰 수정 폼에 기존 데이터 출력용]
	@Override
	public ReviewVO getReviewById(int review_id) {
		return reviewDAO.getReviewById(review_id);
	}

	// 📌 리뷰 삭제 처리 - VO에 review_id + member_idx 담아서 DAO로 넘김
	@Override
	public int deleteReview(ReviewVO vo) {
		return reviewDAO.deleteReview(vo);
	}

	// 평균 별점
	@Override
	public Double getAverageRating(int book_id) {
		return reviewDAO.getAverageRating(book_id);
	}
	
	// 회원별 리뷰 목록 조회 
	@Override
	public List<ReviewVO> getReviewsByMember(int member_idx) {
	    return reviewDAO.getReviewsByMember(member_idx);
	}
	
	// 회원별 리뷰 목록 페이징 처리 
	@Override
	public List<ReviewVO> getReviewsByMemberPaging(Criteria cri) {
	    return reviewDAO.getReviewsByMemberPaging(cri);
	}

	@Override
	public int getReviewCountByMember(int member_idx) {
	    return reviewDAO.getReviewCountByMember(member_idx);
	}
}