package com.itwillbs.service;

import java.util.List;

import com.itwillbs.domain.BookVO;
import com.itwillbs.domain.Criteria;

public interface BookService {
	// Criteria 기반 도서 목록 조회
	List<BookVO> getBookList(Criteria criteria);

	// Criteria 기반 도서 총 개수 조회 (페이징용)
	int getBookCount(Criteria criteria);

	// 도서 상세 정보 조회 기능 정의 - book_id 기준 단건 조회
	BookVO getBookDetail(int bookId);
	
    //  재고 상태 변경
    void updateBookStatus(int book_id, String stock_status);

    //  카테고리 변경
    void updateBookCategory(int book_id, int category_id);
    
    // 도서 등록
    void insertBook(BookVO bookVO);
    
    // 도서 수정
    void updateBook(BookVO bookVO) throws Exception;
    
    // 도서 삭제
    void deleteBook(int book_id);

}

	
