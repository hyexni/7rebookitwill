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
//
//    // --- 포인트 적립 기능 ---
//    // 예시: 관리자 페이지에서 특정 회원에게 포인트를 적립해주는 경우, 또는 이벤트 참여로 적립
//    // 실제로는 별도의 관리자 컨트롤러에서 처리하거나, 주문 완료 시 자동 적립 등의 로직이 필요
//    // http://localhost:8088/point/earn
//    @PostMapping("/earn")
//    public String earnPoint(@RequestParam("amount") int amount,
//                              @RequestParam(value = "reason", defaultValue = "포인트 적립") String reason,
//                              HttpSession session,
//                              RedirectAttributes rttr) {
//        logger.info("POST - /point/earn 요청: 포인트 적립 시도 - 금액: {}, 사유: {}", amount, reason);
//
//        Integer memberIdx = (Integer) session.getAttribute("member_idx");
//        if (memberIdx == null) {
//            rttr.addFlashAttribute("message", "로그인이 필요합니다.");
//            return "redirect:/member/login";
//        }
//
//        if (amount <= 0) {
//            rttr.addFlashAttribute("message", "적립할 포인트는 0보다 커야 합니다.");
//            return "redirect:/point/history"; // 또는 적립 폼 페이지
//        }
//
//        try {
//            PointVO pointVO = new PointVO();
//            pointVO.setMember_idx(memberIdx);
//            pointVO.setChange_amount(amount); // 적립은 양수
//            pointVO.setChange_reason(reason);
//            pointVO.setPoint_status("적립완료"); // 상태 설정
//
//            pointHistoryService.earnPoint(pointVO); // 포인트 적립 서비스 호출
//
//            rttr.addFlashAttribute("message", amount + " 포인트가 성공적으로 적립되었습니다.");
//            logger.info("회원 ID {} 에게 {} 포인트 적립 성공. 사유: {}", memberIdx, amount);
//            return "redirect:/point/history"; // 적립 후 포인트 내역 페이지로 리다이렉트
//        } catch (Exception e) {
//            logger.error("회원 ID {} 의 포인트 {} 적립 중 오류 발생: {}", memberIdx, amount);
//            rttr.addFlashAttribute("message", "포인트 적립 중 오류가 발생했습니다: " + e.getMessage());
//            return "redirect:/point/history"; // 오류 발생 시에도 내역 페이지로 리다이렉트
//        }
//    }
//
//}
//    
