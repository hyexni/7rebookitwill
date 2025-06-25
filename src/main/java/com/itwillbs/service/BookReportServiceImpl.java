package com.itwillbs.service;

import java.util.List;
import javax.inject.Inject;
import org.springframework.stereotype.Service;
import com.itwillbs.domain.BookReportVO;
import com.itwillbs.persistence.BookReportDAO;

@Service
public class BookReportServiceImpl implements BookReportService {

    @Inject
    private BookReportDAO brdao;

    @Override
    public void writeReport(BookReportVO vo) throws Exception {
        brdao.createReport(vo);
    }

    @Override
    public List<BookReportVO> getReportListAll() throws Exception {
        return brdao.getReportList();
    }

    @Override
    public BookReportVO getReportDetails(int report_id) throws Exception {
        return brdao.getReport(report_id);
    }

    @Override
    public void modifyReport(BookReportVO vo) throws Exception {
        brdao.updateReport(vo);
    }

    @Override
    public void removeReport(int report_id) throws Exception {
        brdao.deleteReport(report_id);
    }
}