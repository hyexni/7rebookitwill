package com.itwillbs.persistence;

import java.util.List;
import com.itwillbs.domain.BookReportVO;
import com.itwillbs.domain.Criteria;

public interface BookReportDAO {
	
	//[독후감 목록]
    List<BookReportVO> getBookReportList(Criteria criteria);
    
    // ✅ 특정 회원이 작성한 모든 독후감 목록 조회
    public List<BookReportVO> getReportListByMember(int member_idx) throws Exception;

    
    // [독후감 등록]
    void insertBookReport(BookReportVO vo) throws Exception;
    
    // ✅ 독후감 상세 정보 조회
    public BookReportVO getBookReportDetail(int report_id) throws Exception;
    
    // [독후감 수정 처리] - DB에 독후감 내용을 수정하는 메서드 선언
    void updateBookReport(BookReportVO vo) throws Exception;
    
    // 독후감 삭제
    int deleteBookReport(BookReportVO vo);
}