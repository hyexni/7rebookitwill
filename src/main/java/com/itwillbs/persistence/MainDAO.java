package com.itwillbs.persistence;

import java.util.List;

import com.itwillbs.domain.BookVO;

public interface MainDAO {

	
	/**
     * 메인 페이지에 표시될 도서 목록을 데이터베이스에서 가져옵니다.
     * @return BookVO 객체를 담고 있는 List
     * @throws Exception
     */
    public List<BookVO> getBookList() throws Exception;
	
}
