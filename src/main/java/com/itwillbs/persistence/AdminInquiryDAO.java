package com.itwillbs.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.itwillbs.domain.InquiryVO;
import com.itwillbs.domain.ResponseVO;

public interface AdminInquiryDAO {
	
    List<InquiryVO> getAllInquiries();
    
    InquiryVO getInquiry(int inquiry_id);
    
    ResponseVO getResponse(int inquiry_id);
    
    void insertResponse(ResponseVO response); 

    void updateResponse(ResponseVO response);
    
    void deleteResponse(int response_id);
    
    // 페이징 처리
    List<InquiryVO> getInquiryList(@Param("startRow") int startRow, @Param("pageSize") int pageSize);
    public int getInquiryCount();

}
