package com.itwillbs.controller;

import com.itwillbs.domain.ReceiptVO;
import com.itwillbs.service.ReceiptService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

//http://localhost:8088/receipt/upload
@Controller
@RequestMapping("/receipt")
public class ReceiptController {

    private static final Logger logger = LoggerFactory.getLogger(ReceiptController.class);

    @Inject
    private ReceiptService receiptService;

    // GET 요청: 업로드 폼 페이지를 보여줌
    @GetMapping("/upload")
    public String receiptUploadForm() {
        logger.info("GET - /receipt/upload");
        return "receipt/upload";
    }

    // POST 요청: 파일 업로드 처리
    @PostMapping("/upload")
    public String receiptUploadPost(MultipartFile file, RedirectAttributes redirectAttributes, HttpSession session) {
        logger.info("POST - /receipt/upload - 파일명: {}", file.getOriginalFilename());

        //Integer memberIdx = (Integer) session.getAttribute("member_idx");
       // if (memberIdx == null) {
       //     redirectAttributes.addFlashAttribute("message", "오류: 로그인이 필요합니다.");
     //       return "redirect:/member/login";
     //   } // [수정] if문을 닫는 괄호 '}'를 추가했습니다.

       int memberIdx = 1; // 임시 회원 ID

        try {
            // ✅ 아래 메서드 이름을 인터페이스와 일치하도록 수정했습니다.
            // rService.processReceiptUpload(file, memberIdx) -> receiptService.processAndSaveReceipt(file, memberIdx)
            ReceiptVO resultVO = receiptService.processAndSaveReceipt(file, memberIdx);
            
            // 처리가 성공하면 결과 객체를 다음 페이지로 전달
            redirectAttributes.addFlashAttribute("uploadResult", resultVO);
            return "redirect:/receipt/upload-result";

        } catch (Exception e) {
            // 서비스 처리 중 예외 발생 시, 에러 메시지를 업로드 페이지로 전달
            logger.error("영수증 처리 중 오류 발생", e);
            redirectAttributes.addFlashAttribute("message", e.getMessage());
            return "redirect:/receipt/upload";
        
        }
    }

    // GET 요청: 업로드 결과 페이지를 보여줌
    @GetMapping("/upload-result")
    public String uploadResultPage() {
        logger.info("GET - /receipt/upload-result");
        return "receipt/uploadresult";
    }
}