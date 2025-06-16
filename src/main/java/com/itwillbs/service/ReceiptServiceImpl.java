package com.itwillbs.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.itwillbs.domain.ReceiptVO;
import com.itwillbs.dto.ReceiptDto; // Gemini 응답 파싱용 DTO
import com.itwillbs.persistence.ReceiptDAO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.security.MessageDigest;
import java.util.UUID;
// ... (Gemini 관련 import문은 이전 답변 참고) ...

@Service
public class ReceiptServiceImpl implements ReceiptService {

    private final ReceiptDAO receiptDAO;
    private final ObjectMapper objectMapper;
    // ... (Gemini API 호출에 필요한 다른 의존성들) ...

    @Value("${upload.path}")
    private String uploadPath;

    @Autowired
    public ReceiptServiceImpl(ReceiptDAO receiptDAO, ObjectMapper objectMapper) {
        this.receiptDAO = receiptDAO;
        this.objectMapper = objectMapper;
    }

    @Override
    @Transactional // 모든 과정이 하나의 트랜잭션으로 동작하도록 설정
    public ReceiptVO processAndSaveReceipt(MultipartFile file, int memberIdx) throws Exception {
        
        // 1. 파일 해시 생성 및 중복 확인
        String fileHash = generateFileHash(file);
        if (receiptDAO.countByFileHash(fileHash) > 0) { // DAO에 countByFileHash 메서드가 있어야 함
            throw new IllegalStateException("동일한 내용의 파일이 이미 등록되어 있습니다.");
        }

        // 2. 파일 저장
        String originalFilename = file.getOriginalFilename();
        String savedFilename = UUID.randomUUID().toString() + "_" + originalFilename;
        File targetFile = new File(uploadPath, savedFilename);
        
        File uploadDirFile = new File(uploadPath);
        if (!uploadDirFile.exists()) {
            uploadDirFile.mkdirs();
        }
        file.transferTo(targetFile);

        // 3. Gemini API 호출하여 정보 추출 (이전 답변의 Gemini 호출 로직 사용)
        // byte[] imageBytes = file.getBytes();
        // ReceiptDto ocrDto = callGeminiApi(imageBytes, file.getContentType());
        
        // 임시 DTO 결과 (실제로는 API 호출 결과로 대체)
        ReceiptDto ocrDto = new ReceiptDto();
        ocrDto.setSeller("한솥서점");
        ocrDto.setBookTitle("WHY? 왕자와공주");
        ocrDto.setPrice("20800");
        // ...
        
        // 4. 최종 VO 객체에 모든 정보 설정
        ReceiptVO finalVO = new ReceiptVO();
        finalVO.setMember_idx(memberIdx);
        finalVO.setOriginalfilename(originalFilename);
        finalVO.setSavedfilename(savedFilename);
        finalVO.setFilepath(targetFile.getAbsolutePath());
        finalVO.setFile_size((int) file.getSize());
        finalVO.setFile_type(file.getContentType());
        finalVO.setFileHash(fileHash);
        
        // 파싱된 OCR 결과 설정
        finalVO.setOcr_store(ocrDto.getSeller());
        finalVO.setOcr_booktitle(ocrDto.getBookTitle());
        finalVO.setApprovalnumber(ocrDto.getApprovalNumber());
        finalVO.setOcr_amount(Integer.parseInt(ocrDto.getPrice()));
        // ... 날짜 변환 및 설정 ...

        finalVO.setUpload_status("SUCCESS");

        // 5. DB에 저장
        receiptDAO.insertReceipt(finalVO);

        return finalVO;
    }

    // 파일 해시 생성 로직 (private 헬퍼 메서드로 변경)
    private String generateFileHash(MultipartFile file) throws Exception {
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] hash = digest.digest(file.getBytes());
        StringBuilder hexString = new StringBuilder();
        for (byte b : hash) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) hexString.append('0');
            hexString.append(hex);
        }
        return hexString.toString();
    }
}