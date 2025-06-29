package com.itwillbs.controller;

// --- 필요한 import문 ---
import com.itwillbs.domain.ReceiptVO;
import com.itwillbs.service.PointHistoryService;
import com.itwillbs.service.ReceiptProcessingException;
import com.itwillbs.service.ReceiptService;

import lombok.RequiredArgsConstructor; // [추가] 롬복
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/receipt")
@RequiredArgsConstructor // [수정] final 필드에 대한 생성자 자동 생성을 위해 추가
public class ReceiptController {

    private static final Logger logger = LoggerFactory.getLogger(ReceiptController.class);

    // [수정] 의존성 주입: 생성자 주입 방식으로 변경 (더 권장되는 방식)
    private final ReceiptService receiptService;

    // GET 요청: 업로드 폼 페이지
    @GetMapping("/upload")
    public String receiptUploadForm(HttpSession session, RedirectAttributes redirectAttributes, HttpServletRequest request) {
        logger.info("GET - /receipt/upload");

        Integer memberIdx = (Integer) session.getAttribute("member_idx");

        if (memberIdx == null) {
            // [수정] alert.jsp와 연동을 위해 키를 'msg', 'icon'으로 변경
            redirectAttributes.addFlashAttribute("msg", "로그인이 필요한 서비스입니다.");
            redirectAttributes.addFlashAttribute("icon", "warning"); // 아이콘 추가

            String destination = request.getRequestURI();
            session.setAttribute("redirectAfterLogin", destination);
            logger.info("로그인 후 이동할 URL 저장: {}", destination);

            return "redirect:/member/login";
        }

        return "receipt/upload";
    }

    // POST 요청: 파일 업로드 처리
    @PostMapping("/upload")
    public String receiptUploadPost(MultipartFile file, RedirectAttributes redirectAttributes, HttpSession session) {
        logger.info("POST - /receipt/upload - 파일명: {}", file.getOriginalFilename());

        Integer memberIdx = (Integer) session.getAttribute("member_idx");
        if (memberIdx == null) {
            // [수정] alert.jsp와 연동을 위해 키를 'msg', 'icon'으로 변경
            redirectAttributes.addFlashAttribute("msg", "세션이 만료되었거나 로그인이 필요합니다.");
            redirectAttributes.addFlashAttribute("icon", "error");
            return "redirect:/member/login";
        }

        // === 파일 유효성 검사 (Controller에서 처리하는 좋은 예) ===
        if (file.isEmpty()) {
            redirectAttributes.addFlashAttribute("msg", "업로드할 파일을 선택해주세요.");
            redirectAttributes.addFlashAttribute("icon", "warning");
            return "redirect:/receipt/upload";
        }

        final long MAX_SIZE = 10 * 1024 * 1024;
        if (file.getSize() > MAX_SIZE) {
            redirectAttributes.addFlashAttribute("msg", "최대 10MB 이하의 파일만 업로드 가능합니다.");
            redirectAttributes.addFlashAttribute("icon", "warning");
            return "redirect:/receipt/upload";
        }

        String contentType = file.getContentType();
        if (contentType == null || (!contentType.equals("image/jpeg") && !contentType.equals("image/png") && !contentType.equals("application/pdf"))) {
            redirectAttributes.addFlashAttribute("msg", "허용되지 않는 파일 형식입니다.\n(JPG, PNG, PDF만 가능)");
            redirectAttributes.addFlashAttribute("icon", "warning");
            return "redirect:/receipt/upload";
        }
        
        // ================== [수정] Service 호출 및 예외 처리 로직 전체 수정 ==================
        try {
            // 서비스 로직 호출
            ReceiptVO resultVO = receiptService.processAndSaveReceipt(file, memberIdx);
            
            // 성공 시, 적립된 포인트를 포함한 동적 메시지 생성
            String successMsg = String.format(
                "영수증 인증이 성공적으로 완료되었습니다.\n\n✨ %d 포인트가 적립되었습니다!", 
                resultVO.getEarnedPoints()
            );

            redirectAttributes.addFlashAttribute("uploadResult", resultVO); // 결과 페이지에서 상세 내용을 보여주기 위해 전달
            redirectAttributes.addFlashAttribute("msg", successMsg);
            redirectAttributes.addFlashAttribute("icon", "success");
            
            return "redirect:/receipt/upload-result";
        
        } catch (ReceiptProcessingException e) {  
            // [수정] 우리가 만든 사용자 정의 예외(비즈니스 로직 오류)를 우선 처리
            logger.warn("영수증 처리 중 오류 발생: {}", e.getMessage());
            redirectAttributes.addFlashAttribute("msg", e.getMessage()); // Service에서 보낸 메시지를 그대로 사용
            redirectAttributes.addFlashAttribute("icon", "error");
            return "redirect:/receipt/upload";

        } catch (Exception e) {
            // 그 외 예측하지 못한 모든 서버 내부 오류
            logger.error("영수증 처리 중 심각한 오류 발생", e);
            redirectAttributes.addFlashAttribute("msg", "처리 중 오류가 발생했습니다.\n잠시 후 다시 시도해주세요.");
            redirectAttributes.addFlashAttribute("icon", "error");
            return "redirect:/receipt/upload";
        }
        // ================== 수정 끝 ==================
    }

    // GET 요청: 업로드 결과 페이지
    @GetMapping("/upload-result")
    public String uploadResultPage() {
        logger.info("GET - /receipt/upload-result");
        return "receipt/uploadresult"; // -> 이 JSP 파일에 alert.jsp가 include 되어 있어야 함
    }
}