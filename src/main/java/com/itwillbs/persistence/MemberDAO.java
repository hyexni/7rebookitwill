package com.itwillbs.persistence;

import com.itwillbs.domain.MemberVO;

/**
 *  DAO에서 수행할 동작을 추상메서드로 정의 
 *
 */
public interface MemberDAO {
	// => 메서드 이름을 작성시 디비에서 동작하는 이름을 설정

	// 디비 서버의 시간정보를 가져오기
	public String getServerTime();
	
	// 회원가입 처리
	public void insertMember(MemberVO vo);
	
	// 로그인 체크
	public MemberVO memberLoginCheck(MemberVO vo);
	public MemberVO memberLoginCheck(String member_id,String member_pw);
	
	// 마이페이지 (회원정보 조회)
	public MemberVO getMember(String member_id);
	
	// 회원정보 수정
	public void updateMember(MemberVO uvo);
	
	// 회원정보 삭제(탈퇴)
	public int deleteMember(MemberVO dvo);
	
	
	
	
	
	
	
}
