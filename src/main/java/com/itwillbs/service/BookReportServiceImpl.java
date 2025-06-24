package com.itwillbs.service;

import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.itwillbs.domain.BookReportVO;
import com.itwillbs.domain.ResponseVO;
import com.itwillbs.persistence.BookReportDAO;

@Service
public class BookReportServiceImpl implements BookReportService {
	
	// mylog
	private static final Logger logger = LoggerFactory.getLogger(BookReportServiceImpl.class);
	
	// BookReportDAO 객체 필요 => 객체를 주입받아서 사용
	@Inject
	private BookReportDAO iDAO;

	// 독후감 글쓰기
	@Override
	public void insertBookReport(BookReportVO vo) throws Exception {
		iDAO.insertBookReport(vo);
	}

		
	//독후감 목록
	@Override
	public List<BookReportVO> getBookReportList() {
		return null;
	}

	
	// 상세 조회
	@Override
	public BookReportVO getBookReport(int report_id) {
	    return iDAO.getBookReport(report_id);
	}
		
		
	// 수정
	@Override
	public void updateBookReport(BookReportVO vo) throws Exception {
		iDAO.updateBookReport(vo);
	}

	// 삭제
	@Override
	public void deleteBookReport(int report_id) throws Exception {
	    iDAO.deleteBookReport(report_id);
	}


	
	
	
	
	

	
}
