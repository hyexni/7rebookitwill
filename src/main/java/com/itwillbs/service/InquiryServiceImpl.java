package com.itwillbs.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.itwillbs.domain.NoticeVO;

public class InquiryServiceImpl implements InquiryService {
	
	// mylog
	private static final Logger logger = LoggerFactory.getLogger(InquiryServiceImpl.class);
	
	// NoticeDAO 객체 필요 => 객체를 주입받아서 사용


	// 1:1 문의하기 글쓰기
	@Override
	public void inquiryWrite(NoticeVO vo) throws Exception {
		
		
		
	}

	
}
