package com.itwillbs.controller;

import java.util.List;
import javax.inject.Inject;
import javax.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import com.itwillbs.domain.BookReportVO;
import com.itwillbs.service.BookReportService;

@Controller
@RequestMapping("/bookreport/*")
public class BookReportController {
    
    private static final Logger logger = LoggerFactory.getLogger(BookReportController.class);
    
    @Inject
    private BookReportService brService;

    /**
     * 독후감 목록 페이지
     * 누구나 접근 가능합니다.
     */
    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public String listGET(Model model,HttpSession session, RedirectAttributes rttr) throws Exception {
        logger.info("C: /bookreport/list -> listGET() 호출");
     // 로그인 확인
        if (session.getAttribute("member_idx") == null) {
            rttr.addFlashAttribute("auth_msg", "로그인이 필요한 기능입니다.");
            return "redirect:/member/login"; // 로그인 페이지 주소로 변경하세요.
        }
                
        List<BookReportVO> reportList = brService.getReportListAll();
        model.addAttribute("reportList", reportList);
        
        return "/bookreport/list"; // /views/bookreport/list.jsp
    }

    /**
     * 글쓰기 페이지 요청 (GET)
     * 로그인한 사용자만 접근 가능합니다.
     */
    @RequestMapping(value = "/write", method = RequestMethod.GET)
    public String writeGET(HttpSession session, RedirectAttributes rttr) throws Exception {
        logger.info("C: /bookreport/write -> writeGET() 호출");

        // 로그인 확인
        if (session.getAttribute("member_idx") == null) {
            rttr.addFlashAttribute("auth_msg", "로그인이 필요한 기능입니다.");
            return "redirect:/member/login"; // 로그인 페이지 주소로 변경하세요.
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