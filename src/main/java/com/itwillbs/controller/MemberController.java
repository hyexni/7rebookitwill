package com.itwillbs.controller;

import java.util.List;
import java.util.stream.Collectors;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.itwillbs.domain.CategoryVO;
import com.itwillbs.domain.MemberVO;
import com.itwillbs.service.CategoryService;
import com.itwillbs.service.MemberService;
import com.itwillbs.service.PointHistoryService;

@Controller
@RequestMapping("/member")
public class MemberController {

	@Inject
	private MemberService mService;

	@Inject
	private CategoryService categoryService;

	@Inject
	private PointHistoryService pointHistoryService; // 이걸로 써야 돼!

	private static final Logger logger = LoggerFactory.getLogger(MemberController.class);

	// 회원가입 GET
	@GetMapping("/join")
	public String memberJoinGET(Model model) {
		logger.info("memberJoinGET() 실행");
		model.addAttribute("categoryList", categoryService.getCategoryList());
		return "/member/join";
	}

	// 회원가입 POST
	@PostMapping("/join")
	public String memberJoinPOST(MemberVO vo, @RequestParam("category_ids") List<Integer> categoryIds,
			RedirectAttributes rttr) {
		logger.info("memberJoinPOST() 실행 : {}", vo);
		// ✅ 백엔드 유효성 검사 추가: 카테고리 최소 2개 선택
		if (categoryIds == null || categoryIds.size() < 2) {
			rttr.addFlashAttribute("msg", "관심 카테고리는 최소 2개 이상 선택해야 합니다.");
			rttr.addFlashAttribute("icon", "warning");
			return "redirect:/member/join";
		}
		mService.joinMemberWithCategory(vo, categoryIds);
		rttr.addFlashAttribute("msg", "회원가입 완료!");
		rttr.addFlashAttribute("icon", "success");
		return "redirect:/member/login";
	}

	// 중복확인 (아이디, 닉네임, 이메일, 휴대폰)
	@PostMapping("/checkId")
	@ResponseBody
	public String checkId(@RequestParam("member_id") String member_id) {
		return (mService.memberInfo(member_id) == null) ? "OK" : "DUPLICATE";
	}

	@PostMapping("/checkNickname")
	@ResponseBody
	public String checkNickname(@RequestParam("nickname") String nickname, HttpSession session) {
		MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");

		MemberVO vo = mService.getMemberByNick(nickname); // 📌 해당 닉네임을 가진 회원 조회

		if (vo == null)
			return "OK";

		// 내 닉네임이면 OK
		if (loginUser != null && vo.getMember_id().equals(loginUser.getMember_id()))
			return "OK";

		return "DUPLICATE";
	}

	@PostMapping("/checkEmail")
	@ResponseBody
	public String checkEmail(@RequestParam("member_email") String email, HttpSession session) {
		if (email == null || email.trim().isEmpty())
			return "OK";

		MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");

		MemberVO vo = mService.memberInfoByEmail(email); // 📌 해당 이메일을 가진 회원 조회

		if (vo == null)
			return "OK";

		// 내 이메일이면 OK
		if (loginUser != null && vo.getMember_id().equals(loginUser.getMember_id()))
			return "OK";

		return "DUPLICATE";
	}

	@PostMapping("/checkPhone")
	@ResponseBody
	public String checkPhone(@RequestParam("phone") String phone, HttpSession session) {
		MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");

		// DB에서 해당 번호 가진 사람 찾기
		MemberVO vo = mService.memberInfoByPhone(phone);

		// 1. 아무도 이 번호 안 쓰고 있으면 OK
		if (vo == null)
			return "OK";

		// 2. 나 자신이면 OK
		if (loginUser != null && vo.getMember_id().equals(loginUser.getMember_id()))
			return "OK";

		// 3. 다른 사람이 쓰는 번호면 DUPLICATE
		return "DUPLICATE";
	}

	// 로그인
	@GetMapping("/login")
	public String memberLoginGET() {
		return "member/login";
	}

	@PostMapping("/login")
	public String memberLoginPOST(@RequestParam("member_id") String id, @RequestParam("member_pw") String pw,
			HttpSession session, RedirectAttributes rttr) {
		MemberVO vo = new MemberVO();
		vo.setMember_id(id);
		vo.setMember_pw(pw);

		MemberVO resultVO = mService.memberLoginCheck(vo);
		if (resultVO == null) {
			rttr.addFlashAttribute("message", "아이디 또는 비밀번호가 일치하지 않습니다.");
			return "redirect:/member/login";
		}
    
		// 로그인 성공시 세션영역에 아이디 및 회원 고유 번호 저장
		session.setAttribute("id", resultVO.getMember_id()); // 로그인 ID
		session.setAttribute("member_idx", resultVO.getMember_idx()); // 회원 고유 번호 (포인트 내역 조회에 필요)
		session.setAttribute("loginUser", resultVO); // ✅ VO 통째로 저장

		String redirectUrl = (String) session.getAttribute("redirectAfterLogin");
		if (redirectUrl != null) {
			session.removeAttribute("redirectAfterLogin");
			return "redirect:" + redirectUrl;
		}

		rttr.addFlashAttribute("msg", resultVO.getMember_id() + "님, 환영합니다!");
		return "redirect:/";
	}

	// 로그아웃
	@GetMapping("/logout")
	public String memberLogoutGET(HttpSession session, RedirectAttributes rttr) {
		session.invalidate();
		rttr.addFlashAttribute("message", "로그아웃 되었습니다.");
		return "redirect:/member/main";
	}

	@GetMapping("/main")
	public String mypageMain(HttpSession session, Model model, RedirectAttributes rttr) {
		MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");

		if (loginUser == null) {
			rttr.addFlashAttribute("msg", "로그인 후 이용해주세요!");
			rttr.addFlashAttribute("icon", "warning");
			return "redirect:/member/login";
		}

		int member_idx = loginUser.getMember_idx();

		try {
			int totalPoint = pointHistoryService.getTotalPoints(member_idx); // ✅ 요거!
			model.addAttribute("totalPoint", totalPoint);
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("totalPoint", 0); // 혹시 예외 발생 시 대비
		}

		return "/member/main";
	}

	// 마이페이지 (회원정보 조회)
	@GetMapping("/info")
	public String memberInfoGET(HttpSession session, Model model) {
		Integer member_idx = (Integer) session.getAttribute("member_idx");
		if (member_idx == null)
			return "redirect:/member/login";

		// 회원 정보 조회
		MemberVO resultVO = mService.getMemberByIdx(member_idx);

		// ✅ 관심 카테고리 조회
		List<CategoryVO> categoryList = categoryService.getSelectedCategories(member_idx);

		// 모델에 담기
		model.addAttribute("memberVO", resultVO);
		model.addAttribute("categoryList", categoryList); // ✅ 추가!

		return "/member/info";
	}

	// 회원정보 수정 폼
	@GetMapping("/update")
	public String memberUpdateGET(HttpSession session, Model model) {
		Integer member_idx = (Integer) session.getAttribute("member_idx");
		if (member_idx == null)
			return "redirect:/member/login";

		MemberVO memberVO = mService.getMemberByIdx(member_idx);
		model.addAttribute("memberVO", memberVO);
		model.addAttribute("categoryList", categoryService.getCategoryList());

		// 관심 카테고리 ID 리스트 -> 문자열로 변환해서 넘김
		List<Integer> selectedCategoryIds = mService.getSelectedCategoryIds(member_idx);
		List<String> selectedCategoryStrIds = selectedCategoryIds.stream().map(String::valueOf)
				.collect(Collectors.toList());

		model.addAttribute("selectedCategoryIds", selectedCategoryStrIds);

		return "/member/update";
	}

	// 회원정보 수정 처리
	@PostMapping("/update")
	public String memberUpdatePOST(@RequestParam("current_pw") String current_pw,
			@RequestParam(value = "new_pw", required = false) String new_pw, MemberVO uvo,
			@RequestParam("category_ids") List<Integer> categoryIds, HttpSession session, Model model,
			RedirectAttributes rttr) {

		Integer member_idx = (Integer) session.getAttribute("member_idx");
		if (member_idx == null) {
			return "redirect:/member/login";
		}

		uvo.setMember_idx(member_idx);

		// 🔸 관심 카테고리 2개 이상 유효성 검사
		if (categoryIds == null || categoryIds.size() < 2) {
			model.addAttribute("msg", "관심 카테고리는 최소 2개 이상 선택해야 합니다.");
			model.addAttribute("memberVO", uvo); // 입력값 유지
			model.addAttribute("selectedCategoryIds", categoryIds);
			model.addAttribute("categoryList", categoryService.getCategoryList());
			return "/member/update";
		}

		// 🔸 현재 비밀번호 확인
		MemberVO dbVO = mService.getMemberByIdx(member_idx);
		if (!dbVO.getMember_pw().equals(current_pw)) {
			// ❗ 입력값 유지하지 않고 새로고침 효과 주기
			rttr.addFlashAttribute("msg", "현재 비밀번호가 일치하지 않습니다.");
			rttr.addFlashAttribute("icon", "error");
			return "redirect:/member/update";
		}

		// 🔸 새 비밀번호 처리
		boolean pwChanged = (new_pw != null && !new_pw.trim().isEmpty());
		uvo.setMember_pw(pwChanged ? new_pw : current_pw);

		// 🔸 정보 수정
		mService.updateMemberWithCategories(uvo, categoryIds);

		// 🔸 닉네임 세션 갱신
		session.setAttribute("nick", uvo.getMember_nick());

		// 🔸 성공 메시지
		if (pwChanged) {
			rttr.addFlashAttribute("msg", "비밀번호를 포함한 정보가 수정되었습니다.");
			rttr.addFlashAttribute("icon", "success");
		} else {
			rttr.addFlashAttribute("msg", "회원 정보가 수정되었습니다.");
			rttr.addFlashAttribute("icon", "success");
		}

		// 🔸 마이페이지로 이동
		return "redirect:/member/main";
	}

	// 아이디 찾기 페이지
	@GetMapping("/findId")
	public String goFindIdPage() {
		return "/member/findId";
	}

	// 아이디 찾기 처리
	@GetMapping("/findIdByPhone")
	public String findIdByPhone(@RequestParam("member_name") String name, @RequestParam("member_phone") String phone,
			Model model) {
		String member_id = mService.findIdByNamePhone(name, phone);
		if (member_id != null)
			model.addAttribute("resultId", member_id);
		else
			model.addAttribute("msg", "일치하는 회원 정보가 없습니다.");

		return "/member/findIdResult";
	}

	// 비밀번호 찾기 페이지
	@GetMapping("/findPw")
	public String goFindPwPage() {
		return "/member/findPw";
	}

	// 비밀번호 찾기 처리
	@PostMapping("/findPw")
	public String findPwByInfo(@RequestParam("member_id") String id, @RequestParam("member_name") String name,
			@RequestParam("member_phone") String phone, Model model) {
		MemberVO vo = new MemberVO();
		vo.setMember_id(id);
		vo.setMember_name(name);
		vo.setMember_phone(phone);

		String pw = mService.findPwByInfo(vo);
		if (pw != null)
			model.addAttribute("resultPw", pw);
		else
			model.addAttribute("msg", "일치하는 회원 정보가 없습니다.");

		return "member/findPwResult";
	}

	// 탈퇴 폼 페이지 (GET)
	@GetMapping("/delete")
	public String deleteForm() {
		return "/member/delete"; // -> delete.jsp
	}

	// 🔐 회원 탈퇴 처리 (비밀번호 확인 후)
	@PostMapping("/delete")
	public String deleteMember(@RequestParam("member_pw") String member_pw, HttpSession session,
			RedirectAttributes rttr) {
		logger.info("MemberController: POST /member/delete 호출");

		// 1. 로그인 상태 확인
		MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
		if (loginUser == null) {
			rttr.addFlashAttribute("msg", "로그인이 필요합니다.");
			rttr.addFlashAttribute("icon", "warning");
			return "redirect:/member/login";
		}

		// 2. 입력한 비밀번호로 로그인 검증
		MemberVO checkVO = new MemberVO();
		checkVO.setMember_id(loginUser.getMember_id());
		checkVO.setMember_pw(member_pw);

		MemberVO resultVO = mService.memberLoginCheck(checkVO);
		if (resultVO == null) {
			rttr.addFlashAttribute("msg", "비밀번호가 일치하지 않습니다.");
			rttr.addFlashAttribute("icon", "error");
			return "redirect:/member/delete";
		}

		// ✅ 3. 회원 상태만 변경 (Soft Delete)
		mService.deleteMember(loginUser.getMember_id());

		// ✅ 4. 세션 종료
		session.invalidate();

		// ✅ 5. 메시지 출력
		rttr.addFlashAttribute("msg", "회원 탈퇴가 완료되었습니다.\n그동안 이용해 주셔서 감사합니다!");
		rttr.addFlashAttribute("icon", "success");

		return "redirect:/";
	}

}
