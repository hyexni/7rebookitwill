package com.itwillbs.persistence;

import java.util.List;

import com.itwillbs.domain.BookReportVO;
import com.itwillbs.domain.ResponseVO;

public interface BookReportDAO {
	
	// 독후감 글쓰기
	public void insertBookReport(BookReportVO vo) throws Exception;
	
	// 독후감 목록
	 List<BookReportVO> getBookReportList(int member_idx);
	 
	// 상세 조회
	 BookReportVO getBookReport(int report_id);
	 
	 // 답변
	 ResponseVO getResponse(int Report_id);
	 
	 // 수정
	 void updateBookReport(BookReportVO vo) throws Exception;
	 
	 // 삭제
	 void deleteBookReport(int Report_id) throws Exception;




}
