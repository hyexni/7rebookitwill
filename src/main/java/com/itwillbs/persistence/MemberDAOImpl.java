package com.itwillbs.persistence;

import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.springframework.stereotype.Repository;

import com.itwillbs.domain.MemberVO;

/**
 * MemberDAO 인터페이스를 구현한 객체
 * 
 */

@Repository
public class MemberDAOImpl implements MemberDAO {

	@Inject
	private SqlSessionFactory sqlFactory;

	// 자동연결, 해제
	@Inject
	private SqlSession sqlSession;

	// mapper의 주소(namespace정보)
	private static final String NAMESPACE = "com.itwillbs.persistence.MemberDAO.";

	@Override
	public String getServerTime() {

		System.out.println(" sqlSession : " + sqlSession);
		System.out.println(" 디비 연결 성공! ");

		String result = sqlSession.selectOne("com.itwillbs.mapper.MemberMapper.getServerTime");
		System.out.println(" SQL 실행완료! ");
		System.out.println(" result (서버시간) : " + result);

		return result;
	}

	@Override
	public void insertMember(MemberVO vo) {
		System.out.println(" 회원 가입 실행! ");

		sqlSession.insert(NAMESPACE + "insertMember", vo);

	}

	@Override
	public MemberVO memberLoginCheck(MemberVO vo) {
		System.out.println(" memberLoginCheck(MemberVO vo) 실행 ");

		MemberVO resultVO = sqlSession.selectOne(NAMESPACE + "loginCheck", vo);
		System.out.println(" SQL 구문 실행완료! ");

		return resultVO;
	}

	@Override
	public MemberVO memberLoginCheck(String member_id, String member_pw) {
		System.out.println(" memberLoginCheck(String member_id, String member_pw) 호출 ");

		MemberVO vo = new MemberVO();
		vo.setMember_id(member_id);
		vo.setMember_pw(member_pw);

		MemberVO resultVO = sqlSession.selectOne(NAMESPACE + "loginCheck", vo);

		Map<String, Object> paramObject = new HashMap<String, Object>();

		paramObject.put("member_id", member_id);
		paramObject.put("member_pw", member_pw);

		MemberVO resultVO2 = sqlSession.selectOne(NAMESPACE + "loginCheck", paramObject);

		return resultVO;
	}

	@Override
	public MemberVO getMember(String member_id) {
		System.out.println("  getMember(String userid) 실행 ");

		MemberVO resultVO = sqlSession.selectOne(NAMESPACE + "getMember", member_id);
		System.out.println(" SQL 실행 완료! ");

		return resultVO;

	}

	@Override
	public void updateMember(MemberVO uvo) {
		System.out.println(" updateMember(MemberVO uvo) 실행 ");

		// SQL 실행
		sqlSession.update(NAMESPACE + "updateMember", uvo);
	}

	@Override
	public int deleteMember(MemberVO dvo) {
		System.out.println("deleteMember(MemberVO dvo) 실행");

		int result = sqlSession.delete(NAMESPACE + "deleteMember", dvo);

		return result;
	}

	// 회원 고유번호(member_idx)로 회원 정보 조회 구현
	@Override
	public MemberVO getMemberByIdx(int member_idx) {
		return sqlSession.selectOne(NAMESPACE + ".getMemberByIdx", member_idx);
	}

	// 닉네임 조회
	@Override
	public MemberVO getMemberByNick(String member_nick) {
		return sqlSession.selectOne(NAMESPACE + ".getMemberByNick", member_nick);
	}

	// 이메일 조회
	@Override
	public MemberVO selectMemberByEmail(String email) {
		return sqlSession.selectOne(NAMESPACE + ".selectMemberByEmail", email);
	}

	// 전화번호 조회
	@Override
	public MemberVO selectMemberByPhone(String phone) {
		return sqlSession.selectOne(NAMESPACE + ".selectMemberByPhone", phone);
	}

	// 아이디찾기
	@Override
	public String findIdByNamePhone(String member_name, String member_phone) {
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("member_name", member_name);
		paramMap.put("member_phone", member_phone);

		return sqlSession.selectOne(NAMESPACE + ".findIdByNamePhone", paramMap);
	}

	// 비밀번호 찾기
	@Override
	public String findPwByInfo(MemberVO vo) {
		return sqlSession.selectOne(NAMESPACE + ".findPwByInfo", vo);
	}
}
