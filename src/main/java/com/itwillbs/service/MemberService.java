package com.itwillbs.service;

import java.util.List;

import com.itwillbs.domain.MemberVO;

public interface MemberService {
	// => 메서드 작성시 이름을 컨트롤러에서 사용되는 기능의 이름

	// 서버시간 조회용
	String getServerTime();

	// 로그인 체크
	MemberVO memberLoginCheck(MemberVO vo);

	// 회원가입 (기존 단일 정보)
	void memberJoin(MemberVO vo);

	// 회원가입 (관심 카테고리 포함)
	void joinMemberWithCategory(MemberVO vo, List<Integer> categoryIds);

	// 회원정보 조회
	MemberVO memberInfo(String member_id);

	// 회원정보 수정
	void memberUpdate(MemberVO uvo);

	// 회원탈퇴
	int memberDelete(MemberVO dvo);

	// 회원 수정페이지 > 관심 카테고리 수정
	void updateMemberWithCategories(MemberVO vo, List<Integer> categoryIds);

	// 닉네임 조회 메서드
	MemberVO getMemberByNick(String member_nick);

	// 닉네임 중복 확인용
	boolean checkNickname(String nickname);

	// 아이디 중복 확인용
	boolean checkId(String member_id);

	// 이메일로 회원 조회
	MemberVO memberInfoByEmail(String email);

	// 휴대폰으로 회원 조회
	MemberVO memberInfoByPhone(String phone);

	// ✅ 이름 + 휴대폰으로 아이디 찾기
	String findIdByNamePhone(String member_name, String member_phone);

}
