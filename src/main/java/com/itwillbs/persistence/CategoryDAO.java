package com.itwillbs.persistence;

import java.util.List;

import com.itwillbs.domain.CategoryVO;

/**
 * 카테고리 관련 DB 접근 인터페이스
 */
public interface CategoryDAO {
	List<CategoryVO> getCategoryList(); // 전체 카테고리 목록 조회
}