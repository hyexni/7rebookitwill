package com.itwillbs.persistence;

import java.util.List;
import com.itwillbs.domain.BookReportVO;

public interface BookReportDAO {

    // 독후감 등록
    public void createReport(BookReportVO vo) throws Exception;
    
    // 독후감 목록 조회
    public List<BookReportVO> getReportList() throws Exception;
    
    // 특정 독후감 상세 조회
    public BookReportVO getReport(int report_id) throws Exception;
    
    // 독후감 수정
    public Integer updateReport(BookReportVO vo) throws Exception;
    
    // 독후감 삭제
    public Integer deleteReport(int report_id) throws Exception;
    
}