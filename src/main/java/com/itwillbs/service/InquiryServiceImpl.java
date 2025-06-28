package com.itwillbs.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.itwillbs.domain.InquiryVO;
import com.itwillbs.domain.ResponseVO;
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
	public List<InquiryVO> getInquiryListPage(int member_idx, int startRow, int pageSize) {
		 Map<String, Object> paramMap = new HashMap<>();
		    paramMap.put("member_idx", member_idx);
		    paramMap.put("startRow", startRow);
		    paramMap.put("pageSize", pageSize);
		    return iDAO.getInquiryListPage(paramMap);
	}
	
	
	
	@Override
	public int getInquiryCount(int member_idx) {
		
		return iDAO.getInquiryCount(member_idx);
	}


	// 상세 조회
	@Override
	public InquiryVO getInquiry(int inquiry_id) {
	    return iDAO.getInquiry(inquiry_id);
	}
	
	// 답변
	@Override
	public ResponseVO getResponse(int inquiry_id) {
	    return iDAO.getResponse(inquiry_id); // DAO로 위임
	}
	
	// 수정
	@Override
	public void updateInquiry(InquiryVO vo) throws Exception {
		iDAO.updateInquiry(vo);
	}

	// 삭제
	@Override
	public void deleteInquiry(int inquiry_id) throws Exception {
	    iDAO.deleteInquiry(inquiry_id);
	}


	
	
	
	
	

	
}
