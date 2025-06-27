package com.itwillbs.service;

import java.util.List;
import javax.inject.Inject;
import org.springframework.stereotype.Service;
import com.itwillbs.domain.BookReportVO;
import com.itwillbs.domain.SearchCriteria;
import com.itwillbs.persistence.BookReportDAO;

@Service
public class BookReportServiceImpl implements BookReportService {

    @Inject
    private BookReportDAO brdao;

    //글쓰기
    @Override
    public void writeReport(BookReportVO vo) throws Exception {
        brdao.createReport(vo);
    }
    //목록조회
    @Override
	public List<BookReportVO> getReportListAll(SearchCriteria cri) throws Exception {
		return brdao.selectReportList(cri);
	}
   
    //개수조회
    @Override
    public int countReports(SearchCriteria cri) throws Exception {
        return brdao.countReports(cri);
    }
    //상세조회
    @Override
    public BookReportVO getReportDetails(int report_id) throws Exception {
        return brdao.getReport(report_id);
    }
    //수정하기
    @Override
    public void modifyReport(BookReportVO vo) throws Exception {
        brdao.updateReport(vo);
    }
    //삭제하기
    @Override
    public void removeReport(int report_id) throws Exception {
        brdao.deleteReport(report_id);
    }

	
    
    
}