package com.itwillbs.service;

import java.util.List;

import com.itwillbs.domain.BookReportVO;

public interface BookReportService {

	// 독후감 글쓰기
	public void insertBookReport(BookReportVO vo) throws Exception;

	// 독후감 목록
	public List<BookReportVO> getBookReportList();

	// List<BookReportVO> getBookReportList(int member_idx);

	// 독후감 상세페이지
	public BookReportVO getBookReport(int report_id);

	// 수정
	void updateBookReport(BookReportVO vo) throws Exception;

	// 삭제
	void deleteBookReport(int report_id) throws Exception;

}
