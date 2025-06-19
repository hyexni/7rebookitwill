package com.itwillbs.service;

import java.util.List;

import com.itwillbs.domain.NoticeVO;

public interface NoticeService {
	
	/** 공지사항 전체 목록 리턴 */
	List<NoticeVO> noticeListAll() throws Exception;
	
	NoticeVO getNotice(int notice_id) throws Exception;
}