package com.itwillbs.persistence;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.itwillbs.domain.Criteria;
import com.itwillbs.domain.ReceiptVO;
import com.itwillbs.domain.SearchCriteria;
import com.itwillbs.dto.AdminReceiptDTO;



//ReceiptUploadDAO : 서비스의 요청을 받아서 SQL 구문을 실행
@Mapper
public interface ReceiptDAO {	
	
	public void ReceiptUploadInsert(ReceiptVO vo) throws Exception;
	 /**
     * 파일명이 DB에 이미 존재하는지 확인하는 메서드
     * @param originalFilename 확인할 원본 파일명
     * @return 중복이면 true, 아니면 false
     */
    // 서비스에서 사용하는 isDuplicate 메서드 선언 추가
    public boolean isDuplicate(String originalFilename);
    
    // 모든 영수증 목록을 조회하는 메서드 선언
    public List<ReceiptVO> selectAllReceipts() throws Exception;
    
    int countByFilename(String filename);
    
	public void insertReceipt(ReceiptVO vo);
	
	// 파일 해시값(String)을 받아 중복된 개수(int)를 반환하는 메서드입니다.
	public int countByFileHash(String fileHash);

	// 포인트 적립 메서드: PointHistoryVO 대신 Map으로 필요한 값만 받음
    public void addPointHistory(Map<String, Object> params);

    // 회원 총 포인트 업데이트 메서드는 그대로 사용
    public void updateUserPoint(Map<String, Object> params);
    
    
    /** [관리자] 페이징 처리된 전체 영수증 목록 조회 */
    public List<AdminReceiptDTO> getReceiptListAdmin(Criteria cri) throws Exception;

    /** [관리자] 전체 영수증 개수 조회 (페이징 계산용) */
    public int getReceiptTotalCount(Criteria cri) throws Exception;
	
}
