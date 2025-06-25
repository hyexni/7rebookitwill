package com.itwillbs.persistence;

import java.util.List;
import javax.inject.Inject;
import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;
import com.itwillbs.domain.BookReportVO;

@Repository
public class BookReportDAOImpl implements BookReportDAO {

    @Inject
    private SqlSession sqlSession;
    
    private static final String NAMESPACE = "com.itwillbs.persistence.BookReportDAO";

    @Override
    public void createReport(BookReportVO vo) throws Exception {
        sqlSession.insert(NAMESPACE + ".createReport", vo);
    }

    @Override
    public List<BookReportVO> getReportList() throws Exception {
        return sqlSession.selectList(NAMESPACE + ".getReportList");
    }

    @Override
    public BookReportVO getReport(int report_id) throws Exception {
        return sqlSession.selectOne(NAMESPACE + ".getReport", report_id);
    }

    @Override
    public Integer updateReport(BookReportVO vo) throws Exception {
        return sqlSession.update(NAMESPACE + ".updateReport", vo);
    }

    @Override
    public Integer deleteReport(int report_id) throws Exception {
        return sqlSession.delete(NAMESPACE + ".deleteReport", report_id);
    }
}