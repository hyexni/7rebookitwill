package com.itwillbs.controller;

import com.itwillbs.domain.PointVO;
import com.itwillbs.domain.SearchCriteria;
import com.itwillbs.dto.PageMakerDTO;
import com.itwillbs.dto.PointHistoryDTO;
import com.itwillbs.service.PointHistoryService; // service import

import org.slf4j.Logger;
import org.springframework.beans.factory.annotation.Autowired; // Autowired import
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin")
public class AdminPointController {

    //  Service 객체를 주입받기 위한 필드 선언 및 @Autowired 추가
    @Autowired
    private PointHistoryService pointHistoryService;

    @GetMapping("/pointHistory")
    public String getPointHistory(@ModelAttribute("cri") SearchCriteria cri, Model model) {

        // 클래스 이름(PointHistoryService) 대신 주입받은 객체(pointHistoryService) 사용
        List<PointHistoryDTO> historyList = pointHistoryService.getPointHistoryList(cri);
        int totalCount = pointHistoryService.getPointHistoryCount(cri);
        
     // ================= [ 디버깅 코드 추가 ] =================
        System.out.println("### Service로부터 받은 데이터 개수: " + historyList.size()); 
        // =======================================================

        // Map 대신 PageMakerDTO 사용
        PageMakerDTO pageMaker = new PageMakerDTO();
        pageMaker.setCri(cri);
        pageMaker.setTotalCount(totalCount);

        model.addAttribute("historyList", historyList);
        model.addAttribute("pageMaker", pageMaker);

        return "admin/pointHistory";
    }
    
}