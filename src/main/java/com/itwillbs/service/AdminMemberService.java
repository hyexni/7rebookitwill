package com.itwillbs.service;

import java.util.List;

import com.itwillbs.domain.MemberVO;

public interface AdminMemberService {
	
	// 1. 전체 회원 목록 조회
	List<MemberVO> getMemberList(String sort, String dir, int startRow, int pageSize);
    List<MemberVO> searchMembers(String keyword, String sort, String dir, int startRow, int pageSize);
    int getTotalCount();
    int getSearchCount(String keyword);

}
