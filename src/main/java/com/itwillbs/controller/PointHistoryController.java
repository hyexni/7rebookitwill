package com.itwillbs.controller;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.itwillbs.domain.PointVO;
import com.itwillbs.service.PointHistoryService;

@Controller
@RequestMapping("/point/*")
public class PointHistoryController {

    private final PointHistoryService pointHistoryService;

    @Autowired
    public PointHistoryController(PointHistoryService pointHistoryService) {
        this.pointHistoryService = pointHistoryService;
    }

    @GetMapping("/history")
    public String getPointAccumulationList(Model model) {
        // 실제 운영 시에는 세션 등에서 로그인한 회원 ID를 가져와야 합니다.
        int memberIdx = 1; // 임시로 회원 번호를 1로 설정

        LocalDate today = LocalDate.now();
        String currentMonth = String.valueOf(today.getMonthValue());
        String startDate = today.withDayOfMonth(1).format(DateTimeFormatter.ofPattern("yyyy.MM.dd"));
        String endDate = today.withDayOfMonth(today.lengthOfMonth()).format(DateTimeFormatter.ofPattern("yyyy.MM.dd"));

        // 1. 서비스 호출 및 null 방어 (가장 중요)
        // DAO/Service에서 결과가 없을 때 null 대신 빈 List를 반환하는 것이 가장 좋습니다.
        // 하지만 만약을 대비해 Controller에서도 null을 체크합니다.
        List<PointVO> allPointHistoriesForMember = pointHistoryService.getPointHistoryByMemberIdx(memberIdx);
        if (allPointHistoriesForMember == null) {
            // 서비스가 null을 반환해도, 우리 코드는 멈추지 않고 안전하게 비어있는 목록으로 교체합니다.
            allPointHistoriesForMember = java.util.Collections.emptyList();
        }

        // 2. 스트림 필터링 시 null 방어
        // 데이터 목록 안에 null인 항목(PointVO 자체가 null)이 섞여 있더라도, 
        // 그리고 change_date가 null인 경우에도 안전하게 건너뜁니다.
        List<PointVO> currentMonthHistories = allPointHistoriesForMember.stream()
                .filter(h -> h != null && h.getChange_date() != null) // 객체 자체와 날짜가 null이 아닌 것만 통과
                .filter(h -> {
                    // 월/년 비교는 별도의 필터로 분리하여 가독성 확보
                    java.time.LocalDateTime changeDateTime = h.getChange_date().toLocalDateTime();
                    return changeDateTime.getMonth() == today.getMonth() && changeDateTime.getYear() == today.getYear();
                })
                .collect(Collectors.toList());

        // 3. 각 카테고리별 금액 계산
        int total_benefit_amount = 0;
        int purchase_amount = 0;
        int receipt_amount = 0;
        int review_amount = 0;
        int event_amount = 0;

        for (PointVO history : currentMonthHistories) {
            if (history.getChange_amount() > 0) { 
                total_benefit_amount += history.getChange_amount();

                String reason = history.getChange_reason();
                // 4. 사유(reason)가 null인 경우 방어
                if (reason != null) {
                    if (reason.contains("구매")) {
                        purchase_amount += history.getChange_amount();
                    } else if (reason.contains("영수증")) {
                        receipt_amount += history.getChange_amount();
                    } else if (reason.contains("리뷰")) {
                        review_amount += history.getChange_amount();
                    } else {
                        event_amount += history.getChange_amount();
                    }
                } else { // 사유가 null일 경우
                    event_amount += history.getChange_amount();
                }
            }
        }

        // 5. Model에 데이터 추가
        model.addAttribute("total_benefit_amount", total_benefit_amount);
        model.addAttribute("purchase_amount", purchase_amount);
        model.addAttribute("receipt_amount", receipt_amount);
        model.addAttribute("review_amount", review_amount);
        model.addAttribute("event_amount", event_amount);
        model.addAttribute("currentMonth", currentMonth);
        model.addAttribute("startDate", startDate);
        model.addAttribute("endDate", endDate);
        model.addAttribute("pointHistoryList", currentMonthHistories);

        return "point/history";
    }
}