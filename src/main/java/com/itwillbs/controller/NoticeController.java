package com.itwillbs.controller;

import java.util.List;
import javax.inject.Inject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.itwillbs.domain.NoticeVO;
import com.itwillbs.service.AdminNoticeService;

@Controller
@RequestMapping("/notice/*")
public class NoticeController {

    @Inject
    private AdminNoticeService anService;

    @GetMapping("list")
    public String list(Model model) {
        List<NoticeVO> noticeList = anService.getNoticeListPage(0, 100); // 100개까지
        model.addAttribute("noticeList", noticeList);
        return "notice/list";
    }

    @GetMapping("read")
    public String read(@RequestParam("notice_id") int notice_id, Model model) throws Exception {
        NoticeVO notice = anService.getNoticeById(notice_id);
        model.addAttribute("notice", notice);
        return "notice/read";
    }
}
