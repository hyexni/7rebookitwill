package com.itwillbs.persistence;

import java.util.List;

import com.itwillbs.domain.CategoryVO;

/**
 * 카테고리 관련 DB 접근 인터페이스
 */
public interface CategoryDAO {
	// 전체 카테고리 목록 조회
	List<CategoryVO> getCategoryList();

	// 🔸 회원의 관심 카테고리 이름 목록 조회
	List<CategoryVO> getSelectedCategories(int member_idx);
}