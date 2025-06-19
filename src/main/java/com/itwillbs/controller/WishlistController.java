package com.itwillbs.controller;

import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.*;

import com.itwillbs.domain.MemberVO;
import com.itwillbs.domain.WishlistVO;
import com.itwillbs.service.WishlistService;

@RestController  // → @Controller + @ResponseBody
@RequestMapping("/wishlist")
public class WishlistController {

    private static final Logger logger = LoggerFactory.getLogger(WishlistController.class);

    @Inject
    private WishlistService wishlistService;

    // 📌 찜 상태 확인
    @PostMapping("/check")
    public Map<String, Object> checkWishlist(@RequestParam("book_id") int book_id, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");

        if (loginUser == null) {
            result.put("status", "not_logged_in");
            return result;
        }

        Map<String, Object> map = new HashMap<>();
        map.put("member_idx", loginUser.getMember_idx());
        map.put("book_id", book_id);

        int count = wishlistService.checkWishlist(map);
        result.put("status", "ok");
        result.put("isWishlisted", count > 0);

        return result;
    }

    // 📌 찜 등록
    @PostMapping("/add")
    public Map<String, Object> addWishlist(@RequestBody WishlistVO vo, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");

        if (loginUser == null) {
            result.put("status", "not_logged_in");
            return result;
        }

        vo.setMember_idx(loginUser.getMember_idx());
        wishlistService.insertWishlist(vo);

        result.put("status", "added");
        return result;
    }

    // 📌 찜 해제
    @PostMapping("/remove")
    public Map<String, Object> removeWishlist(@RequestBody WishlistVO vo, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");

        if (loginUser == null) {
            result.put("status", "not_logged_in");
            return result;
        }

        vo.setMember_idx(loginUser.getMember_idx());
        wishlistService.deleteWishlist(vo);

        result.put("status", "removed");
        return result;
    }
}
