package com.itwillbs.service;

import java.util.List;

import com.itwillbs.domain.InquiryVO;
import com.itwillbs.domain.ResponseVO;

public interface AdminInquiryService {
	
    List<InquiryVO> getAllInquiries();
    
    InquiryVO getInquiry(int inquiryId);
    
    ResponseVO getResponse(int inquiryId);
    
    void insertResponse(ResponseVO response);
    
    void updateResponse(ResponseVO response);
    
    void deleteResponse(int responseId);
}