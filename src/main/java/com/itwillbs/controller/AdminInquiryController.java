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
@RequestMapping("/admin/*")
public class AdminInquiryController {

    @Autowired
    private AdminInquiryService adminInquiryService;

    // http://localhost:8088/admin/list
    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public String list(Model model) {
        List<InquiryVO> inquiryList = adminInquiryService.getAllInquiries();
        model.addAttribute("inquiryList", inquiryList);
        return "admin/inquiry_list"; // view_42
    }

    @RequestMapping(value = "/view", method = RequestMethod.GET)
    public String view(@RequestParam("inquiry_id") int inquiryId, Model model) {
        InquiryVO inquiry = adminInquiryService.getInquiry(inquiryId);
        ResponseVO response = adminInquiryService.getResponse(inquiryId);
        model.addAttribute("inquiry", inquiry);
        model.addAttribute("response", response);
        return "admin/inquiry_view"; // view_43
    }

    @PostMapping("/insertResponse")
    public String insertResponse(ResponseVO response) {
        adminInquiryService.insertResponse(response);
        return "redirect:/admin/inquiry/view?inquiry_id=" + response.getInquiry_id();
    }

    @PostMapping("/updateResponse")
    public String updateResponse(ResponseVO response) {
        adminInquiryService.updateResponse(response);
        return "redirect:/admin/inquiry/view?inquiry_id=" + response.getInquiry_id();
    }

    @PostMapping("/deleteResponse")
    public String deleteResponse(@RequestParam("response_id") int responseId,
                                 @RequestParam("inquiry_id") int inquiryId) {
        adminInquiryService.deleteResponse(responseId);
        return "redirect:/admin/inquiry/view?inquiry_id=" + inquiryId;
    }
}
