package com.itwillbs.persistence;

import java.util.List;

import com.itwillbs.domain.BookVO;
import com.itwillbs.domain.Criteria;

/**
 * 도서 관련 DB 접근 기능 정의 인터페이스
 */
public interface BookDAO {

	// [기본 도서 목록 조회] - 검색, 카테고리, 정렬, 페이징 포함
	List<BookVO> getBookList(Criteria criteria);

	// [총 도서 수 조회] - 페이징 계산용
	int getBookCount(Criteria criteria);

}