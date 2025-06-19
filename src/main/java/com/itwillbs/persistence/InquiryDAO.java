package com.itwillbs.persistence;

import com.itwillbs.domain.InquiryVO;

public interface InquiryDAO {
	
	// 1:1 문의하기 글쓰기
	public void inquiryInsert(InquiryVO vo) throws Exception;

}
