package com.itwillbs.controller;

import com.itwillbs.domain.PointVO;
import com.itwillbs.service.PointHistoryService;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/point") // 포인트 관련 URL의 기본 경로
public class PointHistoryController {

    private static final Logger logger = LoggerFactory.getLogger(PointHistoryController.class);

    @Inject
    private PointHistoryService pointHistoryService;

    /**
     * 회원의 포인트 내역 및 총 포인트를 조회하는 메서드
     * URL: GET /point/history
     */
    @GetMapping("/history")
    public String getMemberPointHistory(HttpSession session, Model model, HttpServletRequest request, RedirectAttributes redirectAttributes) {
        logger.info("GET - /point/history 요청: 회원 포인트 내역 조회");

        Integer member_idx = (Integer) session.getAttribute("member_idx");

        if (member_idx == null) {
            logger.info("로그인되지 않은 사용자입니다. 로그인 페이지로 리다이렉트합니다.");
            
            // 사용자가 원래 가려던 URL을 세션에 저장 (로그인 후 원래 페이지로 이동시키기 위함)
            String fullRequestUrl = getFullRequestUrl(request);
            session.setAttribute("redirectAfterLogin", fullRequestUrl);
            logger.info("로그인 후 리다이렉트될 URL 저장: {}", fullRequestUrl);
            
            // [수정됨] Model 대신 RedirectAttributes 사용
            redirectAttributes.addFlashAttribute("message", "포인트 내역을 보려면 로그인이 필요합니다.");
            return "redirect:/member/login";
        }

        try {
            logger.info("회원 ID: {}", member_idx);
            
            List<PointVO> pointHistoryList = pointHistoryService.getPointHistory(member_idx);
            Integer totalPoints = pointHistoryService.getTotalPoints(member_idx);
            
            model.addAttribute("pointHistoryList", pointHistoryList);
            model.addAttribute("totalPoints", totalPoints != null ? totalPoints : 0); // null일 경우 0으로 표시
            
            logger.info("회원 ID {} 의 포인트 내역 (총 포인트: {})을 성공적으로 조회했습니다.", member_idx, totalPoints);
            
            return "point/history"; // 뷰 페이지: /WEB-INF/views/point/history.jsp
            
        } catch (Exception e) {

            logger.info("회원 ID {} 의 포인트 내역 조회 중 오류 발생", member_idx, e);
            model.addAttribute("errorMessage", "포인트 내역을 불러오는 중 오류가 발생했습니다.");
            return "error/errorPage"; 
        }
    }

    /**
     * [기능 추가] 포인트 적립을 처리하는 메서드 (예: 영수증 인증 후)
     * URL: POST /point/earn
     */
    @PostMapping("/earn")
    public String earnPoint(HttpSession session, @RequestParam("amount") int amount, @RequestParam("reason") String reason, RedirectAttributes redirectAttributes) {
        logger.info("POST - /point/earn 요청: 포인트 적립 처리");
        
        Integer member_idx = (Integer) session.getAttribute("member_idx");
        if (member_idx == null) {
            redirectAttributes.addFlashAttribute("message", "로그인이 필요합니다.");
            return "redirect:/member/login";
        }

        if (amount <= 0) {
            redirectAttributes.addFlashAttribute("errorMessage", "적립할 포인트는 0보다 커야 합니다.");
            return "redirect:/point/history"; // 혹은 이전 페이지
        }

        PointVO pointVO = new PointVO();
        pointVO.setMember_idx(member_idx);
        pointVO.setChange_amount(amount); // 적립 포인트 (양수)
        pointVO.setChange_reason(reason);

        try {
            pointHistoryService.earnPoint(pointVO);
            redirectAttributes.addFlashAttribute("successMessage", amount + "포인트가 성공적으로 적립되었습니다.");

           
            logger.info("회원 ID 에게 포인트 적립 성공사유:", amount, reason);
        } catch (Exception e) {
            logger.info("회원 ID 의 포인트 적립 중 오류 발생: ",  e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "포인트 적립 중 오류가 발생했습니다.");
        }
        
        return "redirect:/point/history";
    }

    /**
     * [기능 추가] 포인트 사용을 처리하는 메서드 (예: 상품 구매 시)
     * URL: POST /point/use
     */
    @PostMapping("/use")
    public String usePoint(HttpSession session, @RequestParam("amount") int amount, @RequestParam("reason") String reason, RedirectAttributes redirectAttributes) {
        logger.info("POST - /point/use 요청: 포인트 사용 처리");

        Integer member_idx = (Integer) session.getAttribute("member_idx");
        if (member_idx == null) {
            redirectAttributes.addFlashAttribute("message", "로그인이 필요합니다.");
            return "redirect:/member/login";
        }

        if (amount <= 0) {
            redirectAttributes.addFlashAttribute("errorMessage", "사용할 포인트는 0보다 커야 합니다.");
            return "redirect:/point/history"; // 혹은 이전 페이지
        }

        PointVO pointVO = new PointVO();
        pointVO.setMember_idx(member_idx);
        pointVO.setChange_amount(-amount); // 사용 포인트는 음수로 처리
        pointVO.setChange_reason(reason);

        try {
            pointHistoryService.usePoint(pointVO);
            redirectAttributes.addFlashAttribute("successMessage", amount + "포인트를 성공적으로 사용했습니다.");
            logger.info("회원 ID 포인트 사용 성공. 사유",  amount, reason);
        } catch (Exception e) {
            logger.info("회원 ID 포인트 사용 중 오류 발생: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("errorMessage", "포인트 사용 중 오류가 발생했습니다: " + e.getMessage());
        }

       
        return "redirect:/point/history";
    }

    /**
     * 요청 URL 전체를 가져오는 보조 메서드
     */
    private String getFullRequestUrl(HttpServletRequest request) {
        String requestUri = request.getRequestURI();
        String queryString = request.getQueryString();
        return requestUri + (queryString != null ? "?" + queryString : "");
    }
}