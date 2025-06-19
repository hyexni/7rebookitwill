package com.itwillbs.persistence;

import java.util.Map;

import com.itwillbs.domain.WishlistVO;

public interface WishlistDAO {

    // 찜 여부 확인 (있으면 1, 없으면 0)
    int checkWishlist(Map<String, Object> map);

    // 찜 등록
    void insertWishlist(WishlistVO vo);

    // 찜 해제
    void deleteWishlist(WishlistVO vo);
}