package com.itwillbs.service;

import java.util.List;

import com.itwillbs.domain.BookVO;
import com.itwillbs.domain.Criteria;

public interface BookService {
	// Criteria 기반 도서 목록 조회
	List<BookVO> getBookList(Criteria criteria);

	// Criteria 기반 도서 총 개수 조회 (페이징용)
	int getBookCount(Criteria criteria);

	// 탭별 도서 목록 조회 (추천/베스트셀러/신간 등)
	List<BookVO> getBookListByTab(Criteria criteria);
}
