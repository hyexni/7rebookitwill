package com.itwillbs.persistence;

import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.itwillbs.domain.Criteria;
import com.itwillbs.domain.BookReportVO;

@Repository
public class BookReportDAOImpl implements BookReportDAO {

    @Inject
    private SqlSession sqlSession;

    // MyBatis 매퍼 네임스페이스 상수
    private static final String NAMESPACE = "com.itwillbs.mapper.BookReportMapper";

    /**
     * [독후감 목록 조회]
     * - 특정 도서의 독후감 리스트를 조건(Criteria)에 따라 조회
     */
    @Override
    public List<BookReportVO> getBookReportList(Criteria criteria) {
        return sqlSession.selectList(NAMESPACE + ".getBookReportList", criteria);
    }

    /**
     * [독후감 등록]
     * - 사용자가 작성한 독후감 정보를 DB에 저장
     */
    @Override
    public void insertBookReport(BookReportVO vo) throws Exception {
        sqlSession.insert(NAMESPACE + ".insertBookReport", vo);
    }
    
    /**
     * ✅ [추가] 특정 회원이 작성한 모든 독후감 목록 조회 구현
     */
    @Override
    public List<BookReportVO> getReportListByMember(int member_idx) throws Exception {
        return sqlSession.selectList(NAMESPACE + ".getReportListByMember", member_idx);
    }
    
 // ✅독후감 상세 정보 조회 구현
    @Override
    public BookReportVO getBookReportDetail(int report_id) throws Exception {
        return sqlSession.selectOne(NAMESPACE + ".getBookReportDetail", report_id);
    }
    
    // [독후감 수정 처리] - SqlSession을 이용해서 실제 SQL 실행
    @Override
    public void updateBookReport(BookReportVO vo) throws Exception {
        // Mapper에 정의된 updateBookReport SQL문을 실행하고, BookReportVO 데이터 전달
        sqlSession.update(NAMESPACE + ".updateBookReport", vo);
    }
    
   
     // 독후감 삭제
    @Override
    public int deleteBookReport(BookReportVO vo) {
        return sqlSession.delete(NAMESPACE + ".deleteBookReport", vo);
    }

    
    
}
