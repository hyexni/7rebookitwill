package com.itwillbs.persistence;

import java.util.List;

import com.itwillbs.domain.InquiryVO;

public interface InquiryDAO {
	
	// 1:1 문의하기 글쓰기
	public void insertInquiry(InquiryVO vo) throws Exception;
	
	// 1:1 문의 목록
	 List<InquiryVO> getInquiryList(int member_idx);
	 
	// 상세 조회
	 InquiryVO getInquiry(int inquiry_id);


}
