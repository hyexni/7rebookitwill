package com.itwillbs.persistence;

import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.itwillbs.domain.CategoryVO;

@Repository // 꼭 필요함 (Bean 등록)
public class CategoryDAOImpl implements CategoryDAO {

	@Inject
	private SqlSession sqlSession;

	private static final String NAMESPACE = "com.itwillbs.mapper.CategoryMapper";

	// [카테고리 목록 조회]
	@Override
	public List<CategoryVO> getCategoryList() {
		return sqlSession.selectList(NAMESPACE + ".getCategoryList");
	}

	// 🔸 회원의 관심 카테고리 이름 목록 조회 (JOIN 사용)
	@Override
	public List<CategoryVO> getSelectedCategories(int member_idx) {
		return sqlSession.selectList(NAMESPACE + ".getSelectedCategories", member_idx);
	}
}