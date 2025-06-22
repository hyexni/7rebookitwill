package com.itwillbs.controller;

import com.itwillbs.domain.Criteria; // 페이징 기능이 통합된 Criteria 클래스
import com.itwillbs.dto.AdminReceiptDTO;
import com.itwillbs.service.ReceiptService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.inject.Inject;
import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminReceiptController {

    private static final Logger logger = LoggerFactory.getLogger(AdminReceiptController.class);

    @Inject
    private ReceiptService receiptService;

    // GET: /admin/receiptList
    @GetMapping("/receiptList")
    public String receiptListGET(@ModelAttribute("cri") Criteria cri, Model model) throws Exception {
        logger.info("C: 관리자 영수증 목록 페이지 GET (All-in-One Criteria 사용)");

        // 1. 서비스에서 전체 데이터 개수를 가져와서 Criteria 객체에 설정
        // 이 과정을 통해 Criteria 객체 내부에서 페이징 계산이 모두 완료됩니다.
        cri.setTotalCount(receiptService.getReceiptTotalCount(cri));
        
        // 2. 서비스에서 현재 페이지에 해당하는 목록 데이터를 가져옴
        List<AdminReceiptDTO> receiptList = receiptService.getReceiptListAdmin(cri);

        // 3. Model 객체에 데이터를 담아서 View로 전달
        model.addAttribute("receiptList", receiptList);
        // => @ModelAttribute("cri")를 사용했기 때문에, 계산이 완료된 cri 객체는 자동으로 Model에 담깁니다.
        //    JSP에서는 ${cri.startPage}, ${cri.endPage} 등으로 바로 사용할 수 있습니다.

        return "admin/receiptList";
    }
}