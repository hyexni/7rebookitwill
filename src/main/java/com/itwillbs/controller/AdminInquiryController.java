package com.itwillbs.controller;

import com.itwillbs.domain.InquiryVO;
import com.itwillbs.domain.ResponseVO;
import com.itwillbs.service.AdminInquiryService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/admin/")
public class AdminInquiryController {

    @Autowired
    private AdminInquiryService adminInquiryService;

    @RequestMapping(value = "/view", method = RequestMethod.GET)
    public String view(@RequestParam("inquiry_id") int inquiryId, Model model) {
        InquiryVO inquiry = adminInquiryService.getInquiry(inquiryId);
        ResponseVO response = adminInquiryService.getResponse(inquiryId);
        model.addAttribute("inquiry", inquiry);
        model.addAttribute("response", response);
        return "admin/inquiry_view"; // view_43
    }

    // 답변 등록
    @PostMapping("/inquiry/responseInsert")
    public String insertResponse(ResponseVO response) {
        adminInquiryService.insertResponse(response);
        return "redirect:/admin/view?inquiry_id=" + response.getInquiry_id();
    }

    // 답변 수정
    @PostMapping("/inquiry/responseUpdate")
    public String updateResponse(ResponseVO response) {
        adminInquiryService.updateResponse(response);
        return "redirect:/admin/view?inquiry_id=" + response.getInquiry_id();
    }

    // 답변 삭제
    @GetMapping("/inquiry/responseDelete")
    public String deleteResponse(@RequestParam("response_id") int responseId,
                                 @RequestParam("inquiry_id") int inquiryId) {
        adminInquiryService.deleteResponse(responseId);
        return "redirect:/admin/view?inquiry_id=" + inquiryId;
    }
    
    // 페이징 처리
    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public String inquiryList(Model model,
                              @RequestParam(defaultValue = "1") int page) throws Exception {
    	int pageSize = 10;
        int totalCount = adminInquiryService.getInquiryCount();
        int startRow = (page - 1) * pageSize;

        List<InquiryVO> inquiryList = adminInquiryService.getInquiryList(startRow, pageSize);
        int totalPages = (int)Math.ceil((double)totalCount / pageSize);
        
        model.addAttribute("inquiryList", inquiryList);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("totalPages", totalPages);
        return "admin/inquiry_list";
    }


}
