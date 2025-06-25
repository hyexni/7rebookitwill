package com.itwillbs.service;

import java.util.List;

import com.itwillbs.domain.Criteria;
import com.itwillbs.domain.InquiryVO;
import com.itwillbs.domain.BookReportVO;

public interface BookReportService {

    // [독후감 목록 조회]
    List<BookReportVO> getBookReportList(Criteria criteria);
    
    // ✅ 특정 회원이 작성한 모든 독후감 목록 조회
    public List<BookReportVO> getReportListByMember(int member_idx) throws Exception;


   // [독후감 등록 처리]
    void insertBookReport(BookReportVO vo) throws Exception;
    
    
    // ✅ 독후감 상세 정보 조회
    public BookReportVO getBookReportDetail(int report_id) throws Exception;

    
    // [독후감 수정 처리] 메서드 정의 - 독후감 수정 로직을 서비스 계층에 선언만 해둠
    void updateBookReport(BookReportVO vo) throws Exception;
  
    // 독후감 삭제
    int deleteBookReport(BookReportVO vo);
