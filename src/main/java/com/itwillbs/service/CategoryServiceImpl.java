package com.itwillbs.service;

import java.util.List;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.itwillbs.domain.CategoryVO;
import com.itwillbs.persistence.CategoryDAO;

@Service
public class CategoryServiceImpl implements CategoryService {

	// 로거 선언
	private static final Logger logger = LoggerFactory.getLogger(CategoryServiceImpl.class);

	@Inject
	private CategoryDAO categoryDAO;

	// 전체 카테고리 목록 조회 (회원가입 등에서 사용됨)
	@Override
	public List<CategoryVO> getCategoryList() {
		logger.info(" CategoryServiceImpl: getCategoryList() 호출");

		List<CategoryVO> categoryList = categoryDAO.getCategoryList();

		if (categoryList == null || categoryList.isEmpty()) {
			logger.warn(" categoryList가 비어있음!");
		} else {
			logger.info(" 첫 번째 카테고리: {}", categoryList.get(0));
		}

		return categoryList;
	}

	// 회원의 관심 카테고리 목록 조회 (member_idx 기준)
	// info.jsp에서 사용됨 - 선택한 카테고리들의 '이름'을 보여주기 위해
	@Override
	public List<CategoryVO> getSelectedCategories(int member_idx) {
		logger.info("CategoryServiceImpl: getSelectedCategories({}) 호출", member_idx);

		List<CategoryVO> selectedList = categoryDAO.getSelectedCategories(member_idx);

		if (selectedList == null || selectedList.isEmpty()) {
			logger.warn("선택된 관심 카테고리가 없습니다!");
		} else {
			logger.info("첫 번째 관심 카테고리: {}", selectedList.get(0).getCategory_name_ko());
		}

		return selectedList;
	}

}
