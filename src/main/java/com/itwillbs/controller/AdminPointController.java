package com.itwillbs.controller;

import com.itwillbs.domain.MemberVO;
import com.itwillbs.domain.PointVO;
import com.itwillbs.service.PointHistoryService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminPointController {

    private static final Logger logger = LoggerFactory.getLogger(AdminPointController.class);

    private final PointHistoryService pointService;

    @Autowired
    public AdminPointController(PointHistoryService pointService) {
        this.pointService = pointService;
    }

    @GetMapping("/pointHistory")
    public String userPointHistoryPage(@RequestParam("member_idx") int member_idx, Model model) throws Exception {
        logger.info("GET - /admin/points/history?member_idx={} 호출", member_idx);

        // 1. 서비스 호출: 특정 회원의 전체 포인트 내역 가져오기
        List<PointVO> historyList = pointService.getPointHistoryByMemberIdx(member_idx);

        // 2. 현재 보유 포인트 계산
        int currentPoints = 0;
        if (!historyList.isEmpty()) {
            // 리스트의 첫 번째 항목이 가장 최신 내역이므로, 그 내역의 point_amount가 현재 보유 포인트
            currentPoints = historyList.get(0).getPoint_amount();
        }

        // 3. (임시) 회원 정보 생성
        MemberVO member = new MemberVO();
        member.setMember_idx(member_idx);
        member.setMember_name("회원 " + member_idx); // 임시 이름
        // member.setPoint(currentPoints); // MemberVO에 point 필드가 있다면 설정 가능

        // 4. 모델에 데이터 담기
        model.addAttribute("member", member);
        model.addAttribute("historyList", historyList);
        model.addAttribute("currentPoints", currentPoints); // 현재 포인트를 별도로 전달

        return "admin/pointHistory";
    }
}