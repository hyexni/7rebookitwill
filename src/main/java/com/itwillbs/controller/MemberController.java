package com.itwillbs.controller;

import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam; // @RequestParam 추가
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes; // RedirectAttributes 추가

import com.itwillbs.domain.MemberVO;
import com.itwillbs.service.CategoryService;
import com.itwillbs.service.MemberService;

@Controller
@RequestMapping(value = "/member/*")
public class MemberController {

	// 회원 처리 로직
	@Inject
	private MemberService mService;

	// 카테고리 목록 조회용
	@Inject
	private CategoryService categoryService;

	// mylog 단축어
	private static final Logger logger = LoggerFactory.getLogger(MemberController.class);

	@RequestMapping(value = "/join", method = RequestMethod.GET)
	public String memberJoinGET(Model model) {
		logger.info("memberJoinGET() 실행 ");

		// 카테고리 목록 가져오기
		model.addAttribute("categoryList", categoryService.getCategoryList());

		return "/member/join"; // 뷰페이지 경로 반환
	}

	@RequestMapping(value = "/join", method = RequestMethod.POST)
	public String memberJoinPOST(MemberVO vo, @RequestParam("category_ids") List<Integer> categoryIds,
			RedirectAttributes rttr) {
		logger.info("memberJoinPOST() 실행 ");
		logger.info("vo : " + vo);
		logger.info("선택한 카테고리 : " + categoryIds);

		// 1. 회원가입 처리 + 카테고리 저장
		mService.joinMemberWithCategory(vo, categoryIds);

		// 2. 완료 메시지
		rttr.addFlashAttribute("message", "회원가입 완료!");

		return "redirect:/member/login";
	}

	// 아이디 중복확인 (AJAX용)
	@RequestMapping(value = "/checkId", method = RequestMethod.POST)
	@ResponseBody
	public String checkId(@RequestParam("member_id") String member_id) {
		logger.info("checkId() 호출 - " + member_id);
		MemberVO vo = mService.memberInfo(member_id);
		return (vo == null) ? "OK" : "DUPLICATE";
	}

	// 닉네임 중복확인 (AJAX용)
	@RequestMapping(value = "/checkNickname", method = RequestMethod.POST)
	@ResponseBody
	public String checkNickname(@RequestParam("nickname") String nickname) {
		logger.info("checkNickname() 호출 - " + nickname);
		boolean isExist = mService.checkNickname(nickname);
		return isExist ? "DUPLICATE" : "OK";
	}

	// 이메일 중복 확인 (선택 입력이므로, 입력값 없으면 OK)
	@PostMapping("/checkEmail")
	@ResponseBody
	public String checkEmail(@RequestParam("member_email") String member_email) {
		logger.info("📧 checkEmail() 호출 - " + member_email);

		if (member_email == null || member_email.trim().isEmpty()) {
			return "OK"; // 입력 안 했으면 그냥 OK
		}

		MemberVO dbMember = mService.memberInfoByEmail(member_email);
		return (dbMember == null) ? "OK" : "DUPLICATE";
	}

	// 휴대폰 중복확인
	@RequestMapping(value = "/checkPhone", method = RequestMethod.POST)
	@ResponseBody
	public String checkPhone(@RequestParam("phone") String phone) {
		logger.info("checkPhone() 호출 - " + phone);
		MemberVO vo = mService.memberInfoByPhone(phone);
		return (vo == null) ? "OK" : "DUPLICATE";
	}

	// 로그인 페이지 GET
	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public String memberLoginGET() {
		logger.info("memberLoginGET() 실행");
		return "member/login"; // login.jsp
	}

	// 로그인 페이지 POST
	// http://localhost:8088/member/login POST방식 호출
	@RequestMapping(value = "/login", method = RequestMethod.POST)
	public String memberLoginPOST(@RequestParam("member_id") String id, // MemberVO로 받지 않고 id, pw를 직접 파라미터로 받음
			@RequestParam("member_pw") String pw, HttpSession session, RedirectAttributes rttr // RedirectAttributes 추가
																								// (메시지 전달용)
	) {
		logger.info(" memberLoginPOST() 실행 ");

		// 폼태그로 전달된 데이터(member_id,member_pw)를 저장
		// MemberVO vo 객체 생성 및 데이터 설정
		MemberVO vo = new MemberVO();
		vo.setMember_id(id); // MemberVO의 필드명에 맞게 설정 (member_id -> member_id)
		vo.setMember_pw(pw); // MemberVO의 필드명에 맞게 설정 (member_pw -> member_pw)

		logger.info(" 로그인 시도 vo : " + vo);

		// 로그인 여부를 체크
		// 서비스 -> DAO 로그인 체크하는 메서드
		// MemberVO의 필드명이 Member_id, Member_pw라면 서비스/DAO도 그렇게 동작해야 합니다.
		MemberVO resultVO = mService.memberLoginCheck(vo);

		// 결과에 따른 페이지 이동
		// 성공 - 메인페이지로 이동
		// 실패 - 다시 로그인페이지로 이동
		if (resultVO == null) {
			rttr.addFlashAttribute("message", "아이디 또는 비밀번호가 일치하지 않습니다."); // 메시지 추가
			return "redirect:/member/login"; // 로그인 실패 시 로그인 폼으로 리다이렉트
		}

		// 로그인 성공시 세션영역에 아이디 및 회원 고유 번호 저장
		session.setAttribute("id", resultVO.getMember_id()); // 로그인 ID
		session.setAttribute("member_idx", resultVO.getMember_idx()); // 회원 고유 번호 (포인트 내역 조회에 필요)

		logger.info("로그인 성공! 회원 ID: {}, 회원 고유 번호: {}", resultVO.getMember_id(), resultVO.getMember_idx());

		// ==== 추가된 부분 시작 ====
		// 세션에 저장된 리다이렉트 대상 URL 확인
		String redirectUrl = (String) session.getAttribute("redirectAfterLogin");
		if (redirectUrl != null && !redirectUrl.isEmpty()) {
			session.removeAttribute("redirectAfterLogin"); // 사용했으니 세션에서 제거
			logger.info("저장된 URL로 리다이렉트: {}", redirectUrl);
			return "redirect:" + redirectUrl; // 저장된 URL로 리다이렉트
		}
		// ==== 추가된 부분 끝 ====

		// 저장된 URL이 없거나 로그인 후 원래 가려고 했던 페이지가 없는 경우, 기본 성공 페이지로 이동
		rttr.addFlashAttribute("message", resultVO.getMember_id() + "님, 환영합니다!"); // 환영 메시지
		return "redirect:/member/main"; // 기본 메인 페이지로 이동
	}

	// http://localhost:8088/member/main
	// 메인 페이지 /member/main GET
	@RequestMapping(value = "/main", method = RequestMethod.GET)
	public void memberMainGET() {
		logger.info(" memberMainGET() 실행 ");
		logger.info(" /member/main.jsp 뷰페이지 ");
	}

	// 로그아웃 /member/logout GET/POST
	@RequestMapping(value = "/logout", method = RequestMethod.GET)
	public String memberLogoutGET(HttpSession session, RedirectAttributes rttr) { // RedirectAttributes 추가
		logger.info(" memberLogoutGET() 실행 ");

		// 사용자의 세션정보(id) 초기화
		session.invalidate();

		rttr.addFlashAttribute("message", "로그아웃 되었습니다."); // 로그아웃 메시지 추가
		// 다시 메인페이지로 이동

		return "redirect:/member/main";
	}

	// 회원정보 조회(마이페이지) /member/info GET
	@RequestMapping(value = "/info", method = RequestMethod.GET)
	public String memberInfoGET(HttpSession session, Model model) {
		logger.info(" memberInfoGET() 실행 ");

		// 사용자의 로그인 정보를 체크(세션)
		String id = (String) session.getAttribute("id");
		if (id == null) {
			// 로그인 정보가 없을경우 다시 로그인페이지로 이동
			return "redirect:/member/login";
		}

		// 사용자 로그인 정보가 있음
		// 서비스 -> DAO호출 (회원정보를 조회기능)
		MemberVO resultVO = mService.memberInfo(id);

		// DB에서 가져온 정보를 뷰페이지로 전달
		// model.addAttribute("resultVO",resultVO);
		model.addAttribute(resultVO);

		logger.info(" /views/member/info.jsp 페이지 출력");
		return "/member/info";
	}

	// 회원정보 수정 /member/update GET
	// (기존의 정보를 보여주기)
	@RequestMapping(value = "/update", method = RequestMethod.GET)
	public String memberUpdateGET(HttpSession session, Model model) {
		logger.info(" memberUpdateGET() 실행 ");

		// 사용자가 로그인 여부 체크 (세션)
		String id = (String) session.getAttribute("id");
		if (id == null) {
			return "redirect:/member/login";
		}
		// 세션정보(아이디)를 기존의 정보를 불러와서 출력
		// MemberVO resultVO = mService.memberInfo(id);
		// model.addAttribute(resultVO);

		model.addAttribute(mService.memberInfo(id));
		model.addAttribute("categoryList", categoryService.getCategoryList());

		logger.info(" /member/update.jsp 페이지 연결 ");
		return "/member/update";
	}

	// 회원정보 수정 /member/update POST
	@RequestMapping(value = "/update", method = RequestMethod.POST)
	public String memberUpdatePOST(MemberVO uvo, @RequestParam("category_ids") List<Integer> categoryIds,
			HttpSession session) {
		logger.info(" memberUpdatePOST() 실행 ");
		logger.info(" uvo : {}", uvo);
		logger.info(" 선택한 카테고리 : {}", categoryIds);

		// 로그인한 회원 고유 번호 세션에서 꺼내기
		Integer member_idx = (Integer) session.getAttribute("member_idx");
		uvo.setMember_idx(member_idx);

		// 서비스 호출 - 회원 정보 + 카테고리 함께 수정
		mService.updateMemberWithCategories(uvo, categoryIds);

		return "redirect:/member/main";
	}

}// controller