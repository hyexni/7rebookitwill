package com.itwillbs.service;

import com.itwillbs.domain.ReceiptVO;
import com.itwillbs.domain.Criteria;
import com.itwillbs.dto.AdminReceiptDTO;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

public interface ReceiptService {

    /**
     * 업로드된 영수증 파일을 받아 모든 처리(해시, 중복검사, 저장, OCR, DB 저장)를 수행
     * @param file 업로드된 이미지 파일
     * @param memberIdx 작업을 요청한 회원 ID
     * @return 모든 처리가 완료된 최종 영수증 정보
     * @throws Exception 모든 종류의 예외
     */
    ReceiptVO processAndSaveReceipt(MultipartFile file, int member_idx) throws Exception;

    // isDuplicate, ReceiptUpload 등의 메서드는 이제 processAndSaveReceipt 내부에서만
    // 사용되므로, 외부로 노출할 필요가 없습니다. (인터페이스에서 제거 가능)

    /** [관리자] 페이징 처리된 전체 영수증 목록 조회 */
    public List<AdminReceiptDTO> getReceiptListAdmin(Criteria cri) throws Exception;

    /** [관리자] 전체 영수증 개수 조회 */
    public int getReceiptTotalCount(Criteria cri) throws Exception;

}

