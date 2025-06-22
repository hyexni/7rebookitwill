package com.itwillbs.controller;

import java.util.List;
import javax.inject.Inject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.itwillbs.domain.MemberVO;
import com.itwillbs.service.AdminMemberService;

@Controller
@RequestMapping(value = "/admin/")
public class AdminMemberController {
	
	private static final Logger logger = LoggerFactory.getLogger(AdminMemberController.class);
	
	@Inject
	private AdminMemberService amService;

	// http://localhost:8088/admin/member_list
	@GetMapping("member_list")
	public String memberList(Model model, 
	                         @RequestParam(name = "page", defaultValue = "1") int page,
	                         @RequestParam(name = "keyword", required = false) String keyword,
	                         @RequestParam(name = "sort", defaultValue = "regdate") String sort) {

	    int pageSize = 10;
	    int startRow = (page - 1) * pageSize;

	    List<MemberVO> memberList;
	    int totalCount;

	    if (keyword != null && !keyword.isEmpty()) {
	        memberList = amService.searchMembers(keyword, sort, startRow, pageSize);
	        totalCount = amService.getSearchCount(keyword);
	    } else {
	        memberList = amService.getMemberList(sort, startRow, pageSize);
	        totalCount = amService.getTotalCount();
	    }

	    int totalPages = (int) Math.ceil((double) totalCount / pageSize);

	    model.addAttribute("memberList", memberList);
	    model.addAttribute("currentPage", page);
	    model.addAttribute("totalPages", totalPages);
	    model.addAttribute("keyword", keyword);
	    model.addAttribute("sort", sort);

	    return "admin/member_list";
	}
}
