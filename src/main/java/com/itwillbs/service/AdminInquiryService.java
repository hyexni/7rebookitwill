package com.itwillbs.service;

import java.util.List;

import com.itwillbs.domain.InquiryVO;
import com.itwillbs.domain.ResponseVO;

public interface AdminInquiryService {
	
    List<InquiryVO> getAllInquiries();
    
    InquiryVO getInquiry(int inquiry_id);
    
    ResponseVO getResponse(int inquiry_id);
    
    void insertResponse(ResponseVO response);
    
    void updateResponse(ResponseVO response);
    
    // 답변 삭제 + 상태 변경
    void deleteResponse(int response_id, int inquiry_id);
    
    // 페이징 처리
    List<InquiryVO> getInquiryList(int startRow, int pageSize);
    int getInquiryCount();
}