package com.itwillbs.controller;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam; // @RequestParam 추가
import org.springframework.web.servlet.mvc.support.RedirectAttributes; // RedirectAttributes 추가


import com.itwillbs.domain.MemberVO;
import com.itwillbs.service.MemberService;

// @RequestMapping(value = "/member/*")
// => /member/~ 모든 주소를 해당 컨트롤러에서 처리하겠다
//    ~.me (member컨트롤러 처리) , ~.bo (board컨트롤러 처리) 

@Controller
@RequestMapping(value = "/member/*")
public class MemberController {
	
	// MemberService 객체를 주입
	@Inject
	private MemberService mService;
	
	
	//mylog 단축어
	private static final Logger logger = LoggerFactory.getLogger(MemberController.class);
	
	
	// (기존MVC) http://localhost:8088/MVC7/serverTime.me
	//           프로젝트명/주소
	
	// http://localhost:8088/web/serverTime
	// http://localhost:8088/web/member/serverTime
	//           top-level 패키지명
	
	// http://localhost:8088/member/serverTime
	
	// 디비서버 시간정보를 가져와서 view 페이지 출력
	//@GetMapping(value = "/serverTime") => 스프링 4.3이상에서 사용가능
	@RequestMapping(value = "/serverTime",method = RequestMethod.GET)
	public void serverTimeGET(Model model) {
		logger.info(" serverTimeGET() 실행! ");
		
		// 서비스에 동작을 호출
		String time = mService.getServerTime();
		logger.info(" time : "+time);
		
		// 컨트롤러의 정보를 뷰페이지로 전달
		model.addAttribute("time", time);
		
		logger.info("/views/serverTime.jsp 페이지 출력");		
	}
	
	//http://localhost:8088/member/MemberJoin.me (x)
	//http://localhost:8088/member/MemberJoin(x)
	
	//http://localhost:8088/member/join
	// 회원가입 /MemberJoin.me 주소로 
	//  매핑된 메서드 memberJoinGET() 생성 연결된 뷰페이지 생성 
	@RequestMapping(value = "/join",method = RequestMethod.GET)
	public void memberJoinGET() {
		logger.info("memberJoinGET() 실행 ");
		logger.info("/views/member/join.jsp 페이지 이동");
	}
	
	
	
	//http://localhost:8088/member/join?member_id=...&member_pw=...&member_name=...&member_email=...
	
	@RequestMapping(value = "/join",method = RequestMethod.POST)
	public String memberJoinPOST(MemberVO vo) {
		logger.info("memberJoinPOST() 실행 ");
		
		// - 한글처리 인코딩 생략 (web.xml 필터 설정) 
		
		// 회원가입 처리동작 수행
		// 1) 전달받은 회원가입 정보(파라메터)를 저장
		logger.info(" vo : "+vo);
		
		// 2) 서비스 -> DAO 호출, DB에 저장(insert) 
		mService.memberJoin(vo);
		
		// 3) 페이지 이동		
		// => 회원가입후 로그인 페이지로 이동
		
		return "redirect:/member/login";
	}
	
	
	//http://localhost:8088/member/login
	// 로그인 페이지
	@RequestMapping(value = "/login",method = RequestMethod.GET)
	public void memberLoginGET() {
		logger.info("memberLoginGET() 실행");
		logger.info("/views/member/login.jsp 페이지 연결");		
	}
	
	
	// 로그인 페이지 POST
	// http://localhost:8088/member/login  POST방식 호출
	@RequestMapping(value = "/login", method = RequestMethod.POST)
	public String memberLoginPOST(
	    @RequestParam("member_id") String id, // MemberVO로 받지 않고 id, pw를 직접 파라미터로 받음
	    @RequestParam("member_pw") String pw,
	    HttpSession session,
	    RedirectAttributes rttr // RedirectAttributes 추가 (메시지 전달용)
	) {
		logger.info(" memberLoginPOST() 실행 ");
		
		// 폼태그로 전달된 데이터(member_id,member_pw)를 저장
		// MemberVO vo 객체 생성 및 데이터 설정
		MemberVO vo = new MemberVO();
		vo.setMember_id(id); // MemberVO의 필드명에 맞게 설정 (member_id -> member_id)
		vo.setMember_pw(pw); // MemberVO의 필드명에 맞게 설정 (member_pw -> member_pw)
		
		logger.info(" 로그인 시도 vo : "+vo);
		
		// 로그인 여부를 체크 
		// 서비스 -> DAO  로그인 체크하는 메서드 
		// MemberVO의 필드명이 Member_id, Member_pw라면 서비스/DAO도 그렇게 동작해야 합니다.
		MemberVO resultVO = mService.memberLoginCheck(vo);
		
		// 결과에 따른 페이지 이동
		// 성공 - 메인페이지로 이동
		// 실패 - 다시 로그인페이지로 이동
		if(resultVO == null) {
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
	// 메인 페이지 /member/main  GET
	@RequestMapping(value = "/main",method = RequestMethod.GET)
	public void memberMainGET() {
		logger.info(" memberMainGET() 실행 ");
		logger.info(" /member/main.jsp 뷰페이지 ");
	}
	
	// 로그아웃    /member/logout  GET/POST  
	@RequestMapping(value = "/logout",method = RequestMethod.GET)
	public String memberLogoutGET(HttpSession session, RedirectAttributes rttr) { // RedirectAttributes 추가
		logger.info(" memberLogoutGET() 실행 ");
		
		// 사용자의 세션정보(id) 초기화
		session.invalidate();
		
		rttr.addFlashAttribute("message", "로그아웃 되었습니다."); // 로그아웃 메시지 추가
		// 다시 메인페이지로 이동
		
		return "redirect:/member/main";
	}
	
	
	// 회원정보 조회(마이페이지) /member/info    GET
	@RequestMapping(value = "/info",method = RequestMethod.GET)
	public String memberInfoGET(HttpSession session,Model model) {
		logger.info(" memberInfoGET() 실행 ");
		
		// 사용자의 로그인 정보를 체크(세션)
		String id = (String)session.getAttribute("id");
		if(id == null) {
			// 로그인 정보가 없을경우 다시 로그인페이지로 이동
			return "redirect:/member/login";
		}
		
		// 사용자 로그인 정보가 있음
		// 서비스 -> DAO호출 (회원정보를 조회기능)
		MemberVO resultVO = mService.memberInfo(id);
		
		// DB에서 가져온 정보를 뷰페이지로 전달	
		//model.addAttribute("resultVO",resultVO);
		model.addAttribute(resultVO);
		
		logger.info(" /views/member/info.jsp 페이지 출력");
		return "/member/info";
	}
	
	
	// 회원정보 수정  /member/update  GET 
	//  (기존의 정보를 보여주기) 
	@RequestMapping(value = "/update",method = RequestMethod.GET)
	public String memberUpdateGET(HttpSession session,Model model) {
		logger.info(" memberUpdateGET() 실행 ");
		
		// 사용자가 로그인 여부 체크 (세션)
		String id = (String)session.getAttribute("id");
		if(id == null) {
			return "redirect:/member/login";
		}
		// 세션정보(아이디)를 기존의 정보를 불러와서 출력
		//MemberVO resultVO = mService.memberInfo(id);
		//model.addAttribute(resultVO);
		
		model.addAttribute(mService.memberInfo(id));
		
		logger.info(" /member/update.jsp 페이지 연결 ");
		return "/member/update";
	}
	
	// 회원정보 수정    /member/update    POST
	@RequestMapping(value = "/update",method = RequestMethod.POST)
	public String memberUpdatePOST(MemberVO uvo) {
		logger.info(" memberUpdatePOST() 실행 ");
		
		// 수정할 정보를 받아오기(파라메터)
		logger.info(" uvo : {}",uvo);
		
		// 서비스 -> DAO  (회원정보 수정)		
		mService.memberUpdate(uvo);
		
		return "redirect:/member/main";
	}
	
	
	
	
	
	
	
}// controller