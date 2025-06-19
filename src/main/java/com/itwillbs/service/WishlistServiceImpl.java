package com.itwillbs.service;

import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.itwillbs.domain.WishlistVO;
import com.itwillbs.persistence.WishlistDAO;

@Service
public class WishlistServiceImpl implements WishlistService {

    @Inject
    private WishlistDAO wishlistDAO;

    @Override
    public int checkWishlist(Map<String, Object> map) {
        return wishlistDAO.checkWishlist(map);
    }

    @Override
    public void insertWishlist(WishlistVO vo) {
        wishlistDAO.insertWishlist(vo);
    }

    @Override
    public void deleteWishlist(WishlistVO vo) {
        wishlistDAO.deleteWishlist(vo);
    }
}