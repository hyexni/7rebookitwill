package com.itwillbs.service;

import java.util.List;
import com.itwillbs.domain.BookReportVO;

public interface BookReportService {

    // 독후감 등록
    public void writeReport(BookReportVO vo) throws Exception;
    
    // 독후감 목록 조회
    public List<BookReportVO> getReportListAll() throws Exception;
    
    // 특정 독후감 상세 조회
    public BookReportVO getReportDetails(int report_id) throws Exception;
    
    // 독후감 수정
    public void modifyReport(BookReportVO vo) throws Exception;
    
    // 독후감 삭제
    public void removeReport(int report_id) throws Exception;
}