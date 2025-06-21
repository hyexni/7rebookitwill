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
		
		// 글쓰기 (정보 처리) / POST
	/*
	 * @PostMapping("/admin/notice_write") public String
	 * adminNoticeWritePOST(HttpSession session, NoticeVO vo) throws Exception {
	 * String ad_id = (String) session.getAttribute("ad_id"); // 세션에서 관리자 아이디 꺼내기
	 * vo.setAd_id(ad_id); // NoticeVO에 주입 anService.adminNoticeWrite(vo); return
	 * "redirect:/admin/notice_list"; }
	 */
		
		@PostMapping("/notice_write")
		public String adminNoticeWritePOST(HttpSession session, NoticeVO vo) throws Exception {
		    String ad_id = (String) session.getAttribute("ad_id");
		    if (ad_id == null) {
		        System.out.println("❗ 관리자 세션 ad_id 없음. 임시 'admin' 사용");
		        ad_id = "admin01"; // 디버깅용
		    }
		    vo.setAd_id(ad_id);
		    anService.adminNoticeWrite(vo);
		    return "redirect:/admin/notice_list";
		}


		
		
		
		// http://localhost:8088/admin/notice_list
		// 관리자 공지사항 목록 조회
	/*
	 * @RequestMapping(value = "/notice_list", method = RequestMethod.GET) public
	 * String noticeList(Model model) throws Exception { List<NoticeVO> noticeList =
	 * anService.getNoticeList(); model.addAttribute("noticeList", noticeList);
	 * return "admin/notice_list"; }
	 */
		
		// http://localhost:8088/admin/notice_read
		// 공지사항 상세/수정/삭제
		// 상세보기
		@GetMapping("read")
		public String read(@RequestParam("notice_id") int notice_id, Model model) throws Exception {
		    model.addAttribute("notice", anService.getNoticeById(notice_id));
		    return "admin/notice_read";
		}

		// http://localhost:8088/admin/notice_edit
		// 수정폼
		@GetMapping("edit")
		public String editForm(@RequestParam("notice_id") int notice_id, Model model) throws Exception {
		    model.addAttribute("notice", anService.getNoticeById(notice_id));
		    return "admin/notice_edit";
		}

		
		// 수정 처리
		@PostMapping("edit")
		public String editPost(NoticeVO vo) throws Exception {
		    anService.updateNotice(vo);
		    return "redirect:/admin/read?notice_id=" + vo.getNotice_id();
		}

		// 삭제 처리
		@PostMapping("delete")
		public String delete(@RequestParam("notice_id") int notice_id) throws Exception {
		    anService.deleteNotice(notice_id);
		    return "redirect:/admin/notice_list";
		}
		
		
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
