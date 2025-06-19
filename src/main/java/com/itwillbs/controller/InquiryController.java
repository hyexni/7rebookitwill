package com.itwillbs.controller;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.itwillbs.domain.InquiryVO;
import com.itwillbs.service.InquiryService;

@Controller
@RequestMapping(value = "/cs/*")
public class InquiryController {

	// mylog
	private static final Logger logger = LoggerFactory.getLogger(InquiryController.class);

	// 서비스 객체를 주입
	@Inject InquiryService iService;
	
	// 기능을 정의
	
	// http://localhost:8088/cs/write
	// 글쓰기 (정보 입력) / GET
	@RequestMapping(value = "/write", method = RequestMethod.GET)
	public void inquiryWriteGET() throws Exception {
		logger.info(" inquiryWriteGET() 실행 ");
		
	}
	
	// 글쓰기 (정보 처리) / POST
	@RequestMapping(value = "/write", method = RequestMethod.POST)
	public String inquiryWritePOST(InquiryVO vo) throws Exception {
		logger.info(" inquiryWritePOST() 실행");
		
		// 글쓰기 동작을 처리
		
		// 한글처리 인코딩 => web.xml 필터설정
		// 1) 전달정보(파라메터)를 저장 / 제목, 내용, 고유번호
		logger.info(" vo : {}", vo);
		
		// 서비스기능 -> DAO 기능 -> DB에 저장
		iService.inquiryWrite(vo);
		
		
		return "redirect:/cs/listAll";
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
} // InquiryController 끝
