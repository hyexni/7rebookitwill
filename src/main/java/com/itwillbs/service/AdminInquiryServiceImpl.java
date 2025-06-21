package com.itwillbs.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itwillbs.domain.InquiryVO;
import com.itwillbs.domain.ResponseVO;
import com.itwillbs.persistence.AdminInquiryDAO;

@Service
public class AdminInquiryServiceImpl implements AdminInquiryService {

    @Autowired
    private AdminInquiryDAO  aiDao;

    @Override
    public List<InquiryVO> getAllInquiries() {
        return aiDao.getAllInquiries();
    }

    @Override
    public InquiryVO getInquiry(int inquiry_id) {
        return aiDao.getInquiry(inquiry_id);
    }

    @Override
    public ResponseVO getResponse(int inquiry_id) {
        return aiDao.getResponse(inquiry_id);
    }

    @Override
    public void insertResponse(ResponseVO response) {
        aiDao.insertResponse(response);
    }

    @Override
    public void updateResponse(ResponseVO response) {
        aiDao.updateResponse(response);
    }

    @Override
    public void deleteResponse(int response_id) {
        aiDao.deleteResponse(response_id);
    }
    
    // 페이징 처리
    @Override
    public List<InquiryVO> getInquiryList(int startRow, int pageSize) {
        return aiDao.getInquiryList(startRow, pageSize);
    }

    @Override
    public int getInquiryCount() {
        return aiDao.getInquiryCount();
    }
}

