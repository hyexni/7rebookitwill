package com.itwillbs.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping(value = "/cs/*")
public class InquiryController {

	// mylog
	private static final Logger logger = LoggerFactory.getLogger(InquiryController.class);

	// 서비스 객체를 주입
	
	// 기능을 정의
	
	// http://localhost:8088/cs/write
	// 글쓰기 (정보 입력) / GET
	@RequestMapping(value = "/write", method = RequestMethod.GET)
	public void inquiryWriteGET() throws Exception {
		logger.info(" inquiryWriteGET() 실행 ");
		
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
} // InquiryController 끝
