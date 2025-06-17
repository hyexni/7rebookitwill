package com.itwillbs.service;

import java.util.List;
import com.itwillbs.domain.BookVO;

public interface RecommendService {
	
	// 회원 번호(member_idx)를 기반으로 추천 도서 목록 조회
	public List<BookVO> getRecommendBooks(int member_idx) throws Exception;
	
	// 찜 기반 도서 추천
	public List<BookVO> getRecommendWishList(int member_idx);
	
	// 추천 정렬 기능
	public List<BookVO> getRecommendBooks(String sort);
	
	// 추천 정렬 출력 기능
	public List<BookVO> getRecommendList(String sort);
	
	// 새로 추가
    List<BookVO> getRecommendBooksSorted(int memberIdx, String sort) throws Exception;

    
    
    // 통합페이지에서도 정렬 제대로 되게 하려고 새로 만드는 중 (6/16)
    List<BookVO> findRecommendedBooksSorted(int member_idx, String sort) throws Exception;

    // 구매 기반 추천 기본 메서드
    List<BookVO> findRecommendedBooks(int member_idx) throws Exception;

    // 찜 기반 정렬 메서드
	public List<BookVO> findRecommendedBooksByWishSorted(Integer member_idx, String sort) throws Exception;
}