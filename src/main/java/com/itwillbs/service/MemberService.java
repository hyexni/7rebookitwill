package com.itwillbs.service;

import java.util.List;

import com.itwillbs.domain.CategoryVO;
import com.itwillbs.domain.MemberVO;

public interface MemberService {

	// 서버시간 조회
	String getServerTime();

	// 로그인 체크
	MemberVO memberLoginCheck(MemberVO vo);

	// 기본 회원가입 (단일 정보)
	void memberJoin(MemberVO vo);

	// 회원가입 (관심 카테고리 포함)
	void joinMemberWithCategory(MemberVO vo, List<Integer> categoryIds);

	// 아이디로 회원정보 조회
	MemberVO memberInfo(String member_id);

	// 회원정보 수정
	void memberUpdate(MemberVO uvo);

	// 회원 탈퇴
	int memberDelete(MemberVO dvo);

	// 고유번호로 회원정보 조회 (수정용)
	MemberVO memberInfo(int member_idx);

	// 회원정보 + 관심 카테고리 함께 수정
	void updateMemberWithCategories(MemberVO vo, List<Integer> categoryIds);

	// 닉네임으로 회원 조회
	MemberVO getMemberByNick(String member_nick);

	// 닉네임 중복확인 (true = 중복)
	boolean checkNickname(String nickname);

	// 아이디 중복확인 (true = 중복)
	boolean checkId(String member_id);

	// 이메일로 회원 조회
	MemberVO memberInfoByEmail(String email);

	// 휴대폰으로 회원 조회
	MemberVO memberInfoByPhone(String phone);

	// 이름 + 휴대폰 번호로 아이디 찾기
	String findIdByNamePhone(String member_name, String member_phone);

	// 회원정보로 비밀번호 찾기
	String findPwByInfo(MemberVO vo);

	// 관심 카테고리 ID 목록 조회
	List<Integer> getSelectedCategoryIds(int member_idx);

	// 회원 고유번호로 회원정보 조회 (member_idx 기준)
	MemberVO getMemberByIdx(int member_idx);

	// 카테고리 전체 목록
	List<CategoryVO> getCategoryList();

	// ✅ member_idx 기준 선택한 카테고리 목록 (이름까지)
	List<CategoryVO> getSelectedCategories(int member_idx);

	// 회원 탈퇴 처리 메서드
	void deleteMember(String member_id);
}
