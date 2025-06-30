package com.itwillbs.controller;

import com.itwillbs.domain.PointVO;
import com.itwillbs.domain.SearchCriteria;
import com.itwillbs.dto.PageMakerDTO;
import com.itwillbs.dto.PointHistoryDTO;
import com.itwillbs.service.PointHistoryService;

import org.slf4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
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

    @Autowired
    private PointHistoryService pointHistoryService;

    @GetMapping("/pointHistory")
    public String getPointHistory(@ModelAttribute("cri") SearchCriteria cri, Model model) {

        // ========================= [ 수정된 부분 1: 기본 정렬 기준 설정 ] =========================
        // 뷰로부터 정렬 관련 파라미터가 전달되지 않은 경우(최초 페이지 접근 시),
        // 기본 정렬 기준(변경일 최신순)을 설정합니다.
        if (cri.getSortColumn() == null || cri.getSortColumn().isEmpty()) {
            cri.setSortColumn("change_date");
            cri.setSortOrder("DESC");
        }
        // =======================================================================================

        List<PointHistoryDTO> historyList = pointHistoryService.getPointHistoryList(cri);
        int totalCount = pointHistoryService.getPointHistoryCount(cri);
        
        System.out.println("### Service로부터 받은 데이터 개수: " + historyList.size()); 

        PageMakerDTO pageMaker = new PageMakerDTO();
        pageMaker.setCri(cri);
        pageMaker.setTotalCount(totalCount);

        model.addAttribute("historyList", historyList);
        model.addAttribute("pageMaker", pageMaker);
        
     // [차트용] 월간 통계 데이터 조회 및 모델에 추가
        model.addAttribute("accrualStats", pointHistoryService.getMonthlyAccrualStats());
        model.addAttribute("usageStats", pointHistoryService.getMonthlyUsageStats());

      

        // ========================= [ 수정된 부분 2: cri 객체 전달 ] =========================
        // @ModelAttribute("cri")로 인해 자동으로 모델에 추가되지만,
        // 명시적으로 추가하여 코드의 가독성을 높일 수 있습니다.
        // JSP 뷰에서 cri.sortUrl() 이나 cri.pageUrl() 같은 헬퍼 메소드를 사용하려면
        // cri 객체가 모델에 담겨있어야 합니다.
        model.addAttribute("cri", cri);
        // =================================================================================

        return "admin/pointHistory";
    }
    
}