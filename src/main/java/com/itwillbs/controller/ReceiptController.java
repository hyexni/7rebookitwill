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
import javax.servlet.http.HttpServletRequest; // ✅ HttpServletRequest 임포트
import javax.servlet.http.HttpSession;

// http://localhost:8088/receipt/upload
@Controller
@RequestMapping("/receipt")
public class ReceiptController {

    private static final Logger logger = LoggerFactory.getLogger(ReceiptController.class);

    @Inject
    private ReceiptService receiptService;

    // GET 요청: 업로드 폼 페이지를 보여줌
    @GetMapping("/upload")
    public String receiptUploadForm(HttpSession session, RedirectAttributes redirectAttributes, HttpServletRequest request) { // ✅ HttpServletRequest 파라미터 추가
        logger.info("GET - /receipt/upload");

        // 세션에서 회원 정보를 가져옴
        Integer memberIdx = (Integer) session.getAttribute("member_idx");

        // 만약 로그인되어 있지 않다면(memberIdx가 null이라면)
        if (memberIdx == null) {
            // 리다이렉트 시 메시지를 일회성으로 전달
            redirectAttributes.addFlashAttribute("message", "로그인이 필요한 서비스입니다.");
            
            // ✅==== 기능 추가 시작 ====
            // 사용자가 원래 요청했던 목적지 URL을 세션에 저장
            String destination = request.getRequestURI();
            session.setAttribute("redirectAfterLogin", destination);
            logger.info("로그인 후 이동할 URL 저장: {}", destination);
            // ✅==== 기능 추가 끝 ====

            // 로그인 페이지로 이동시킴
            return "redirect:/member/login";
        }
        
        // 로그인 상태라면 정상적으로 업로드 페이지를 보여줌
        return "receipt/upload";
    }

    // POST 요청: 파일 업로드 처리
    @PostMapping("/upload")
    public String receiptUploadPost(MultipartFile file, RedirectAttributes redirectAttributes, HttpSession session) {
        logger.info("POST - /receipt/upload - 파일명: {}", file.getOriginalFilename());

        Integer memberIdx = (Integer) session.getAttribute("member_idx");
        if (memberIdx == null) {
            redirectAttributes.addFlashAttribute("message", "오류: 로그인이 필요합니다.");
            // POST 요청에서는 이전 목적지를 저장할 필요가 없으므로 바로 리다이렉트
            return "redirect:/member/login";
        }

        try {
            // 영수증 처리 로직
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