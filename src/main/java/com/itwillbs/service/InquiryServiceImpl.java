package com.itwillbs.service;

import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.itwillbs.domain.InquiryVO;
import com.itwillbs.persistence.InquiryDAO;

@Service
public class InquiryServiceImpl implements InquiryService {
	
	// mylog
	private static final Logger logger = LoggerFactory.getLogger(InquiryServiceImpl.class);
	
	// InquiryDAO 객체 필요 => 객체를 주입받아서 사용
	@Inject
	private InquiryDAO iDAO;

	// 1:1 문의하기 글쓰기
	@Override
	public void inquiryWrite(InquiryVO vo) throws Exception {
		iDAO.insertInquiry(vo);
	}

	
	// 1:1 문의 목록
	@Override
	public List<InquiryVO> getInquiryList(int member_idx) {
		// DAO 통해 DB에서 해당 회원의 문의 리스트 가져오기
		return iDAO.getInquiryList(member_idx);
	}
	
	

	
}
