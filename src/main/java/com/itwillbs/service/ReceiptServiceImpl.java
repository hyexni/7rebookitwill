package com.itwillbs.service;

import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.itwillbs.domain.ReceiptVO;
import com.itwillbs.persistence.ReceiptDAO;

@Service 
public class ReceiptServiceImpl implements ReceiptService {
 
private static final Logger logger = LoggerFactory.getLogger(ReceiptServiceImpl.class);
	
@Inject
	private ReceiptDAO RDao;
	
	//영수증 업로드 메서드
	@Override
	public void ReceiptUpload(ReceiptVO vo) throws Exception {
		RDao.ReceiptUploadInsert(vo);
		logger.info("영수증 업로드 기능 완료");
		
	}
	/**
     * [수정] 파일명이 아닌 파일의 고유 해시값으로 중복을 확인하는 메서드
     * @param fileHash 확인할 파일의 SHA-256 해시값
     * @return 중복이면 true, 아니면 false
     */
    @Override
    public boolean isDuplicate(String fileHash) {
        logger.info("파일 해시값으로 중복 확인: {}", fileHash);
        // [수정] 파라미터로 받은 fileHash를 DAO로 전달
        return RDao.isDuplicate(fileHash);
    }
    
    @Override
    public List<ReceiptVO> getAllReceipts() throws Exception {
        logger.info("getAllReceipts() 호출");
        return RDao.selectAllReceipts(); // 호출하는 메서드 이름 확인
    }
}
	
	

