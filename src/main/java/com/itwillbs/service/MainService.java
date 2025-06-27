package com.itwillbs.service;

import java.util.List;
import com.itwillbs.domain.BookVO;

public interface MainService {
    
    /**
     * 메인 페이지의 도서 목록을 가져오는 비즈니스 로직을 수행합니다.
     * @return 도서 정보(BookVO) 리스트
     * @throws Exception
     */
    public List<BookVO> getBookList() throws Exception;
    
    
    /**
     * 화면에 표시할 신간 도서 목록을 가져옵니다.
     * @param count 가져올 도서의 수
     * @return 신간 도서 리스트
     */
    public List<BookVO> getNewBookList(int count);
    
    /**
     * 화면에 표시할 베스트셀러 목록을 가져옵니다.
     * @param count 가져올 도서의 수
     * @return 베스트셀러 리스트
     */
    public List<BookVO> getBestSellerList(int count);
    
    
    
    // 검색용 메서드
    public List<BookVO> searchBooksByKeyword(String keyword) throws Exception;

    // 추천 도서 조회용 메서드
    public List<BookVO> getRecommendedBooks(BookVO vo) throws Exception;

	

}