package com.itwillbs.domain;

import lombok.Data;

@Data
public class MemberStatsDTO {
	
	private String date;			// 일자 또는 월
	private int totalMembers;		// 전체 가입자 수
	private int todayNewMembers;    // 오늘 신규 가입자 수
	private int monthNewMembers;    // 이번 달 신규 가입자 수
	private int activeMembers;		// 활성 회원 수
	private int withdrawnMembers;   // 탈퇴 회원 수

}