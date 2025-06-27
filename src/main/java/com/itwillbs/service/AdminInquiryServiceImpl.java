package com.itwillbs.service;

import java.sql.Timestamp;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itwillbs.domain.InquiryVO;
import com.itwillbs.domain.ResponseVO;
import com.itwillbs.persistence.AdminInquiryDAO;

@Service
public class AdminInquiryServiceImpl implements AdminInquiryService {

    @Autowired
    private AdminInquiryDAO  aiDao;

    @Override
    public List<InquiryVO> getAllInquiries() {
        return aiDao.getAllInquiries();
    }

    @Override
    public InquiryVO getInquiry(int inquiry_id) {
    	
        return aiDao.getInquiry(inquiry_id);
    }

    @Override
    public ResponseVO getResponse(int inquiry_id) {
        return aiDao.getResponse(inquiry_id);
    }

    @Override
    public void insertResponse(ResponseVO response) {
    	 // 1) 동일한 시간 생성
        Timestamp now = new Timestamp(System.currentTimeMillis());
        response.setCreated_at(now); // ✅ response 객체에도 시간 넣기
    	
        // 답변 등록
        aiDao.insertResponse(response);
        
        // 2. 문의 상태 '답변완료'로 변경
        aiDao.updateInquiryStatus(response.getInquiry_id());
        
        // 처리일자 설정
        aiDao.setInquiryProcessedAt(response.getInquiry_id(), now); // 처리일자 '동일한 now'
    }

    @Override
    public void updateResponse(ResponseVO response) {
        aiDao.updateResponse(response);
    }

    @Override
    public void deleteResponse(int response_id, int inquiry_id) {
        aiDao.deleteResponse(response_id); // 답변 삭제
        aiDao.resetInquiryStatus(inquiry_id); // 상태 → 접수
        aiDao.resetInquiryProcessedAt(inquiry_id); 
    }
    
    // 페이징 처리
    @Override
    public List<InquiryVO> getInquiryList(Map<String, Object> paramMap) {
        return aiDao.getInquiryList(paramMap);
    }

    @Override
    public int getInquiryCount(Map<String, Object> paramMap) {
        return aiDao.getInquiryCount(paramMap);
    }
    
    // 미확인 문의 수
    @Override
    public int getUncheckedInquiryCount() {
        return aiDao.getUncheckedInquiryCount();
    }

    
}

