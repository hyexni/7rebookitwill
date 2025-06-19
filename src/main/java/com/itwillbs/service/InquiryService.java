package com.itwillbs.service;

import com.itwillbs.domain.NoticeVO;

public interface InquiryService {
	
	// 1:1 문의하기 글쓰기
	public void inquiryWrite(NoticeVO vo) throws Exception;
	

}
