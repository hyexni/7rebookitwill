package com.itwillbs.persistence;

import java.util.List;

import com.itwillbs.domain.InquiryVO;
import com.itwillbs.domain.ResponseVO;

public interface InquiryDAO {
	
	// 1:1 문의하기 글쓰기
	public void insertInquiry(InquiryVO vo) throws Exception;
	
	// 1:1 문의 목록
	 List<InquiryVO> getInquiryList(int member_idx);
	 
	// 상세 조회
	 InquiryVO getInquiry(int inquiry_id);
	 
	 // 답변
	 ResponseVO getResponse(int inquiry_id);
	 
	 // 수정
	 void updateInquiry(InquiryVO vo) throws Exception;
	 
	 // 삭제
	 void deleteInquiry(int inquiry_id) throws Exception;




}
