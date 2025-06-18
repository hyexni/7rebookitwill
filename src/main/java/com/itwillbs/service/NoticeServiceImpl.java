package com.itwillbs.service;

import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.itwillbs.controller.NoticeController;
import com.itwillbs.domain.NoticeVO;
import com.itwillbs.persistence.NoticeDAO;

@Service
public class NoticeServiceImpl implements NoticeService {
	
	// mylog
	private static final Logger logger = LoggerFactory.getLogger(NoticeController.class);
	
	// Notice 객체 필요 => 객체를 주입받아서 사용
	@Inject
	private NoticeDAO nDAO;

	@Override
	public List<NoticeVO> noticeListAll() throws Exception {
		logger.info(" boardListALL() 실행 ");
		
		List<NoticeVO> noticeList = nDAO.getAllNotices();
		
		logger.info(" 공지사항 리스트 조회(all) 기능 호출 완료 ");
		
		return noticeList;
	}
	
	

}
