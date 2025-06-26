package com.itwillbs.controller;

import com.itwillbs.domain.InquiryVO;
import com.itwillbs.domain.ResponseVO;
import com.itwillbs.service.AdminInquiryService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/admin/")
public class AdminInquiryController {

    @Autowired
    private AdminInquiryService adminInquiryService;

    @RequestMapping(value = "/view", method = RequestMethod.GET)
    public String view(@RequestParam("inquiry_id") int inquiry_id, Model model) {
        InquiryVO inquiry = adminInquiryService.getInquiry(inquiry_id);
        
        System.out.println("[DEBUG] inquiry.member_id = " + inquiry.getMember_id());
        
        ResponseVO response = adminInquiryService.getResponse(inquiry_id);
        model.addAttribute("inquiry", inquiry);
        model.addAttribute("response", response);
        return "admin/inquiry_view"; // view_43
    }

    // 답변 등록
    @PostMapping("/inquiry/responseInsert")
    public String insertResponse(ResponseVO response,
    							RedirectAttributes rttr) {
        adminInquiryService.insertResponse(response);
        
        // 등록 메시지
        rttr.addFlashAttribute("msg",  "답변 등록 완료!");
        rttr.addFlashAttribute("icon", "success");
        
        return "redirect:/admin/view?inquiry_id=" + response.getInquiry_id();
    }

    // 답변 수정
    @PostMapping("/inquiry/responseUpdate")
    public String updateResponse(ResponseVO response,
    							RedirectAttributes rttr) {
        adminInquiryService.updateResponse(response);
        
        // 수정 메시지
        rttr.addFlashAttribute("msg",  "답변 수정 완료!");
        rttr.addFlashAttribute("icon", "success");
        
        return "redirect:/admin/view?inquiry_id=" + response.getInquiry_id();
    }

    // 답변 삭제
    @GetMapping("/inquiry/responseDelete")
    public String deleteResponse(@RequestParam("response_id") int response_id,
                                 @RequestParam("inquiry_id") int inquiry_id,
                                 RedirectAttributes rttr) {
        adminInquiryService.deleteResponse(response_id, inquiry_id);
        
        // 삭제 메시지
        rttr.addFlashAttribute("msg",  "답변 삭제 완료!");
        rttr.addFlashAttribute("icon", "success");
        
        return "redirect:/admin/view?inquiry_id=" + inquiry_id;
    }
    
    // 페이징 처리
    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public String inquiryList(@RequestParam(defaultValue = "1") int page,
                              @RequestParam(value = "keyword", required = false) String keyword,
                              Model model) throws Exception {
    	int pageSize = 10;
        int startRow = (page - 1) * pageSize;

        List<InquiryVO> inquiryList = adminInquiryService.getInquiryList(startRow, pageSize, keyword);
        int totalCount = adminInquiryService.getInquiryCount(keyword);
        int totalPages = (int)Math.ceil((double)totalCount / pageSize);
        
        model.addAttribute("inquiryList", inquiryList);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("keyword", keyword); // ✅ 검색어 유지용
        
        return "admin/inquiry_list";
    }


}
