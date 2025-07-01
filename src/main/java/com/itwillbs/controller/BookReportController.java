package com.itwillbs.controller;

import java.util.List;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import com.itwillbs.domain.BookReportVO;
import com.itwillbs.domain.SearchCriteria;
import com.itwillbs.dto.PageMakerDTO;
import com.itwillbs.service.BookReportService;

@Controller
@RequestMapping("/bookreport/*")
public class BookReportController {
    
    private static final Logger logger = LoggerFactory.getLogger(BookReportController.class);
    
    @Inject
    private BookReportService brService;

    /**
     * 독후감 목록 페이지 (페이징 + 검색 + 정렬 처리)
     */
    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public String listGET(@ModelAttribute("cri") SearchCriteria cri, Model model, HttpSession session, RedirectAttributes rttr) throws Exception {
        logger.info("C: /bookreport/list -> listGET() 호출 (Search, Sort)");

        if (session.getAttribute("member_idx") == null) {
        	
        	rttr.addFlashAttribute("msg", "독후감은 로그인이 필요한 서비스입니다.");
	    	rttr.addFlashAttribute("icon", "warning");
	    	
            return "redirect:/member/login";
        }
        
        // ========================= [ 추가된 기능: 기본 정렬 기준 설정 ] =========================
        // 정렬 조건이 파라미터로 전달되지 않은 경우, 기본값(최신순)으로 설정합니다.
        if (cri.getSortColumn() == null || cri.getSortColumn().isEmpty()) {
            cri.setSortColumn("report_id"); // 독후감 ID를 기준으로
            cri.setSortOrder("DESC");       // 내림차순 정렬 (최신순)
        }
        // =======================================================================================
        
        List<BookReportVO> reportList = brService.getReportListAll(cri);
        
        PageMakerDTO pageMaker = new PageMakerDTO();
        pageMaker.setCri(cri);
        pageMaker.setTotalCount(brService.countReports(cri));
        logger.info("1111111111111111111111111111");
        logger.info("reportList.size"+reportList.size());
        model.addAttribute("bookreportList", reportList);
        
        
        model.addAttribute("pageMaker", pageMaker);        
        model.addAttribute("cri", cri);
        
        return "/bookreport/list";
    }

    /**
     * 글쓰기 페이지 요청 (GET)
     * 로그인한 사용자만 접근 가능합니다.
     */
    @RequestMapping(value = "/write", method = RequestMethod.GET)
    public String writeGET(HttpSession session, RedirectAttributes rttr, HttpServletRequest request) throws Exception {
        logger.info("C: /bookreport/write -> writeGET() 호출");

        // 세션에서 회원 정보를 가져옴
        Integer member_idx = (Integer) session.getAttribute("member_idx");
        
        
        if (member_idx == null) {
            // 리다이렉트 시 메시지를 일회성으로 전달
        	rttr.addFlashAttribute("msg", "독후감은 로그인이 필요한 서비스입니다.");
	    	rttr.addFlashAttribute("icon", "warning");
            
            // ✅==== 기능 추가 시작 ====
            // 사용자가 원래 요청했던 목적지 URL을 세션에 저장
            String destination = request.getRequestURI();
            session.setAttribute("redirectAfterLogin", destination);
            logger.info("로그인 후 이동할 URL 저장: {}", destination);
            // ✅==== 기능 추가 끝 ====

            // 로그인 페이지로 이동시킴
            return "redirect:/member/login";
        }        
        return "/bookreport/write"; // /views/bookreport/write.jsp
    }

    /**
     * 글쓰기 처리 (POST)
     * 로그인한 사용자만 접근 가능합니다.
     */
    @RequestMapping(value = "/write", method = RequestMethod.POST)
    public String writePOST(BookReportVO vo, RedirectAttributes rttr, HttpSession session) throws Exception {
        logger.info("C: /bookreport/write -> writePOST() 호출");
        
        // 로그인 확인 및 사용자 정보(member_idx) 설정
        Integer member_idx = (Integer) session.getAttribute("member_idx");
        if (member_idx == null) {
            rttr.addFlashAttribute("auth_msg", "세션이 만료되었거나 로그인이 필요합니다.");
            return "redirect:/member/login"; // 로그인 페이지 주소로 변경하세요.
        }
        vo.setMember_idx(member_idx);

        brService.writeReport(vo);
        rttr.addFlashAttribute("result", "CREATE_OK");
        
        return "redirect:/bookreport/list";
    }

    /**
     * 본문 보기 (GET)
     * 로그인한 사용자만 접근 가능합니다.
     */
    @RequestMapping(value = "/read", method = RequestMethod.GET)
    public String readGET(@RequestParam("report_id") int report_id, Model model, HttpSession session, RedirectAttributes rttr) throws Exception {
        logger.info("C: /bookreport/read -> readGET() 호출, ID: " + report_id);
        
        // 로그인 확인
        if (session.getAttribute("member_idx") == null) {
            rttr.addFlashAttribute("auth_msg", "로그인이 필요한 기능입니다.");
            return "redirect:/member/login"; // 로그인 페이지 주소로 변경하세요.
        }
        
        BookReportVO vo = brService.getReportDetails(report_id);
        model.addAttribute("vo", vo);
        
        return "/bookreport/read"; // /views/bookreport/read.jsp
    }
    
    /**
     * 글 수정 페이지 요청 (GET)
     * 로그인한 사용자만 접근 가능합니다.
     */
    @RequestMapping(value = "/modify", method = RequestMethod.GET)
    public String modifyGET(@RequestParam("report_id") int report_id, Model model, HttpSession session, RedirectAttributes rttr) throws Exception {
        logger.info("C: /bookreport/modify -> modifyGET() 호출, ID: " + report_id);
        
        // 로그인 확인
        Integer login_member_idx = (Integer) session.getAttribute("member_idx");
        if (login_member_idx == null) {
            rttr.addFlashAttribute("auth_msg", "로그인이 필요한 기능입니다.");
            return "redirect:/member/login";
        }
        
        BookReportVO vo = brService.getReportDetails(report_id);
        
        // 본인 글 여부 확인
        if (vo.getMember_idx() != login_member_idx) {
        	rttr.addFlashAttribute("auth_msg", "수정 권한이 없습니다.");
        	return "redirect:/bookreport/list";
        }
        
        model.addAttribute("vo", vo);
        return "/bookreport/modify"; // /views/bookreport/modify.jsp
    }

    /**
     * 글 수정 처리 (POST)
     * 로그인한 사용자만 접근 가능합니다.
     */
    @RequestMapping(value = "/modify", method = RequestMethod.POST)
    public String modifyPOST(BookReportVO vo, RedirectAttributes rttr, HttpSession session) throws Exception {
        logger.info("C: /bookreport/modify -> modifyPOST() 호출");
        
        // 로그인 확인
        if (session.getAttribute("member_idx") == null) {
            rttr.addFlashAttribute("auth_msg", "세션이 만료되었거나 로그인이 필요합니다.");
            return "redirect:/member/login";
        }
        
        brService.modifyReport(vo);
        rttr.addFlashAttribute("result", "MODIFY_OK");
        
        return "redirect:/bookreport/read?report_id=" + vo.getReport_id();
    }
    
    /**
     * 글 삭제 처리 (POST)
     * 로그인한 사용자만 접근 가능합니다.
     */
    @RequestMapping(value = "/delete", method = RequestMethod.POST)
    public String deletePOST(@RequestParam("report_id") int report_id, RedirectAttributes rttr, HttpSession session) throws Exception {
        logger.info("C: /bookreport/delete -> deletePOST() 호출, ID: " + report_id);
        
        // 로그인 확인
        if (session.getAttribute("member_idx") == null) {
            rttr.addFlashAttribute("auth_msg", "세션이 만료되었거나 로그인이 필요합니다.");
            return "redirect:/member/login";
        }
        
        // 여기에 본인 글인지 확인하는 로직을 추가하는 것을 권장합니다.
        
        brService.removeReport(report_id);
        rttr.addFlashAttribute("result", "DELETE_OK");
        
        return "redirect:/bookreport/list";
    }
}