package com.itwillbs.service;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.itwillbs.domain.MemberCategoryVO;
import com.itwillbs.domain.MemberVO;
import com.itwillbs.persistence.MemberCategoryDAO;
import com.itwillbs.persistence.MemberDAO;

@Service
public class MemberServiceImpl implements MemberService {

	@Inject
	private MemberDAO mdao;

	@Inject
	private MemberCategoryDAO mcdao;

	// 서버시간 가져오기
	@Override
	public String getServerTime() {
		return mdao.getServerTime();
	}

	// 로그인 체크
	@Override
	public MemberVO memberLoginCheck(MemberVO vo) {
		return mdao.memberLoginCheck(vo);
	}

	// 기존 단일 회원가입 (미사용 가능)
	@Override
	public void memberJoin(MemberVO vo) {
		mdao.insertMember(vo);
	}

	// 관심 카테고리까지 포함한 회원가입 처리
	@Override
	public void joinMemberWithCategory(MemberVO vo, List<Integer> categoryIds) {
		// 1. 회원 정보 insert
		mdao.insertMember(vo); // insert 후 vo.getMember_idx()에 PK값 들어가야 함 (selectKey 설정 필수)

		int member_idx = vo.getMember_idx();

		// 2. 관심 카테고리 insert
		for (int cateId : categoryIds) {
			MemberCategoryVO mcvo = new MemberCategoryVO();
			mcvo.setMember_idx(member_idx);
			mcvo.setCategory_id(cateId);

			mcdao.insertMemberCategory(mcvo);
		}
	}

	// 닉네임 조회 메서드
	@Override
	public MemberVO getMemberByNick(String member_nick) {
		return mdao.getMemberByNick(member_nick);
	}

	// 닉네임 중복 확인 (중복이면 true, 사용 가능하면 false)
	@Override
	public boolean checkNickname(String nickname) {
		MemberVO vo = mdao.getMemberByNick(nickname);
		return vo != null;
	}

	// 아이디 중복 확인 (중복이면 true, 사용 가능하면 false)
	@Override
	public boolean checkId(String member_id) {
		MemberVO vo = mdao.getMember(member_id); // memberInfo() 대신 getMember() 썼으니 여기도 일치시킴
		return vo != null;
	}

	// 회원정보 조회
	@Override
	public MemberVO memberInfo(String member_id) {
		return mdao.getMember(member_id);
	}

	// Email 조회
	@Override
	public MemberVO memberInfoByEmail(String email) {
		return mdao.selectMemberByEmail(email);
	}

	// 휴대폰 번호 조회
	@Override
	public MemberVO memberInfoByPhone(String phone) {
		return mdao.selectMemberByPhone(phone);
	}

	// 회원정보 수정
	@Override
	public void memberUpdate(MemberVO uvo) {
		mdao.updateMember(uvo);
	}

	// 회원 탈퇴
	@Override
	public int memberDelete(MemberVO dvo) {
		return mdao.deleteMember(dvo);
	}

	// 📌 회원정보 + 관심 카테고리 수정
	@Override
	public void updateMemberWithCategories(MemberVO vo, List<Integer> categoryIds) {
		// 1. 회원 기본 정보 수정
		mdao.updateMember(vo);

		// 2. 기존 관심 카테고리 삭제
		mcdao.deleteMemberCategoryByMemberId(vo.getMember_idx());

		// 3. 새 관심 카테고리 등록
		for (int categoryId : categoryIds) {
			MemberCategoryVO mcvo = new MemberCategoryVO();
			mcvo.setMember_idx(vo.getMember_idx());
			mcvo.setCategory_id(categoryId);
			mcdao.insertMemberCategory(mcvo);
		}
	}
}
