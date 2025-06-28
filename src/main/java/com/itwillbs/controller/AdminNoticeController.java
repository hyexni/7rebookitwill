package com.itwillbs.controller;

import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.itwillbs.domain.NoticeVO;
import com.itwillbs.service.AdminNoticeService;


@Controller
@RequestMapping(value = "/admin/")
public class AdminNoticeController {
	
		//mylog
		private static final Logger logger = LoggerFactory.getLogger(AdminNoticeController.class);

		// 서비스 객체를 주입
		@Inject
		private AdminNoticeService anService;
		
		// 기능을 정의
		
		
		// http://localhost:8088/admin/notice_write
		// 글쓰기 (정보 입력) / GET
		@RequestMapping(value = "/notice_write", method = RequestMethod.GET)
		public void adminNoticeWriteGET() {
			logger.info(" adminNoticeWriteGET() 실행 ");
			logger.info(" /views/admin/notice_write.jsp 페이지 이동 ");
		}
		
		
		@PostMapping("/notice_write")
		public String adminNoticeWritePOST(HttpSession session, 
										   NoticeVO vo,
										   @RequestParam(value = "fixed", defaultValue = "N") String fixed,
										   RedirectAttributes rttr) throws Exception {
		   

		    vo.setFixed(fixed);          // ★ 세팅
		    
		    anService.adminNoticeWrite(vo);
		    
		    // 등록 메시지
	        rttr.addFlashAttribute("msg",  "공지 등록 완료!");
	        rttr.addFlashAttribute("icon", "success");
		    
		    return "redirect:/admin/notice_list";
		}

		
		// http://localhost:8088/admin/notice_read
		// 공지사항 상세/수정/삭제
		// 상세보기
		@GetMapping("notice/read")
		public String read(@RequestParam("notice_id") int notice_id, Model model) throws Exception {
		    model.addAttribute("notice", anService.getNoticeById(notice_id));
		    return "admin/notice_read";
		}

		// http://localhost:8088/admin/notice_edit
		// 수정폼
		@GetMapping("notice/edit")
		public String editForm(@RequestParam("notice_id") int notice_id, Model model) throws Exception {
		    model.addAttribute("notice", anService.getNoticeById(notice_id));
		    return "admin/notice_edit";
		}

		
		// 수정 처리
		@PostMapping("notice/edit")
		public String editPost(NoticeVO vo, 
							   @RequestParam(value = "fixed", defaultValue = "N") String fixed,
							   RedirectAttributes rttr) throws Exception {
			
			vo.setFixed(fixed);          // ★ 수정도 동일
			
		    anService.updateNotice(vo);
		    
		    // 수정 메시지
	        rttr.addFlashAttribute("msg",  "공지 수정 완료!");
	        rttr.addFlashAttribute("icon", "success");
		    
		    return "redirect:/admin/notice/read?notice_id=" + vo.getNotice_id();
		}

		// 삭제 처리
		@PostMapping("notice/delete")
		public String delete(@RequestParam("notice_id") int notice_id,
							RedirectAttributes rttr) throws Exception {
		    anService.deleteNotice(notice_id);
		    
	        // 삭제 메시지
	        rttr.addFlashAttribute("msg",  "공지 삭제 완료!");
	        rttr.addFlashAttribute("icon", "success");
		    
		    return "redirect:/admin/notice_list";
		}
		
		// http://localhost:8088/admin/notice_list
		// 페이징 처리
		@RequestMapping(value = "/notice_list", method = RequestMethod.GET)
		public String noticeListPage(@RequestParam(value = "page", defaultValue = "1") int page, Model model) {

		    int pageSize = 10;
		    int totalCount = anService.getNoticeCount();
		    int startRow = (page - 1) * pageSize;

		    List<NoticeVO> noticeList = anService.getNoticeListPage(startRow, pageSize);
		    int totalPages = (int)Math.ceil((double)totalCount / pageSize);

		    model.addAttribute("noticeList", noticeList);
		    model.addAttribute("currentPage", page);
		    model.addAttribute("totalPages", totalPages);

		    return "admin/notice_list";
		}

		


		
		
		
		
		
		

}
