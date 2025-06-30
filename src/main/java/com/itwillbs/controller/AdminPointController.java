package com.itwillbs.controller;

import com.itwillbs.domain.PointVO;
import com.itwillbs.domain.SearchCriteria;
import com.itwillbs.dto.PageMakerDTO;
import com.itwillbs.dto.PointHistoryDTO;
import com.itwillbs.service.PointHistoryService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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
	
	private static final Logger logger = LoggerFactory.getLogger(AdminPointController.class);

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
    
    
    
 // =================================================================================
    // 관리자가 포인트 지급
 // =================================================================================
    
    
    
    // 1. 포인트 지급 폼 페이지를 보여주는 메소드
    @GetMapping("/add")
    public String addPointForm() {
        logger.info(" /admin/add -> addPointForm() GET 호출 ");
        // 관리자 로그인 여부 등은 인터셉터에서 처리하는 것을 권장합니다.
        
        // 뷰 페이지 경로를 반환합니다.
        return "/admin/addPointForm"; // /WEB-INF/views/admin/addPointForm.jsp
    }
    
    // 2. 폼에서 전달된 정보로 실제 포인트를 지급하는 메소드
    @PostMapping("/add")
    public String addPointSubmit(@RequestParam("member_idx") int member_idx,
                                 @RequestParam("change_amount") int change_amount,
                                 @RequestParam("change_reason") String change_reason,
                                 RedirectAttributes rttr, HttpSession session) {
        
    	// ================== 세션 체크 로직 추가 ==================
        // "admin_id"는 관리자 로그인 성공 시 세션에 저장했던 속성 이름입니다.
        if (session.getAttribute("admin") == null) {
            rttr.addFlashAttribute("message", "오류: 관리자 로그인이 필요한 서비스입니다.");
            return "redirect:/admin/login"; // 로그인 페이지로 리다이렉트
        }
        // ======================================================
    	
        logger.info(" /admin/points/add -> addPointSubmit() POST 호출 ");
        logger.info(" 지급 대상 회원 ID: " + member_idx);
        logger.info(" 지급 포인트: " + change_amount);
        logger.info(" 지급 사유: " + change_reason);
        
        try {
            // 서비스 계층의 메소드 호출
            pointHistoryService.addPointByAdmin(member_idx, change_amount, change_reason);
            
            // 성공 시 메시지를 RedirectAttributes에 담아 전달
            rttr.addFlashAttribute("message", "성공: " + member_idx + "번 회원에게 " + change_amount + "포인트가 지급되었습니다.");
            
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("포인트 지급 중 예외 발생", e);
            
            // 실패 시 에러 메시지를 전달
            rttr.addFlashAttribute("message", "오류: 포인트 지급에 실패했습니다. 로그를 확인해주세요.");
        }
        
        // 작업 완료 후 다시 지급 폼 페이지로 리다이렉트
        return "redirect:/admin/pointHistory";
    }
    
}