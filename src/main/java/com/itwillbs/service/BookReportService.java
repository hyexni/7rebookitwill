package com.itwillbs.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.itwillbs.domain.BookReportVO;
import com.itwillbs.domain.ResponseVO;
import com.itwillbs.domain.ReviewVO;

@Service
public interface BookReportService {
	
	// 독후감 글쓰기
	public void writeBookReport(BookReportVO vo) throws Exception;
	
	// 독후감 목록
	public List<BookReportVO> getBookReportList();

	
	//List<BookReportVO> getBookReportList(int member_idx);
	
	// 상세 조회
	BookReportVO getBookReport(int report_id);
	
	// ✅ 답변 조회
    ResponseVO getResponse(int report_id);
    
    // 수정
    void updateBookReport(BookReportVO vo) throws Exception;

    // 삭제
    void deleteBookReport(int report_id) throws Exception;

	

 
	



	


}
