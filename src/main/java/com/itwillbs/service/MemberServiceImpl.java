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

	// 서버 시간 조회
	@Override
	public String getServerTime() {
		return mdao.getServerTime();
	}

	// 로그인 체크 (아이디/비밀번호)
	@Override
	public MemberVO memberLoginCheck(MemberVO vo) {
		return mdao.memberLoginCheck(vo);
	}

	// 기본 회원가입 (단일 정보만 - 사용 안 함)
	@Override
	public void memberJoin(MemberVO vo) {
		mdao.insertMember(vo);
	}

	// 관심 카테고리 포함 회원가입
	@Override
	public void joinMemberWithCategory(MemberVO vo, List<Integer> categoryIds) {
		// ✅ 이메일 공백일 경우 null 처리
		if (vo.getMember_email() != null && vo.getMember_email().trim().isEmpty()) {
			vo.setMember_email(null);
		}
		// 1. 회원정보 등록
		mdao.insertMember(vo); // PK가 vo.getMember_idx()에 들어감

		// 2. 관심 카테고리 등록
		int member_idx = vo.getMember_idx();
		for (int cateId : categoryIds) {
			MemberCategoryVO mcvo = new MemberCategoryVO();
			mcvo.setMember_idx(member_idx);
			mcvo.setCategory_id(cateId);
			mcdao.insertMemberCategory(mcvo);
		}
	}

	// 닉네임으로 회원 조회
	@Override
	public MemberVO getMemberByNick(String member_nick) {
		return mdao.getMemberByNick(member_nick);
	}

	// 닉네임 중복 확인
	@Override
	public boolean checkNickname(String nickname) {
		return mdao.getMemberByNick(nickname) != null;
	}

	// 아이디 중복 확인
	@Override
	public boolean checkId(String member_id) {
		return mdao.getMember(member_id) != null;
	}

	// 아이디로 회원정보 조회 (마이페이지, 로그인용)
	@Override
	public MemberVO memberInfo(String member_id) {
		return mdao.getMember(member_id);
	}

	// 이메일로 회원 조회
	@Override
	public MemberVO memberInfoByEmail(String email) {
		return mdao.selectMemberByEmail(email);
	}

	// 휴대폰 번호로 회원 조회
	@Override
	public MemberVO memberInfoByPhone(String phone) {
		return mdao.selectMemberByPhone(phone);
	}

	// PK(member_idx)로 회원정보 조회
	@Override
	public MemberVO memberInfo(int member_idx) {
		return mdao.getMemberByIdx(member_idx);
	}

	// 회원정보 수정 (닉네임, 이메일 등)
	@Override
	public void memberUpdate(MemberVO uvo) {
		mdao.updateMember(uvo);
	}

	// 회원 탈퇴
	@Override
	public int memberDelete(MemberVO dvo) {
		return mdao.deleteMember(dvo);
	}

	// 회원정보 + 관심 카테고리 수정
	@Override
	public void updateMemberWithCategories(MemberVO vo, List<Integer> categoryIds) {
		// ✅ 이메일이 공백이면 null로 바꿔서 DB 중복 오류 방지
		if (vo.getMember_email() != null && vo.getMember_email().trim().isEmpty()) {
			vo.setMember_email(null);
		}

		// 1. 회원 기본 정보 수정
		mdao.updateMember(vo);

		// 2. 기존 카테고리 삭제
		mcdao.deleteMemberCategoryByMemberId(vo.getMember_idx());

		// 3. 새 카테고리 등록
		for (int categoryId : categoryIds) {
			MemberCategoryVO mcvo = new MemberCategoryVO();
			mcvo.setMember_idx(vo.getMember_idx());
			mcvo.setCategory_id(categoryId);
			mcdao.insertMemberCategory(mcvo);
		}
	}

	// 이름 + 휴대폰으로 아이디 찾기
	@Override
	public String findIdByNamePhone(String member_name, String member_phone) {
		return mdao.findIdByNamePhone(member_name, member_phone);
	}

	// 비밀번호 찾기
	@Override
	public String findPwByInfo(MemberVO vo) {
		return mdao.findPwByInfo(vo);
	}

	// 회원이 선택한 카테고리 ID 목록 조회
	@Override
	public List<Integer> getSelectedCategoryIds(int member_idx) {
		return mcdao.getCategoryIdsByMemberId(member_idx);
	}

	// 회원 고유번호로 회원정보 조회 (마이페이지 등에서 사용)
	@Override
	public MemberVO getMemberByIdx(int member_idx) {
		return mdao.getMemberByIdx(member_idx);
	}
}
