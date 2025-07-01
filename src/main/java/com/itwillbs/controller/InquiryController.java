package com.itwillbs.controller;

import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.itwillbs.domain.InquiryVO;
import com.itwillbs.domain.ResponseVO;
import com.itwillbs.service.InquiryService;

@Controller
@RequestMapping(value = "/cs/*")
public class InquiryController {

	// mylog
	private static final Logger logger = LoggerFactory.getLogger(InquiryController.class);

	// 서비스 객체를 주입
	@Inject InquiryService iService;
	
	// 기능을 정의
	
	// http://localhost:8088/cs/write
	// 글쓰기 (정보 입력) / GET
	@RequestMapping(value = "/write", method = RequestMethod.GET)
	public void inquiryWriteGET() throws Exception {
		logger.info(" inquiryWriteGET() 실행 ");
		
	}
	
	// 글쓰기 (정보 처리) / POST
	@RequestMapping(value = "/write", method = RequestMethod.POST)
	public String inquiryWritePOST(InquiryVO vo, HttpSession session,
								  RedirectAttributes rttr) throws Exception {
		// member_idx가 없으면 로그인 페이지로 이동
		Integer member_idx = (Integer) session.getAttribute("member_idx");
		    if (member_idx == null) {
		    	
		    	
		    	rttr.addFlashAttribute("msg", "로그인이 필요한 서비스입니다.");
		    	rttr.addFlashAttribute("icon", "warning");

		    	return "redirect:/member/login";

	    }
		    
	    vo.setMember_idx(member_idx);  // ✅ 이 줄 추가!

	    logger.info(" vo : {}", vo);

	    // 3. 글쓰기 처리
	    iService.inquiryWrite(vo);
	    
	    // 접수 메시지
        rttr.addFlashAttribute("msg",  "문의 접수 완료!");
        rttr.addFlashAttribute("icon", "success");
		
		
		return "redirect:/cs/list";
	}
	
	
	
	// http://localhost:8088/cs/list
	// 문의 내역 (조회) / GET
	@GetMapping("/list")
	public String inquiryList(@RequestParam(defaultValue = "1") int page, 
							  HttpSession session, Model model, RedirectAttributes rttr) throws Exception {
	    
		 // member_idx가 없으면 로그인 페이지로 이동
		Integer member_idx = (Integer) session.getAttribute("member_idx");
		    if (member_idx == null) {
		    	
		    	rttr.addFlashAttribute("msg", "1:1 문의 내역을 보려면 로그인이 필요합니다.");
		    	rttr.addFlashAttribute("icon", "warning");

		    	return "redirect:/member/login";

	    }
		
	    int pageSize = 10;
	    int startRow = (page - 1) * pageSize;
		    
	    List<InquiryVO> inquiryList = iService.getInquiryListPage(member_idx, startRow, pageSize);
	    int totalCount = iService.getInquiryCount(member_idx);
	    int totalPages = (int) Math.ceil((double) totalCount / pageSize);

	    model.addAttribute("inquiryList", inquiryList);
	    model.addAttribute("currentPage", page);
	    model.addAttribute("totalPages", totalPages);

	    return "/cs/list";
	}

	
	// 문의 상세 조회
	@GetMapping("/read")
	public String inquiryRead(@RequestParam("inquiry_id") int inquiry_id, Model model) throws Exception {
	    logger.info(" 📄 inquiryRead() 실행 - 문의번호: " + inquiry_id);

	    // 문의 정보
	    InquiryVO vo = iService.getInquiry(inquiry_id);
	    model.addAttribute("vo", vo);
	    
	    // ✅ 답변 정보도 함께 조회
	    ResponseVO responseVO = iService.getResponse(inquiry_id);
	    model.addAttribute("responseVO", responseVO);


	    return "/cs/read";  // 👉 상세 페이지 JSP 경로
	}
	
	
	/* 수정 기능 */
	@GetMapping("/update")
	public String inquiryUpdateGET(@RequestParam("inquiry_id") int inquiry_id, Model model) throws Exception {
	    InquiryVO vo = iService.getInquiry(inquiry_id);
	    model.addAttribute("vo", vo);
	    return "/cs/update";  // 수정 form 페이지
	}
	
	@RequestMapping(value = "/update", method = RequestMethod.POST)
	public String inquiryUpdatePOST(InquiryVO vo,
								RedirectAttributes rttr) throws Exception {
	    iService.updateInquiry(vo);
	    
	    // 수정 메시지
        rttr.addFlashAttribute("msg",  "문의 수정 완료!");
        rttr.addFlashAttribute("icon", "success");
	    
	    return "redirect:/cs/read?inquiry_id=" + vo.getInquiry_id();
	}
	
	
	
	/* 삭제 기능 */
	@GetMapping("/delete")
	public String inquiryDelete(@RequestParam("inquiry_id") int inquiry_id,
								RedirectAttributes rttr) throws Exception {
	    iService.deleteInquiry(inquiry_id);
	    
	    // 삭제 메시지
        rttr.addFlashAttribute("msg",  "문의 삭제 완료!");
        rttr.addFlashAttribute("icon", "success");
	    
	    return "redirect:/cs/list";
	}



	

	
	
} // InquiryController 끝
