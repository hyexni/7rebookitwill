package com.itwillbs.service;

import com.itwillbs.domain.ReceiptVO;
import com.itwillbs.domain.SearchCriteria;

import com.itwillbs.dto.AdminReceiptDTO;
import com.itwillbs.dto.ReceiptDTO;

import org.springframework.web.multipart.MultipartFile;
import java.util.List;

public interface ReceiptService {

    /**
     * 업로드된 영수증 파일을 처리하고, OCR을 통해 인식된 정보를 DB에 저장합니다.
     * 포인트 적립 로직은 이 메서드에서 제거되고, PointService로 역할이 이전됩니다.
     * * @param file 업로드된 이미지 파일
     * @param member_idx 작업을 요청한 회원 ID
     * @return 모든 처리가 완료된 최종 영수증 정보 (OCR 금액 포함)
     * @throws Exception 모든 종류의 예외
     */
    ReceiptVO processAndSaveReceipt(MultipartFile file, int member_idx) throws Exception;
    
    
    /**
     * [추가] 특정 영수증의 상세 정보를 조회합니다.
     * @param receipt_idx 조회할 영수증의 ID
     * @return 영수증 상세 정보
     * @throws Exception
     */
    ReceiptVO getReceiptDetails(int upload_id) throws Exception;
    
    //사용자의 영수증 내역 확인//
    public List<ReceiptDTO> getMyReceiptList(Integer member_idx);
    
       

    /** [관리자] 페이징 처리된 전체 영수증 목록 조회 (유지) */
    List<AdminReceiptDTO> getReceiptListAdmin(SearchCriteria cri) throws Exception;

    /** [관리자] 전체 영수증 개수 조회 (유지) */
    int getReceiptTotalCount(SearchCriteria cri) throws Exception;





	
    
   
    
   
    
}

    
    
