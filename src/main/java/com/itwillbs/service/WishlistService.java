package com.itwillbs.service;

import java.util.List;
import java.util.Map;

import com.itwillbs.domain.WishlistVO;
import com.itwillbs.dto.WishlistBookDTO; // DTO import 추가

public interface WishlistService {

	// 1. 찜 중복 확인
	int checkWishlist(Map<String, Object> map);

	// 2. 찜 추가
	void insertWishlist(WishlistVO vo);

	// 3. 찜 삭제
	int deleteWishlist(WishlistVO vo);

	// 4. 찜 목록 조회 (회원별) - DTO 리스트 반환
	List<WishlistBookDTO> getWishlistByMember(int member_idx);
}
