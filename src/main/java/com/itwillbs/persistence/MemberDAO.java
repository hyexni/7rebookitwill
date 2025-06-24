package com.itwillbs.persistence;

import org.apache.ibatis.annotations.Param;

import com.itwillbs.domain.MemberVO;

public interface MemberDAO {

	// 서버시간 조회
	String getServerTime();

	// 회원가입
	void insertMember(MemberVO vo);

	// 로그인 체크 (VO 기반)
	MemberVO memberLoginCheck(MemberVO vo);

	// 로그인 체크 (ID + PW 기반 - 거의 안 씀, VO 방식만 써도 됨)
	MemberVO memberLoginCheck(String member_id, String member_pw);

	// 회원 조회 - ID 기준 (마이페이지, 로그인 세션 등)
	MemberVO getMember(String member_id);

	// 회원 조회 - PK 기준 (member_idx)
	MemberVO getMemberByIdx(int member_idx);

	// 회원정보 수정
	void updateMember(MemberVO uvo);

	// 회원 탈퇴
	int deleteMember(MemberVO dvo);

	// 닉네임으로 회원 조회 (중복 확인용)
	MemberVO getMemberByNick(String member_nick);

	// 이메일로 회원 조회 (중복 확인, 비밀번호 찾기 등)
	MemberVO selectMemberByEmail(String email);

	// 휴대폰 번호로 회원 조회 (중복 확인, 아이디 찾기 등)
	MemberVO selectMemberByPhone(String phone);

	// 이름 + 휴대폰으로 아이디 찾기
	String findIdByNamePhone(@Param("member_name") String member_name, @Param("member_phone") String member_phone);

	// 비밀번호 찾기 (ID, 이름, 전화번호로)
	String findPwByInfo(MemberVO vo);

	// 회원 탈퇴 처리 메서드
	void deleteMember(String member_id);

}
