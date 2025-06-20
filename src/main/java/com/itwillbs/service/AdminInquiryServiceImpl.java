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
    public InquiryVO getInquiry(int inquiryId) {
        return aiDao.getInquiry(inquiryId);
    }

    @Override
    public ResponseVO getResponse(int inquiryId) {
        return aiDao.getResponse(inquiryId);
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
    public void deleteResponse(int responseId) {
        aiDao.deleteResponse(responseId);
    }
}

