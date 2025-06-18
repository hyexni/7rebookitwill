package com.itwillbs.controller;

import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.itwillbs.domain.NoticeVO;
import com.itwillbs.service.NoticeService;

@Controller
@RequestMapping(value = "/notice/*")
public class NoticeController {
	
	// mylog
	private static final Logger logger = LoggerFactory.getLogger(NoticeController.class);

	// 서비스 주입
	@Inject
	private NoticeService nService;
	
	// http://localhost:8088/notice/listALL
	// 공지사항 리스트 (ALL)
	@RequestMapping(value = "/listALL", method = RequestMethod.GET)
	public void noticeListAllGET(Model model) throws Exception {
		logger.info(" noticeListAllGET() 실행 ");
		
		
		// 서비스 -> DAO 호출 -> DB 조회
		List<NoticeVO> noticeList = nService.noticeListAll();
		// 뷰에 데이터를 실어 보내기
		model.addAttribute("noticeList", noticeList);
		
		
	}

}
