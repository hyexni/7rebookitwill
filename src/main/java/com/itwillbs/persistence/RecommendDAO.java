package com.itwillbs.persistence;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.itwillbs.domain.BookVO;

public interface RecommendDAO {
	
	// 회원 번호(member_idx)를 기반으로 추천 도서 목록을 반환
    public List<BookVO> findRecommendedBooks(int member_idx) throws Exception;
    
    // 찜 도서 기반 추천
    public List<BookVO> getRecommendByWishList(int member_idx);
    
    // 추천 정렬 기능
    public List<BookVO> getRecommendBooksSorted(String sort);
    public List<BookVO> getRecommendList(String sort);
   
	// 새로 추가함!!!
    // 구매 기반 정렬
    public List<BookVO> findRecommendedBooksSorted(int member_idx, String sort) throws Exception;
    
    // 찜 기반 정렬
    public List<BookVO> findRecommendedBooksByWishSorted(int member_idx, String sort) throws Exception;
    
    

}
