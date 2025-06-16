package com.itwillbs.service;

import com.itwillbs.domain.ReceiptVO;
import com.itwillbs.dto.ReceiptDto;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

public interface ReceiptService {
    boolean isDuplicate(String originalFilename);
    void uploadReceipt(ReceiptVO vo) throws Exception;
    List<ReceiptVO> getAllReceipts() throws Exception;
    ReceiptDto getInfoFromReceipt(MultipartFile imageFile) throws IOException;
	void ReceiptUpload(ReceiptVO vo);
}
