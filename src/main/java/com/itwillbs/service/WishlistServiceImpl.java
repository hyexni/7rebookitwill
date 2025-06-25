package com.itwillbs.service;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.itwillbs.domain.WishlistVO;
import com.itwillbs.dto.WishlistBookDTO; // DTO import 추가
import com.itwillbs.persistence.WishlistDAO;

@Service
public class WishlistServiceImpl implements WishlistService {

	@Inject
	private WishlistDAO wishlistDAO;

	// 1. 찜 중복 확인
	@Override
	public int checkWishlist(Map<String, Object> map) {
		return wishlistDAO.checkWishlist(map);
	}

	// 2. 찜 추가
	@Override
	public void insertWishlist(WishlistVO vo) {
		wishlistDAO.insertWishlist(vo);
	}

	// 3. 찜 삭제
	@Override
	public int deleteWishlist(WishlistVO vo) {
		return wishlistDAO.deleteWishlist(vo);
	}

	// 4. 찜 목록 조회
	@Override
	public List<WishlistBookDTO> getWishlistByMember(int member_idx) {
		return wishlistDAO.getWishlistByMember(member_idx);
	}
	
	// 페이징처리 
	@Override
	public List<WishlistBookDTO> getWishlistByPage(int member_idx, int startRow, int size) {
	    return wishlistDAO.getWishlistByPage(member_idx, startRow, size);
	}

	@Override
	public int getWishlistCount(int member_idx) {
	    return wishlistDAO.getWishlistCount(member_idx);
	}
}
