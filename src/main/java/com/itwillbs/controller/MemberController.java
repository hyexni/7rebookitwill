package com.itwillbs.controller;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.itwillbs.domain.MemberVO;
import com.itwillbs.service.MemberService;

// @RequestMapping(value = "/member/*")
// => /member/~ 모든 주소를 해당 컨트롤러에서 처리하겠다
//   ~.me (member컨트롤러 처리) , ~.bo (board컨트롤러 처리) 

@Controller
@RequestMapping(value = "/member/*")
public class MemberController {
	
	// MemberService 객체를 주입
	@Inject
	private MemberService mService;
	
	
	//mylog 단축어
	private static final Logger logger = LoggerFactory.getLogger(MemberController.class);
	
	
	// (기존MVC) http://localhost:8088/MVC7/serverTime.me
	//                                프로젝트명/주소
	
	// http://localhost:8088/web/serverTime
	// http://localhost:8088/web/member/serverTime
	//                      top-level 패키지명
	
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
	
	
	
	//http://localhost:8088/member/join?userid=...&userpw=...&username=...&useremail=...
	
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
	public String memberLoginPOST(MemberVO vo, HttpSession session ) {
		logger.info(" memberLoginPOST() 실행 ");
		
		// 폼태그로 전달된 데이터(userid,userpw)를 저장
		// => 파라메터
		logger.info(" vo : "+vo);
		
		// 로그인 여부를 체크 
		// 서비스 -> DAO  로그인 체크하는 메서드 
		MemberVO resultVO = mService.memberLoginCheck(vo);
		
		// 결과에 따른 페이지 이동
		// 성공 - 메인페이지로 이동
		// 실패 - 다시 로그인페이지로 이동
		if(resultVO == null) {
			return "redirect:/member/login";
		}
		
		// 로그인 성공시 세션영역에 아이디를 저장 
		session.setAttribute("id", resultVO.getMember_id());
		
		
		return "redirect:/member/main";
	}
	
	// http://localhost:8088/member/main
	// 메인 페이지 /member/main  GET
	@RequestMapping(value = "/main",method = RequestMethod.GET)
	public void memberMainGET() {
		logger.info(" memberMainGET() 실행 ");
		logger.info(" /member/main.jsp 뷰페이지 ");
	}
	
	// 로그아웃   /member/logout  GET/POST  
	@RequestMapping(value = "/logout",method = RequestMethod.GET)
	public String memberLogoutGET(HttpSession session) {
		logger.info(" memberLogoutGET() 실행 ");
		
		// 사용자의 세션정보(id) 초기화
		session.invalidate();
		// 다시 메인페이지로 이동
		
		return "redirect:/member/main";
	}
	
	
	// 회원정보 조회(마이페이지) /member/info   GET
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
	
	// 회원정보 수정    /member/update   POST
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
