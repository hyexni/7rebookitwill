package com.itwillbs.persistence;

import java.sql.Timestamp;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.itwillbs.domain.InquiryVO;
import com.itwillbs.domain.ResponseVO;

public interface AdminInquiryDAO {
	
    List<InquiryVO> getAllInquiries();
    
    InquiryVO getInquiry(int inquiry_id);
    
    ResponseVO getResponse(int inquiry_id);
    
    // 답변 등록
    void insertResponse(ResponseVO response); 
    // 답변 상태 업데이트
    void updateInquiryStatus(int inquiry_id);

    void updateResponse(ResponseVO response);
    
    void deleteResponse(int response_id);
    void resetInquiryStatus(int inquiry_id);  // 상태 → 접수
    
    
    
    // 처리일자
    void setInquiryProcessedAt(@Param("inquiry_id") int inquiry_id, 
    						@Param("created_at") Timestamp created_at);       // 답변 등록 시
    void resetInquiryProcessedAt(int inquiry_id);     // 답변 삭제 시

    
    // 페이징 처리
    List<InquiryVO> getInquiryList(@Param("startRow") int startRow, 
    							   @Param("pageSize") int pageSize,
    							   @Param("keyword") String keyword);
    public int getInquiryCount(@Param("keyword") String keyword);

}
