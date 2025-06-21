package com.itwillbs.persistence;

import java.util.List;

import com.itwillbs.domain.MemberCategoryVO;

public interface MemberCategoryDAO {

	// 회원 관심 카테고리 저장
	void insertMemberCategory(MemberCategoryVO vo);

	// 회원별 관심 카테고리 목록 조회 (회원 마이페이지 등에서 사용)
	List<MemberCategoryVO> getCategoryListByMember(int member_idx);

	// 3. 회원 관심 카테고리 전체 삭제 (수정 전에 기존 관심 카테고리 비우기)
	void deleteMemberCategoryByMemberId(int member_idx);

	// 4. 회원의 카테고리 ID 목록만 조회 (추천용 쿼리 등에서 사용)
	List<Integer> getCategoryIdsByMemberId(int member_idx);

}
