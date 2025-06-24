package com.itwillbs.service;

import java.util.List;

import com.itwillbs.domain.CategoryVO;

public interface CategoryService {

	// 전체 카테고리 목록 (회원가입 폼 등에 사용)
	List<CategoryVO> getCategoryList();

	// 회원의 관심 카테고리 이름 목록 조회 (member_idx 기준)
	List<CategoryVO> getSelectedCategories(int member_idx);
}