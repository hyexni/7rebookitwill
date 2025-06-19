package com.itwillbs.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.itwillbs.domain.InquiryVO;

@Service
public interface InquiryService {
	
	// 1:1 문의하기 글쓰기
	public void inquiryWrite(InquiryVO vo) throws Exception;
	
	// 1:1 문의 목록
	List<InquiryVO> getInquiryList(int member_idx);
	
	// 상세 조회
	InquiryVO getInquiry(int inquiry_id);
	

}
