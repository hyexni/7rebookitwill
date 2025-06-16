package com.itwillbs.controller;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

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

    @GetMapping("/history") // 새로운 URL 경로
    public String getPointAccumulationList(Model model) {
        // 1. 현재 월 데이터 설정 (예시: 실제로는 동적으로 현재 월을 가져오거나 파라미터로 받을 수 있습니다.)
        LocalDate today = LocalDate.now();
        String currentMonth = String.valueOf(today.getMonthValue()); // 예: "6"
        String startDate = today.withDayOfMonth(1).format(DateTimeFormatter.ofPattern("yyyy.MM.dd")); // 예: "2025.06.01"
        String endDate = today.withDayOfMonth(today.lengthOfMonth()).format(DateTimeFormatter.ofPattern("MM.dd")); // 예: "06.30"

//        // 2. 전체 포인트 내역 가져오기
//        List<PointHistory> allPointHistories = pointHistoryService.getAllPointHistories();
//
//        // 3. 현재 월의 데이터만 필터링 (간단한 예시, 실제로는 DB 쿼리에서 월별 조회하는 것이 효율적)
//        List<PointHistory> currentMonthHistories = allPointHistories.stream()
//            .filter(h -> h.getChangeDate() != null && h.getChangeDate().toLocalDate().getMonth() == today.getMonth() && h.getChangeDate().toLocalDate().getYear() == today.getYear())
//            .collect(Collectors.toList());

//        // 4. 각 카테고리별 금액 및 총 적립 혜택 계산 (changeAmount가 양수인 경우만 적립으로 간주)
//        int totalBenefitAmount = 0;
//        int purchaseAmount = 0;
//        int receiptAmount = 0;
//        int reviewAmount = 0;
//        int eventAmount = 0; // 기타/이벤트
//
//        for (PointHistory history : currentMonthHistories) {
//            if (history.getChangeAmount() > 0) { // 적립인 경우만 계산
//                totalBenefitAmount += history.getChangeAmount();
//
//                // 실제 애플리케이션에서는 changeReason을 파싱하거나, 별도의 카테고리 필드를 사용하여 분류합니다.
//                // 여기서는 예시를 위해 changeReason의 특정 문자열 포함 여부로 분류합니다.
//                if (history.getChangeReason() != null) {
//                    if (history.getChangeReason().contains("구매")) {
//                        purchaseAmount += history.getChangeAmount();
//                    } else if (history.getChangeReason().contains("영수증")) {
//                        receiptAmount += history.getChangeAmount();
//                    } else if (history.getChangeReason().contains("리뷰")) {
//                        reviewAmount += history.getChangeAmount();
//                    } else { // 기타 또는 이벤트로 분류
//                        eventAmount += history.getChangeAmount();
//                    }
//                } else {
//                    eventAmount += history.getChangeAmount(); // 사유가 없으면 기타로
//                }
//            }
//        }

        // 5. Model에 데이터 추가
//        model.addAttribute("totalBenefitAmount", totalBenefitAmount);
//        model.addAttribute("purchaseAmount", purchaseAmount);
//        model.addAttribute("receiptAmount", receiptAmount);
//        model.addAttribute("reviewAmount", reviewAmount);
//        model.addAttribute("eventAmount", eventAmount);
//        model.addAttribute("currentMonth", currentMonth);
//        model.addAttribute("startDate", startDate);
//        model.addAttribute("endDate", endDate);
//        model.addAttribute("pointHistoryList", currentMonthHistories); // 필터링된 현재 월의 내역 전달

        return "point/history"; // JSP 파일 이름
    }
}