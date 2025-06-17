package com.itwillbs.persistence;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.itwillbs.domain.BookStatsDTO;
import com.itwillbs.domain.BookVO;

public interface RecommendDAO {
	
	
	// 회원 번호(member_idx)를 기반으로 추천 도서 목록을 반환
    public List<BookVO> findRecommendedBooks(int member_idx) throws Exception;
    
    // 찜 도서 기반 추천
    public List<BookVO> getRecommendByWishList(int member_idx);
    
    // 추천 정렬 기능
    public List<BookVO> getRecommendBooksSorted(String sort);
    public List<BookVO> getRecommendList(String sort);
   
    // 새로추가함 (6/17 -- 파일 싹 다 합치니 기존 매퍼 NAMESPACE로 동작 x)
    // 구매 기반 정렬
    public List<BookVO> findRecommendedBooksSorted(
    		@Param("member_idx") int member_idx,
    		@Param("sort") String sort
		) throws Exception;
    
    // 찜 기반 정렬
    public List<BookVO> findRecommendedBooksByWishSorted(
    		@Param("member_idx") int member_idx,
    		@Param("sort")	String sort
		) throws Exception;
    
    // 구매 기반 + 정렬 (Map 파라미터)
    List<BookStatsDTO> findRecommendedBooksByPurchaseSorted(Map<String,Object> params);

    // 찜 기반 + 정렬 (Map 파라미터)
    List<BookStatsDTO> findRecommendedBooksByWishSorted    (Map<String,Object> params);
    

}
