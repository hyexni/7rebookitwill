package com.itwillbs.controller;

import com.itwillbs.domain.ReceiptVO;
import com.itwillbs.service.PointHistoryService;
import com.itwillbs.service.ReceiptService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
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

   // @Inject
  //  private ReceiptService receiptService;

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

    
    @Autowired
    private ReceiptService receiptService; // 영수증 처리 서비스

    @Autowired
    private PointHistoryService pointService; // 포인트 처리 서비스
    
    // POST 요청: 파일 업로드 처리 [최종 수정 버전]
    @PostMapping("/upload")
    public String receiptUploadPost(MultipartFile file, RedirectAttributes redirectAttributes, HttpSession session) {
        logger.info("POST - /receipt/upload - 파일명: {}", file.getOriginalFilename());

        Integer memberIdx = (Integer) session.getAttribute("member_idx");
        if (memberIdx == null) {
            redirectAttributes.addFlashAttribute("message", "오류: 세션이 만료되었거나 로그인이 필요합니다.");
            return "redirect:/member/login";
        }

        // ================== 파일 유효성 검사 시작 ==================
        // 1. 파일이 비어있는지 확인
        if (file.isEmpty()) {
            redirectAttributes.addFlashAttribute("message", "업로드할 파일을 선택해주세요.");
            return "redirect:/receipt/upload";
        }

        // 2. 파일 용량 확인 (10MB 제한)
        final long MAX_SIZE = 10 * 1024 * 1024; // 10MB
        if (file.getSize() > MAX_SIZE) {
            redirectAttributes.addFlashAttribute("message", "최대 10MB 이하의 파일만 업로드 가능합니다.");
            return "redirect:/receipt/upload";
        }

        // 3. 파일 확장자 확인 (JPG, PNG, PDF)
        String contentType = file.getContentType();
        if (contentType == null || (!contentType.equals("image/jpeg") && !contentType.equals("image/png") && !contentType.equals("application/pdf"))) {
            redirectAttributes.addFlashAttribute("message", "허용되지 않는 파일 형식입니다. (JPG, PNG, PDF만 가능)");
            return "redirect:/receipt/upload";
        }
        // ================== 파일 유효성 검사 끝 ==================

        try {
            // 서비스 로직 호출
            ReceiptVO resultVO = receiptService.processAndSaveReceipt(file, memberIdx);
            
            // 성공 시 결과 페이지로 이동
            redirectAttributes.addFlashAttribute("uploadResult", resultVO);
            redirectAttributes.addFlashAttribute("message", "영수증 인증이 성공적으로 완료되었습니다!");
            return "redirect:/receipt/upload-result";
        
        // ================== [수정] 상세한 예외 처리 시작 ==================
        } catch (IllegalStateException e) { 
            // [중복 업로드] 예외를 처리 (Service에서 IllegalStateException을 발생시켰으므로)
            logger.warn("중복 영수증 업로드 시도: {}", e.getMessage());
            redirectAttributes.addFlashAttribute("message", e.getMessage()); // "이미 등록된 영수증입니다..." 메시지 전달
            return "redirect:/receipt/upload";
        } catch (RuntimeException e) { 
            // [OCR 실패] 등 기타 런타임 예외를 처리 (Service에서 RuntimeException을 발생시켰으므로)
            // IllegalStateException도 RuntimeException의 자식이므로, 반드시 뒤에 위치해야 합니다.
            logger.warn("영수증 처리 중 런타임 오류 발생: {}", e.getMessage());
            redirectAttributes.addFlashAttribute("message", e.getMessage()); // "영수증 내용을 인식하지 못했습니다." 메시지 전달
            return "redirect:/receipt/upload";
        } catch (Exception e) {
            // 그 외 예측하지 못한 모든 서버 내부 오류
            logger.error("영수증 처리 중 심각한 오류 발생", e);
            redirectAttributes.addFlashAttribute("message", "처리 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
            return "redirect:/receipt/upload";
        }
        // ================== 상세한 예외 처리 끝 ==================
    }

    // GET 요청: 업로드 결과 페이지 (수정 없음)
    @GetMapping("/upload-result")
    public String uploadResultPage() {
        logger.info("GET - /receipt/upload-result");
        return "receipt/uploadresult";
    }
}