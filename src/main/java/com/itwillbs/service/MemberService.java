package com.itwillbs.service;

import com.itwillbs.domain.MemberVO;

public interface MemberService {
	// => 메서드 작성시 이름을 컨트롤러에서 사용되는 기능의 이름
	

	// 서버시간 조회
	public String getServerTime();
	
	// 회원가입 처리
	public void memberJoin(MemberVO vo);
	
	// 로그인 여부 체크 
	public MemberVO memberLoginCheck(MemberVO vo);
	
	// 마이페이지 (회원정보 조회)
	public MemberVO memberInfo(String id);
	
	// 회원정보 수정
	public void memberUpdate(MemberVO uvo);


	
	
	
	
}
