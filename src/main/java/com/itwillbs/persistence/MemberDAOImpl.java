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
// @Repository : 스프링(root-context.xml)이 해당 객체를
//               MemberDAO 객체로 인식하도록 설정

@Repository
public class MemberDAOImpl implements MemberDAO {

	// 디비 연결객체를 주입(DI)
	// private SqlSessionFactory sqlFactory
	// = new SqlSessionFactoryBean();
	@Inject
	private SqlSessionFactory sqlFactory;

	// 자동연결, 해제
	@Inject
	private SqlSession sqlSession;

	// mapper의 주소(namespace정보)
	private static final String NAMESPACE = "com.itwillbs.persistence.MemberDAO.";

	@Override
	public String getServerTime() {
		// 1. 드라이버 로드
		// 2. 디비연결
		// => sqlFactory 객체 주입 사용
		// SqlSession sqlSession = sqlFactory.openSession();
		System.out.println(" sqlSession : " + sqlSession);
		System.out.println(" 디비 연결 성공! ");

		// 3. SQL 구문 & pstmt 객체
		// 4. SQL 실행
		// sqlSession.selectOne("SQL 구문");
		// 5. 데이터 처리

		String result = sqlSession.selectOne("com.itwillbs.mapper.MemberMapper.getServerTime");
		System.out.println(" SQL 실행완료! ");
		System.out.println(" result (서버시간) : " + result);

		return result;
	}

	@Override
	public void insertMember(MemberVO vo) {
		System.out.println(" 회원 가입 실행! ");

		// SQL 구문을 호출해서 실행

		// 1. 드라이버로드
		// 2. 디비연결
		// => 생략, SqlSession객체로 처리
		// 3. SQL 구문 & pstmt 객체
		// 4. SQL 실행
		sqlSession.insert(NAMESPACE + "insertMember", vo);
		// com.itwillbs.mapper.MemberMapper.insertMember
		// -------------상수----------------|---id------|

	}

	@Override
	public MemberVO memberLoginCheck(MemberVO vo) {
		System.out.println(" memberLoginCheck(MemberVO vo) 실행 ");
		// 디비 연결 => sqlSession 객체 주입
		// SQL 구문 실행

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

		// sql 구문에 전달할 정보는 1개(객체)만 가능하다
		// sqlSession.selectOne(NAMESPACE + "loginCheck",userid,userpw);(x)
		MemberVO resultVO = sqlSession.selectOne(NAMESPACE + "loginCheck", vo);

		// VO객체로 한번에 저장이 불가능한 경우 (Join)
		// => Map 컬렉션 객체사용
		// => key,value의 쌍으로 정보를 저장하는 객체
		Map<String, Object> paramObject = new HashMap<String, Object>();

		// map에 정보 저장
		// paramObject.put("키값-mapper에 설정한 이름 #{이름}", 값);
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

		// resultVO.setUserid("asdasd");

		return resultVO;

		// return sqlSession.selectOne(NAMESPACE + "getMember",userid);
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
}
