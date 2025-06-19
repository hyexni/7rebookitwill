package com.itwillbs.service;

import java.util.Map;

import com.itwillbs.domain.WishlistVO;

public interface WishlistService {

    // 찜 여부 확인
    int checkWishlist(Map<String, Object> map);

    // 찜 등록
    void insertWishlist(WishlistVO vo);

    // 찜 해제
    void deleteWishlist(WishlistVO vo);
}