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
}
