package com.itwillbs.service;

import java.util.List;
import com.itwillbs.domain.BookReportVO;
import com.itwillbs.domain.SearchCriteria;

public interface BookReportService {

    // 독후감 등록
    public void writeReport(BookReportVO vo) throws Exception;
    
    // 특정 독후감 상세 조회
    public BookReportVO getReportDetails(int report_id) throws Exception;
    
    // 독후감 수정
    public void modifyReport(BookReportVO vo) throws Exception;
    
    // 독후감 삭제
    public void removeReport(int report_id) throws Exception;
    
    
 // 독후감 목록 조회
    
    /**
     * 목록 조회 (페이징, 검색, 정렬 기능 추가)
     * @param cri 페이징, 검색, 정렬 정보
     * @return 조건에 맞는 독후감 목록
     */
    List<BookReportVO> getReportListAll(SearchCriteria cri) throws Exception;

    /**
     * 총 글 개수 조회 (검색 조건 포함)
     * @param cri 검색 정보
     * @return 조건에 맞는 총 글의 개수
     */
    int countReports(SearchCriteria cri) throws Exception;
}