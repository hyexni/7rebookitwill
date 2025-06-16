package com.itwillbs.service;

import java.util.List;

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

	// Criteria 기반 탭별 도서 목록 조회 (추천/베스트셀러/신간 등)
	@Override
	public List<BookVO> getBookListByTab(Criteria criteria) {
		logger.info("BookServiceImpl: getBookListByTab() 호출");
		return bookDAO.getBookListByTab(criteria);
	}

}