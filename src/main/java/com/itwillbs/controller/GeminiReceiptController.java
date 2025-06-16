package com.itwillbs.controller;

import com.itwillbs.domain.ReceiptVO;
import com.itwillbs.service.ReceiptService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;


//http://localhost:8088/receipt/upload
@Controller
@RequestMapping("/gemini-receipt")
public class GeminiReceiptController {

    private static final Logger logger = LoggerFactory.getLogger(GeminiReceiptController.class);

    @Inject
    private ReceiptService receiptService; // rService -> receiptService로 이름 변경 (가독성)

    // GET /gemini-receipt/upload : 업로드 폼 페이지 보여주기
    @GetMapping("/upload")
    public String uploadForm() {
        logger.info("GET - Gemini Upload Form");
        return "receipt/upload"; // /WEB-INF/views/receipt/upload.jsp
    }

    // POST /gemini-receipt/upload : 파일 업로드 및 처리 요청
    @PostMapping("/upload")
    public String uploadPost(MultipartFile file, RedirectAttributes redirectAttributes, HttpSession session) {
        logger.info("POST - Gemini Upload. Filename: {}", file.getOriginalFilename());

        // 파일 유효성 검사는 서비스 계층에서 처리하거나, 간단한 검사는 여기서 해도 됨
        if (file.isEmpty()) {
            redirectAttributes.addFlashAttribute("message", "파일이 선택되지 않았습니다.");
            return "redirect:/gemini-receipt/upload";
        }

        // 임시 회원 ID (실제로는 세션에서 가져와야 함)
        int memberIdx = 1; 
        // Integer memberIdxFromSession = (Integer) session.getAttribute("member_idx");
        // if (memberIdxFromSession == null) { ... }

        try {
            // ✅ 서비스의 단일 메서드 호출로 모든 복잡한 처리를 위임!
            ReceiptVO result = receiptService.processAndSaveReceipt(file, memberIdx);
            
            // 성공 시, 결과 객체를 리다이렉트 페이지로 전달
            redirectAttributes.addFlashAttribute("uploadResult", result);
            return "redirect:/gemini-receipt/upload-result";

        } catch (Exception e) {
            // 서비스에서 발생한 모든 예외를 여기서 처리
            logger.error("영수증 처리 중 오류 발생", e);
            redirectAttributes.addFlashAttribute("message", "오류: " + e.getMessage());
            return "redirect:/gemini-receipt/upload";
        }
    }

    // GET /gemini-receipt/upload-result : 처리 결과 페이지 보여주기
    @GetMapping("/upload-result")
    public String uploadResultPage() {
        logger.info("GET - Gemini Upload Result Page");
        return "receipt/uploadresult"; // /WEB-INF/views/receipt/uploadresult.jsp
    }
}