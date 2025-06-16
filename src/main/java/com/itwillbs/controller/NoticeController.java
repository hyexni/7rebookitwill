package com.itwillbs.controller;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.itwillbs.domain.NoticeVO;

@Controller
@RequestMapping(value = "/notice/*")
public class NoticeController {
	
	// mylog
	private static final Logger logger = LoggerFactory.getLogger(NoticeController.class);

	
	// 공지사항 리스트 (ALL) 
	public void noticeListAllGET(Model model) {
		logger.info(" noticeListAllGET() 실행 ");
		
		// 서비스 -> DAO 호출 -> DB 조회
		List<NoticeVO> noticeList = noticeService.getNoticeList();
		model.addAttribute("noticeList", noticeList);
	}

}
