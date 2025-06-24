package com.itwillbs.service;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.itwillbs.domain.Criteria;
import com.itwillbs.domain.BookReportVO;
import com.itwillbs.persistence.BookReportDAO;

@Service
public class BookReportServiceImpl implements BookReportService {

    @Inject
    private BookReportDAO bookreportDAO;

    // [독후감 목록 조회]
    @Override
    public List<BookReportVO> getBookReportList(Criteria criteria) {
    	System.out.println("목록조회가 완료되었습니다.");
        return bookreportDAO.getBookReportList(criteria);
    }
    
    /**
     * ✅ [추가] 특정 회원이 작성한 모든 독후감 목록 조회 구현
     */
    @Override
    public List<BookReportVO> getReportListByMember(int member_idx) throws Exception {
         return bookreportDAO.getReportListByMember(member_idx);
    }
    
    // [독후감 등록 처리]
    @Override
    public void writeBookReport(BookReportVO vo) throws Exception {
        bookreportDAO.insertBookReport(vo);
    }
    
    
 // [독후감 상세 정보 조회 ]
    @Override
    public BookReportVO getBookReportDetail(int report_id) throws Exception {
         return bookreportDAO.getBookReportDetail(report_id);
    }
    
    // [독후감 수정 처리] - DAO 호출해서 실제 독후감 내용 DB에 반영하는 메서드
    @Override
    public void updateBookReport(BookReportVO vo) throws Exception {
        // DAO 계층의 updateBookReport() 호출 (DB로 수정 요청 전달)
        bookreportDAO.updateBookReport(vo);
    }
    
   
    // 📌 독후감 삭제 처리 - VO에 report_id + member_idx 담아서 DAO로 넘김
    @Override
    public int deleteBookReport(BookReportVO vo) {
        return bookreportDAO.deleteBookReport(vo);
    }
    
    
}