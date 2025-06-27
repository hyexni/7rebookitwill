package com.itwillbs.controller;

import com.itwillbs.dto.AdminReceiptDTO;
import com.itwillbs.dto.PageMakerDTO;
import com.itwillbs.service.AdminReceiptService;
import com.itwillbs.service.ReceiptService;
import com.itwillbs.domain.ReceiptVO;
import com.itwillbs.domain.SearchCriteria;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/admin/*")
public class AdminReceiptController {

    private static final Logger logger = LoggerFactory.getLogger(AdminReceiptController.class);
    
    @Inject
    private ReceiptService receiptService;
    
    @Inject
    private AdminReceiptService adminReceiptService;

    @GetMapping("/receiptList")
    public String receiptListGET(SearchCriteria cri, Model model) throws Exception {
        logger.info("C: 관리자 영수증 목록 페이지 GET (PageMakerDTO 사용)");

        // ========================= [ 추가된 기능 1: 기본 정렬 기준 설정 ] =========================
        // 사용자가 정렬 기준을 선택하지 않은 경우(최초 접속 시),
           if (cri.getSortColumn() == null || cri.getSortColumn().isEmpty()) {
            cri.setSortColumn("upload_id"); // 영수증 등록일 컬럼명 (DB 스키마에 맞게 수정 필요)
            cri.setSortOrder("DESC");         // 내림차순 (최신순)
        }
        // =======================================================================================

        // 서비스에서 현재 페이지와 검색/정렬 조건에 맞는 목록 데이터를 가져옵니다.
        List<AdminReceiptDTO> receiptList = receiptService.getReceiptListAdmin(cri);
        
        PageMakerDTO pageMaker = new PageMakerDTO();
        pageMaker.setCri(cri); 
        pageMaker.setTotalCount(receiptService.getReceiptTotalCount(cri)); 

        model.addAttribute("receiptList", receiptList);
        model.addAttribute("pageMaker", pageMaker); 

        // ========================= [ 추가된 기능 2: View에서 사용할 cri 객체 전달 ] =========================
        // JSP 뷰에서 정렬 링크(cri.sortUrl)나 페이지 링크(cri.pageUrl)를 생성하기 위해
        // 현재 검색 및 정렬 정보가 담긴 cri 객체를 모델에 추가합니다.
        model.addAttribute("cri", cri);
        // ==============================================================================================

        return "admin/receipt/receiptList";
    }
    
    /**
     * 영수증 ID를 받아 상세 정보를 조회하고 View로 전달합니다.
     * URL 예시: /admin/receipt/detail?upload_id=1
     * @param upload_id 조회할 영수증의 ID
     * @param model View에 데이터를 전달할 객체
     * @return 보여줄 View의 경로
     */
    @GetMapping("/receiptDetail")
    public String getReceiptDetail(@RequestParam("upload_id") int upload_id, Model model) {
        try {
            Map<String, Object> result = adminReceiptService.getReceiptDetail(upload_id);
            model.addAttribute("receiptDetail", result.get("ReceiptVO")); // View에서 사용할 이름 "receiptDetail"
            model.addAttribute("memberVO", result.get("MemberVO")); // View에서 사용할 이름 "receiptDetail"
            return "admin/receipt/detail"; // View 파일 경로: /WEB-INF/views/admin/receipt/detail.jsp
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("errorMessage", "영수증 정보를 불러오는 중 오류가 발생했습니다.");
            return "common/error"; // 에러 페이지
        }
    }
}