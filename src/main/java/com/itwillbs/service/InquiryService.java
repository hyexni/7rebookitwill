package com.itwillbs.service;

import com.itwillbs.domain.InquiryVO;

public interface InquiryService {
	
	// 1:1 문의하기 글쓰기
	public void inquiryWrite(InquiryVO vo) throws Exception;
	

}
