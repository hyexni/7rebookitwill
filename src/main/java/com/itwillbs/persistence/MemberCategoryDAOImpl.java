package com.itwillbs.persistence;

import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.itwillbs.domain.MemberCategoryVO;

@Repository
public class MemberCategoryDAOImpl implements MemberCategoryDAO {

	// mapper 네임스페이스
	private static final String NAMESPACE = "com.itwillbs.mapper.MemberCategoryMapper.";

	// MyBatis의 SqlSession 객체 주입
	@Inject
	private SqlSession sqlSession;

	// 관심 카테고리 저장
	@Override
	public void insertMemberCategory(MemberCategoryVO vo) {
		sqlSession.insert(NAMESPACE + "insertMemberCategory", vo);
	}

	// 회원별 관심 카테고리 목록 조회
	@Override
	public List<MemberCategoryVO> getCategoryListByMember(int member_idx) {
		return sqlSession.selectList(NAMESPACE + ".getCategoryListByMember", member_idx);
	}

	// 회원 관심 카테고리 전체 삭제 (수정 전에 비우기)
	@Override
	public void deleteMemberCategoryByMemberId(int member_idx) {
		sqlSession.delete(NAMESPACE + ".deleteMemberCategoryByMemberId", member_idx);
	}

	// 추천 기능용: 회원 관심 카테고리 ID만 가져오기
	@Override
	public List<Integer> getCategoryIdsByMemberId(int member_idx) {
		return sqlSession.selectList(NAMESPACE + ".getCategoryIdsByMemberId", member_idx);
	}
}
