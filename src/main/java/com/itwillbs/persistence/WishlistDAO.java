package com.itwillbs.persistence;

import java.util.List;
import java.util.Map;

import com.itwillbs.domain.WishlistVO;
import com.itwillbs.dto.WishlistBookDTO;

public interface WishlistDAO {

	// 1. 찜 여부 확인 (있으면 1, 없으면 0)
	int checkWishlist(Map<String, Object> map);

	// 2. 찜 등록
	void insertWishlist(WishlistVO vo);

	// 3. 찜 해제
	int deleteWishlist(WishlistVO vo);

	// 4. 회원별 찜 목록 조회 (DTO 리스트로 반환)
	List<WishlistBookDTO> getWishlistByMember(int member_idx);
}