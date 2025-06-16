package com.itwillbs.controller;

import com.itwillbs.domain.MemberVO;
import com.itwillbs.domain.PointVO;
import com.itwillbs.service.PointHistoryService;
//import com.itwillbs.service.MemberService; // MemberService 완성 전까지 주석 유지
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import javax.inject.Inject;
import javax.servlet.http.HttpSession; // HttpSession import
import java.util.List;

@Controller
@RequestMapping("/admin/points")
public class AdminPointController {
    
    private static final Logger logger = LoggerFactory.getLogger(AdminPointController.class);
    
    @Inject
    private PointHistoryService pointService;
    
    // @Inject
    // private MemberService memberService; // MemberService 완성 후 주석 해제

    
    //http://localhost:8088/admin/pointHistory
    /**
     * 현재 로그인한 관리자 또는 특정 사용자의 포인트 내역을 확인하는 페이지 (임시 로그인 기능)
     * 예: /admin/points/my-history
     */
    @GetMapping("/my-history")
    public String myPointHistoryPage(HttpSession session, Model model) throws Exception {
        logger.info("GET - /admin/points/my-history 호출");

        // [핵심] 임시 로그인 기능: 세션에 사용자 정보가 없으면 임시로 설정
        Integer member_idx = (Integer) session.getAttribute("member_idx");
        if (member_idx == null) {
            member_idx = 1; // 임시로 1번 회원을 로그인된 것으로 간주
            session.setAttribute("member_idx", member_idx);
            session.setAttribute("user_name", "임시관리자"); // View에 표시할 이름도 임시로 설정
            logger.info("임시 로그인 처리: 사용자 ID {}", member_idx);
        }

        // [수정] MemberService 대신 임시 MemberVO 객체 생성
        // 나중에 실제 MemberService가 완성되면 이 부분은 memberService.getMemberInfo(member_idx)로 교체합니다.
        MemberVO member = new MemberVO();
        member.setMember_idx(member_idx);
        member.setMember_name((String) session.getAttribute("user_name"));
        
        // [수정] 주입받은 인스턴스(pointService)를 통해 메서드 호출
        List<PointVO> historyList = pointService.getPointHistoryByMember(member_idx);
        
        // 모델에 담아 뷰로 전달
        model.addAttribute("member", member);
        model.addAttribute("historyList", historyList);
        
        return "admin/pointHistory";
    }
}