package com.itwillbs.persistence;

import java.util.List;

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

    @Override
    public void insertResponse(ResponseVO response) {
        sqlSession.insert(NAMESPACE + "insertResponse", response);
    }

    @Override
    public void updateResponse(ResponseVO response) {
        sqlSession.update(NAMESPACE + "updateResponse", response);
    }

    @Override
    public void deleteResponse(int response_id) {
        sqlSession.delete(NAMESPACE + "deleteResponse", response_id);
    }
}
