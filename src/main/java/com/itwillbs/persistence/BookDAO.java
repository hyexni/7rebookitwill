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

	// [도서 상세 조회] - 도서 ID 기준
	BookVO getBookDetail(int bookId);
	

    /**
     * [신규] 책 제목의 일부(키워드)를 포함하는 모든 도서 목록을 조회합니다.
     * @param title 검색할 책 제목 키워드
     * @return 검색 조건에 맞는 도서 목록 (List<BookVO>)
     */
    // [수정] static 키워드와 메서드 몸통({ ... })을 제거하고 세미콜론(;)으로 마무리합니다.
    public List<BookVO> findByTitleContaining(String title);
    
}