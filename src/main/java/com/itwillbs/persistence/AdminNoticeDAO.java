package com.itwillbs.persistence;


import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.itwillbs.domain.NoticeVO;

public interface AdminNoticeDAO {
	
	// 공지사항 글쓰기
	public void insertNotice(NoticeVO vo) throws Exception;
	
	
	// 공지사항 목록 조회
	/* List<NoticeVO> getNoticeList() throws Exception; */
	
	
	// 공지사항 상세/수정/삭제 메서드
	NoticeVO getNoticeById(int notice_id) throws Exception;
	void updateNotice(NoticeVO vo) throws Exception;
	void deleteNotice(int notice_id) throws Exception;

	// 페이징된 목록 가져오기
	List<NoticeVO> getNoticeListPage(@Param("startRow") int startRow, @Param("pageSize") int pageSize);

	// 전체 개수
	public int getNoticeCount();

	
}