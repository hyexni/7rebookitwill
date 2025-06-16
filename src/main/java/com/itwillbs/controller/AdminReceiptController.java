// com/itwillbs/controller/AdminController.java

package com.itwillbs.controller;

import com.itwillbs.domain.ReceiptVO;
import com.itwillbs.service.ReceiptService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import javax.inject.Inject;
import java.util.List;

@Controller
@RequestMapping("/admin") // 모든 관리자 관련 URL은 /admin으로 시작
public class AdminReceiptController {

    private static final Logger logger = LoggerFactory.getLogger(AdminReceiptController.class);

    @Inject
    private ReceiptService receiptService;

    /**
     * 영수증 관리 페이지 (목록 조회)
     */
//    //http://localhost:8088/admin/receiptList
//    @GetMapping("/receiptList")
//    public String receiptListPage(Model model) throws Exception {
//        logger.info("GET - /admin/receipts 호출");
////        
//        // 서비스를 통해 모든 영수증 목록을 가져옴
//        List<ReceiptVO> receiptList = receiptService.getAllReceipts();
//        
//        // 모델에 담아 뷰로 전달
//        model.addAttribute("receiptList", receiptList);
//        
//        // 관리자 페이지 JSP로 이동
//        return "admin/receiptList";
//        
//    
}