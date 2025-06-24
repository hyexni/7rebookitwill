package com.itwillbs.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.itwillbs.domain.MemberVO;
import com.itwillbs.domain.WishlistVO;
import com.itwillbs.dto.WishlistBookDTO;
import com.itwillbs.service.WishlistService;

@Controller
@RequestMapping("/wishlist")
public class WishlistController {

	private static final Logger logger = LoggerFactory.getLogger(WishlistController.class);

	@Inject
	private WishlistService wishlistService;

	// ✅ 로그인 유저 가져오기 (중복 제거용)
	private MemberVO getLoginUser(HttpSession session) {
		MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
		if (loginUser == null) {
			throw new IllegalStateException("로그인이 필요합니다.");
		}
		return loginUser;
	}

	// 1. 찜 목록 보기
	@GetMapping("/list")
	public String getWishlist(HttpSession session, Model model) {
		logger.info("WishlistController: GET /wishlist/list");

		try {
			MemberVO loginUser = getLoginUser(session);
			List<WishlistBookDTO> wishlist = wishlistService.getWishlistByMember(loginUser.getMember_idx());
			logger.info("찜 목록 개수: {}", wishlist.size());
			model.addAttribute("wishlist", wishlist);
			return "/wishlist/list";
		} catch (IllegalStateException e) {
			return "redirect:/member/login";
		}
	}

	// 2. 찜 추가
	@PostMapping("/add")
	@ResponseBody
	public Map<String, String> addWishlist(@RequestBody WishlistVO vo, HttpSession session) {
		logger.info("WishlistController: POST /wishlist/add");

		Map<String, String> result = new HashMap<>();
		try {
			MemberVO loginUser = getLoginUser(session);
			vo.setMember_idx(loginUser.getMember_idx());

			Map<String, Object> map = new HashMap<>();
			map.put("member_idx", vo.getMember_idx());
			map.put("book_id", vo.getBook_id());

			int exists = wishlistService.checkWishlist(map);
			if (exists == 0) {
				wishlistService.insertWishlist(vo);
				result.put("status", "added");
			} else {
				result.put("status", "already_added");
			}
		} catch (IllegalStateException e) {
			result.put("status", "not_logged_in");
		} catch (Exception e) {
			logger.error("찜 추가 중 예외 발생", e);
			result.put("status", "error");
		}
		return result;
	}

	// 3. 찜 삭제
	@PostMapping("/delete")
	@ResponseBody
	public Map<String, String> deleteWishlist(@RequestBody WishlistVO vo, HttpSession session) {
		logger.info("WishlistController: POST /wishlist/delete");

		Map<String, String> result = new HashMap<>();
		try {
			MemberVO loginUser = getLoginUser(session);
			vo.setMember_idx(loginUser.getMember_idx());

			int deleted = wishlistService.deleteWishlist(vo);
			if (deleted > 0) {
				result.put("status", "deleted");
			} else {
				result.put("status", "not_found");
			}
		} catch (IllegalStateException e) {
			result.put("status", "not_logged_in");
		} catch (Exception e) {
			logger.error("찜 삭제 중 예외 발생", e);
			result.put("status", "error");
		}
		return result;
	}

	// 4. 찜 여부 확인
	@PostMapping("/check")
	@ResponseBody
	public Map<String, Object> checkWishlist(@RequestBody Map<String, Object> param, HttpSession session) {
		logger.info("WishlistController: POST /wishlist/check");

		Map<String, Object> result = new HashMap<>();
		result.put("status", "ok");
		result.put("isWishlisted", false);

		try {
			MemberVO loginUser = getLoginUser(session);

			int book_id = Integer.parseInt((String) param.get("book_id")); // ✅ 수정!
			logger.info("💖 찜 확인 요청 - book_id: {}", book_id);
			logger.info("💖 로그인 유저 member_idx: {}", loginUser.getMember_idx());

			Map<String, Object> map = new HashMap<>();
			map.put("member_idx", loginUser.getMember_idx());
			map.put("book_id", book_id);

			boolean isExist = wishlistService.checkWishlist(map) > 0;
			result.put("isWishlisted", isExist);
		} catch (Exception e) {
			logger.error("찜 여부 확인 중 예외 발생", e);
			result.put("status", "error");
		}

		return result;
	}
}
