package com.itwillbs.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.itwillbs.domain.BookVO;
import com.itwillbs.domain.Criteria;
import com.itwillbs.persistence.BookDAO;

@Service
public class BookServiceImpl implements BookService {

	// 로거 선언
	private static final Logger logger = LoggerFactory.getLogger(BookServiceImpl.class);

	@Inject
	private BookDAO bookDAO;

	// Criteria 기반 도서 목록 조회
	@Override
	public List<BookVO> getBookList(Criteria criteria) {
		logger.info("BookServiceImpl: getBookList() 호출");
		return bookDAO.getBookList(criteria);
	}

	// Criteria 기반 도서 총 개수 조회
	@Override
	public int getBookCount(Criteria criteria) {
		logger.info("BookServiceImpl: getBookCount() 호출");
		return bookDAO.getBookCount(criteria);
	}
	
	// 도서 상세 정보 조회 기능 구현
	@Override
	public BookVO getBookDetail(int bookId) {
		return bookDAO.getBookDetail(bookId);
		
	}
	
	// ✅ 도서 상태 변경
    @Override
    public void updateBookStatus(int book_id, String stock_status) {
        Map<String, Object> map = new HashMap<>();
        map.put("book_id", book_id);
        map.put("stock_status", stock_status);

        bookDAO.updateBookStatus(map);
    }
	// ✅ 카테고리 변경
    public void updateBookCategory(int book_id, int category_id) {
        Map<String, Object> map = new HashMap<>();
        map.put("book_id", book_id);
        map.put("category_id", category_id);

        bookDAO.updateBookCategory(map);
    }
    

    @Override
    public void insertBook(BookVO bookVO) {
    	logger.debug("📘 도서 등록 - 서비스단 실행");
        bookDAO.insertBook(bookVO);
    }
    
    // 도서 수정
    @Override
    public void updateBook(BookVO bookVO) throws Exception {
        logger.debug("📘 BookService - updateBook 호출: {}", bookVO);
        bookDAO.updateBook(bookVO);
    }
    
    // 도서삭제
    @Override
    public void deleteBook(int book_id) {
        bookDAO.deleteBook(book_id);
    }
    

		
}
