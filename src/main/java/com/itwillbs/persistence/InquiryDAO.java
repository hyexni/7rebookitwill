package com.itwillbs.persistence;

import com.itwillbs.domain.NoticeVO;

public interface InquiryDAO {
	
	// 1:1 문의하기 글쓰기
	public void inquiryInsert(NoticeVO vo) throws Exception;

}
