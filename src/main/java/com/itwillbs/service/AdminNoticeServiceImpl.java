package com.itwillbs.service;

import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.itwillbs.controller.AdminNoticeController;
import com.itwillbs.domain.NoticeVO;
import com.itwillbs.persistence.AdminNoticeDAO;

@Service
public class AdminNoticeServiceImpl implements AdminNoticeService {

	// mylog
	private static final Logger logger = LoggerFactory.getLogger(AdminNoticeController.class);
	
	// AdminNoticeDAO 객체 필요 => 객체를 주입받아서 사용
	@Inject
	private AdminNoticeDAO anDao;
	
	@Override
	public void adminNoticeWrite(NoticeVO vo) throws Exception {
		// DAO에 글쓰기 기능을 호출
		anDao.insertNotice(vo);
		logger.info(" 글쓰기 서비스 기능 완료 ");
		
	}
	
	// 관리자 공지사항 목록 조회
	/*
	 * @Override public List<NoticeVO> getNoticeList() throws Exception { return
	 * anDao.getNoticeList(); }
	 */
	
	// 공지사항 상세/수정/삭제
	@Override
	public NoticeVO getNoticeById(int notice_id) throws Exception {
	    return anDao.getNoticeById(notice_id);
	}

	@Override
	public void updateNotice(NoticeVO vo) throws Exception {
		anDao.updateNotice(vo);
	}

	@Override
	public void deleteNotice(int notice_id) throws Exception {
		anDao.deleteNotice(notice_id);
	}
	
	
	// 페이징 처리
	// 구현체
	@Override
	public List<NoticeVO> getNoticeListPage(int startRow, int pageSize) {
	    return anDao.getNoticeListPage(startRow, pageSize);
	}

	@Override
	public int getNoticeCount() {
	    return anDao.getNoticeCount();
	}



	
	

}
