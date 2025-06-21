package com.itwillbs.persistence;

import java.util.List;

import com.itwillbs.domain.NoticeVO;

public interface NoticeDAO {
	
	List<NoticeVO> getAllNotices() throws Exception;			// 목록용
	
	NoticeVO selectNoticeById(int notice_id);	// 상세 조회용
	

}