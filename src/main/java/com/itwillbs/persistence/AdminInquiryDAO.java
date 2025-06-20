package com.itwillbs.persistence;

import java.util.List;

import com.itwillbs.domain.InquiryVO;
import com.itwillbs.domain.ResponseVO;

public interface AdminInquiryDAO {
	
    List<InquiryVO> getAllInquiries();
    
    InquiryVO getInquiry(int inquiry_id);
    
    ResponseVO getResponse(int inquiry_id);
    
    void insertResponse(ResponseVO response); 

    void updateResponse(ResponseVO response);
    
    void deleteResponse(int response_id);

}
