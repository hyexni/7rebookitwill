package com.itwillbs.controller;

import com.itwillbs.domain.PointVO;
import com.itwillbs.service.PointHistoryService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping; // POST 요청을 위해 추가
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam; // 요청 파라미터를 받기 위해 추가
import org.springframework.web.servlet.mvc.support.RedirectAttributes; // 리다이렉트 시 데이터 전달을 위해 추가


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

    // http://localhost:8088/point/history
    // 회원의 포인트 내역을 조회하는 GET 요청 처리
    @GetMapping("/history")
    public String getMemberPointHistory(HttpSession session, Model model, HttpServletRequest request) {
        logger.info("GET - /point/history 요청: 회원 포인트 내역 조회");

        // [수정] 기존 세션 로그인 확인 로직을 주석 처리합니다.
       
        // 1. 세션에서 로그인된 회원 ID(member_idx) 가져오기
       
        Integer member_idx = (Integer) session.getAttribute("member_idx");
       

        if (member_idx == null) {
            logger.info("로그인되지 않은 사용자입니다. 로그인 페이지로 리다이렉트합니다.");
            
            // ==== 추가된 부분 시작 ====
            // 사용자가 원래 요청했던 URL을 세션에 저장
            // 현재 요청 URL (쿼리 파라미터 포함)
            String requestUri = request.getRequestURI();
            String queryString = request.getQueryString();
            String fullRequestUrl = requestUri + (queryString != null ? "?" + queryString : "");
            session.setAttribute("redirectAfterLogin", fullRequestUrl);
            logger.info("로그인 후 리다이렉트될 URL 저장: {}", fullRequestUrl);
            // ==== 추가된 부분 끝 ====
            
            model.addAttribute("message", "포인트 내역을 보려면 로그인이 필요합니다."); 
            logger.info("로그인필요()");// 로그인 페이지에 메시지 전달
            return "redirect:/member/login";
        }
        

        // [추가] 개발 및 테스트를 위해 member_idx를 1로 고정합니다.
       // Integer member_idx = 1;
        //logger.info("테스트용 회원 ID 고정: member_idx = {}", member_idx);


        try {
        	
        	logger.info(member_idx+"");
            // 2. PointHistoryService를 호출하여 해당 회원의 포인트 내역 목록 가져오기
           List<PointVO> pointHistoryList = pointHistoryService.getPointHistory(member_idx);
                  
            logger.info("로그인 포인트내역목록");

            // 3. 현재 회원의 총 포인트 잔액도 함께 가져와 모델에 추가 (옵션)
            // 이 기능이 PointHistoryService에 추가되어야 합니다. (예: getTotalPoints(member_idx))
            Integer totalPoints = pointHistoryService.getTotalPoints(member_idx); // getTotalPoints() 메서드 추가 필요

            // 4. 가져온 데이터를 Model에 담아 View로 전달
            model.addAttribute("pointHistoryList", pointHistoryList);
            model.addAttribute("totalPoints", totalPoints); // 총 포인트 잔액
            logger.info("회원 ID {} 의 포인트 내역 (총 포인트: {})을 성공적으로 조회했습니다.", member_idx, totalPoints);
        
            
            // 5. 포인트 내역을 보여줄 View 페이지 이름 반환
            return "point/history"; // src/main/webapp/WEB-INF/views/point/history.jsp
            
            
        } catch (Exception e) {
            // 6. 포인트 내역 조회 중 오류 발생 시, 오류 메시지를 Model에 담아 에러 페이지로 전달
            logger.error("회원 ID {} 의 포인트 내역 조회 중 오류 발생: {}", member_idx, e.getMessage());
            model.addAttribute("errorMessage", "포인트 내역을 불러오는 중 오류가 발생했습니다.");
            return "error/errorPage"; // 공통 에러 페이지
        }
    }
}
 