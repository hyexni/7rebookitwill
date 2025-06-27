package com.itwillbs.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.itwillbs.domain.InquiryVO;
import com.itwillbs.domain.ResponseVO;

@Service
public interface InquiryService {
	
	// 1:1 문의하기 글쓰기
	public void inquiryWrite(InquiryVO vo) throws Exception;
	
	// 1:1 문의 목록
	List<InquiryVO> getInquiryListPage(int member_idx, int startRow, int pageSize);
	int getInquiryCount(int member_idx);
	
	// 상세 조회
	InquiryVO getInquiry(int inquiry_id);
	
	// ✅ 답변 조회
    ResponseVO getResponse(int inquiry_id);
    
    // 수정
    void updateInquiry(InquiryVO vo) throws Exception;

    // 삭제
    void deleteInquiry(int inquiry_id) throws Exception;


}
