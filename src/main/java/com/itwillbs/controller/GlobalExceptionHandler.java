package com.itwillbs.controller; 

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ui.Model; // [수정] Model 임포트
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import com.fasterxml.jackson.databind.exc.UnrecognizedPropertyException;
// [수정] RedirectAttributes는 더 이상 필요 없으므로 임포트 삭제 가능
// import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@ControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    /**
     * 파일 업로드 크기 초과 예외(MaxUploadSizeExceededException)를 처리하는 핸들러입니다.
     * [수정] 리다이렉트 대신 포워드 방식으로 변경하여 데이터 유실 문제를 해결합니다.
     * @param ex 발생한 예외 객체
     * @param model View에 데이터를 전달하기 위한 Model 객체
     * @return 렌더링할 JSP 뷰의 경로
     */
    @ExceptionHandler(MaxUploadSizeExceededException.class)
    public String handleMaxUploadSizeExceededException(MaxUploadSizeExceededException ex, Model model) {
        
        logger.warn("파일 업로드 크기 초과 오류 발생: {}", ex.getMessage());

        // [수정] RedirectAttributes 대신 Model에 직접 속성을 추가합니다.
        // 포워드 방식에서는 Model을 사용해야 데이터가 View로 전달됩니다.
        model.addAttribute("msg", "파일 크기가 너무 큽니다.최대 10MB까지 업로드할 수 있습니다.");
        model.addAttribute("icon", "error");

        // [수정] "redirect:/receipt/upload" 가 아닌, 렌더링할 JSP 파일의 경로를 직접 반환합니다.
        // WEB-INF/views/receipt/upload.jsp 파일을 렌더링하라는 의미입니다.
        return "receipt/upload";
    }
    
    // ======================================================================
    // ▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼ 이 부분 추가 ▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼▼
    // ======================================================================
    /**
     * Jackson JSON 파싱 중 인식할 수 없는 필드 예외(UnrecognizedPropertyException)를 처리합니다.
     * Gemini API가 예상된 데이터 대신 에러 객체(예: {"error": "..."})를 반환할 때 주로 발생합니다.
     * @param ex 발생한 예외 객체
     * @param model View에 데이터를 전달하기 위한 Model 객체
     * @return 랜더링할 JSP 뷰의 경로
     */
    @ExceptionHandler(UnrecognizedPropertyException.class)
    public String handleUnrecognizedPropertyException(UnrecognizedPropertyException ex, Model model) {
        // 개발자 확인용으로 어떤 필드에서 오류가 났는지 로그를 남깁니다.
        logger.warn("JSON 파싱 오류: DTO에 존재하지 않는 필드가 포함되어 있습니다. {}", ex.getMessage());

        // 사용자에게 보여줄 친절한 오류 메시지를 Model에 추가합니다.
        // 이 오류는 Gemini API가 영수증 인식을 실패했을 때 발생할 가능성이 높습니다.
        model.addAttribute("msg", "영수증 분석에 실패했습니다. 유효한 도서 구매 영수증이 아니거나 이미지 품질이 낮을 수 있습니다.");
        model.addAttribute("icon", "error");

        // 파일 업로드 페이지로 다시 이동하여 사용자에게 오류를 알립니다.
        return "receipt/upload";
    }
    // ======================================================================
    // ▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲ 코드 추가 끝 ▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲
    // ======================================================================

    
    
    
}