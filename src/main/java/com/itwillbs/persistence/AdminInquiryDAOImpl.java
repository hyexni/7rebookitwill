package com.itwillbs.persistence;

import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.itwillbs.domain.InquiryVO;
import com.itwillbs.domain.ResponseVO;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class AdminInquiryDAOImpl implements AdminInquiryDAO {

    private static final String NAMESPACE = "com.itwillbs.persistence.AdminInquiryDAO.";

    @Autowired
    private SqlSession sqlSession;

    @Override
    public List<InquiryVO> getAllInquiries() {
        return sqlSession.selectList(NAMESPACE + "getAllInquiries");
    }

    @Override
    public InquiryVO getInquiry(int inquiry_id) {
        return sqlSession.selectOne(NAMESPACE + "getInquiry", inquiry_id);
    }

    @Override
    public ResponseVO getResponse(int inquiry_id) {
        return sqlSession.selectOne(NAMESPACE + "getResponse", inquiry_id);
    }

    // 답변 등록
    @Override
    public void insertResponse(ResponseVO response) {
        sqlSession.insert(NAMESPACE + "insertResponse", response);
    }
    
    // 답변 상태 업데이트
    @Override
    public void updateInquiryStatus(int inquiry_id) {
        sqlSession.update(NAMESPACE + "updateInquiryStatus", inquiry_id);
    }

    @Override
    public void updateResponse(ResponseVO response) {
        sqlSession.update(NAMESPACE + "updateResponse", response);
    }

    @Override
    public void deleteResponse(int response_id) {
        sqlSession.delete(NAMESPACE + "deleteResponse", response_id);
    }
    
    @Override
    public void resetInquiryStatus(int inquiry_id) {
        sqlSession.update(NAMESPACE + "resetInquiryStatus", inquiry_id);
    }
    
    
    
    
    // 처리일자
    @Override
    public void setInquiryProcessedAt(int inquiry_id, Timestamp created_at) {
    	Map<String, Object> params = new HashMap<>();
        params.put("inquiry_id", inquiry_id);
        params.put("created_at", created_at);
        sqlSession.update(NAMESPACE + "setInquiryProcessedAt", params);
    }

    @Override
    public void resetInquiryProcessedAt(int inquiry_id) {
        sqlSession.update(NAMESPACE + "resetInquiryProcessedAt", inquiry_id);
    }

    
    
    // 페이징 처리
    @Override
    public List<InquiryVO> getInquiryList(int startRow, int pageSize, String keyword) {
        Map<String, Object> params = new HashMap<>();
        params.put("startRow", startRow);
        params.put("pageSize", pageSize);
        params.put("keyword", keyword);
        return sqlSession.selectList(NAMESPACE + "getInquiryList", params);
    }

    @Override
    public int getInquiryCount(String keyword) {
        return sqlSession.selectOne(NAMESPACE + "getInquiryCount", keyword);
    }
}
