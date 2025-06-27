package com.itwillbs.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.itwillbs.domain.BookVO;

public interface MainDAO {

	
	/**
     * 메인 페이지에 표시될 도서 목록을 데이터베이스에서 가져옵니다.
     * @return BookVO 객체를 담고 있는 List
     * @throws Exception
     */
    public List<BookVO> getBookList() throws Exception;
    

    /**
     * 신간 도서 목록을 조회합니다.
     * @param limit 조회할 개수
     * @return 신간 도서 리스트
     */
    public List<BookVO> selectNewBookList(@Param("limit") int limit);
    
    /**
     * 베스트셀러 목록을 조회합니다.
     * @param limit 조회할 개수
     * @return 베스트셀러 리스트
     */
    public List<BookVO> selectBestSellerList(@Param("limit") int limit);
	
}
