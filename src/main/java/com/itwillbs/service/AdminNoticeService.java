package com.itwillbs.service;

import java.util.List;

import com.itwillbs.domain.NoticeVO;

public interface AdminNoticeService {
	
		// 관리자 공지사항 글쓰기
		public void adminNoticeWrite(NoticeVO vo) throws Exception;

		
		// 관리자 공지사항 목록 조회
		List<NoticeVO> getNoticeList() throws Exception;
		
		
		// 공지사항 상세/수정/삭제
		NoticeVO getNoticeById(int notice_id) throws Exception;
		void updateNotice(NoticeVO vo) throws Exception;
		void deleteNotice(int notice_id) throws Exception;

		
}
