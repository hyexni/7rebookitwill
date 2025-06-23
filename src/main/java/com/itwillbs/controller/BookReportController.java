package com.itwillbs.controller;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.itwillbs.domain.BookReportVO;
import com.itwillbs.domain.BookVO;
import com.itwillbs.domain.MemberVO;
import com.itwillbs.service.BookReportService;
import com.itwillbs.service.BookService;

@Controller
@RequestMapping("/bookreport")
public class BookReportController {

    @Inject
    private BookService bookService;

    // [수정] 변수명 네이밍 컨벤션 적용 (소문자 시작)
    @Inject
    private BookReportService bookReportService;

    private static final Logger logger = LoggerFactory.getLogger(BookReportController.class);

    /**
     * 독후감 작성 폼 이동
     */
    @GetMapping("/write")
    public String writeBookReportForm(@RequestParam("book_id") int book_id, Model model) {
        logger.info("GET - 독후감 작성 폼 요청, book_id: {}", book_id);

        BookVO book = bookService.getBookDetail(book_id);
        model.addAttribute("book", book);
        
        // [수정] view 경로 일관성 유지
        return "bookreport/write"; 
    }

    /**
     * 독후감 등록 처리
     */
    @PostMapping("/write")
    public String writeBookReport(
        @RequestParam("book_id") int book_id,
        // [수정] read_date 파라미터 추가 (필수)
        @RequestParam("author_name") String author_name, // 날짜 형식에 따라 Date나 LocalDate로 받는 것을 권장
        @RequestParam("report_text") String report_text,
        @RequestParam(value = "report_image1", required = false) MultipartFile file1,
        @RequestParam(value = "report_image2", required = false) MultipartFile file2,
        @RequestParam(value = "report_image3", required = false) MultipartFile file3,
        HttpSession session,
        RedirectAttributes rttr
    ) {
        logger.info("POST - 독후감 등록 처리, book_id: {}", book_id);

        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
        if (loginUser == null) {
            logger.warn("비로그인 상태에서 독후감 등록 시도. 로그인 페이지로 리다이렉트.");
            rttr.addFlashAttribute("msg", "로그인이 필요합니다.");
            return "redirect:/member/login";
        }

        BookReportVO vo = new BookReportVO();
        vo.setBook_id(book_id);
        vo.setMember_idx(loginUser.getMember_idx());
        vo.setAuthor_name(author_name); // [수정] 받아온 값으로 설정
        vo.setReport_text(report_text);

        try {
            String uploadDir = session.getServletContext().getRealPath("/resources/upload");
            
            // [리팩토링] 파일 업로드 로직을 헬퍼 메서드로 추출하여 중복 제거
            vo.setReport_image1(uploadFile(file1, uploadDir));
            vo.setReport_image2(uploadFile(file2, uploadDir));
            vo.setReport_image3(uploadFile(file3, uploadDir));

            // [수정] 서비스 메서드명 컨벤션에 맞게 수정 (실제 서비스단 확인 필요)
            bookReportService.writeBookReport(vo); 
            
            logger.info("독후감 등록 성공! report: {}", vo);
            rttr.addFlashAttribute("msg", "독후감이 성공적으로 등록되었습니다.");
            
        } catch (Exception e) {
            logger.error("독후감 등록 실패: {}", e.getMessage());
            rttr.addFlashAttribute("msg", "독후감 등록 중 오류가 발생했습니다.");
        }

        return "redirect:/book/view?book_id=" + book_id;
    }

    /**
     * 독후감 수정 폼 이동
     */
    @GetMapping("/update")
    // [수정] 파라미터 이름을 report_id로 통일
    public String updateBookReportForm(@RequestParam("report_id") int report_id, HttpSession session, Model model, RedirectAttributes rttr) {
        logger.info("GET - 독후감 수정 폼 요청, report_id: {}", report_id);
        
        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
        if (loginUser == null) {
            rttr.addFlashAttribute("msg", "로그인이 필요합니다.");
            return "redirect:/member/login";
        }

        BookReportVO report = bookReportService.getBookReport(report_id);
        
        // 권한 체크: 독후감이 없거나 작성자가 아닌 경우
        if (report == null || report.getMember_idx() != loginUser.getMember_idx()) {
            rttr.addFlashAttribute("msg", "수정 권한이 없습니다.");
            // 이전 페이지나 책 상세 페이지로 리다이렉트
            return report != null ? "redirect:/book/view?book_id=" + report.getBook_id() : "redirect:/";
        }

        BookVO book = bookService.getBookDetail(report.getBook_id());

        model.addAttribute("report", report);
        model.addAttribute("book", book);
        
        return "bookreport/update";
    }


    /**
     * 독후감 수정 처리
     */
    @PostMapping("/update")
    public String updateBookReport(
        @RequestParam("report_id") int report_id,
        @RequestParam("book_id") int book_id,
        @RequestParam("author_name") String author_name, 
        @RequestParam("report_text") String report_text,
        @RequestParam(value = "report_image1", required = false) MultipartFile file1,
        @RequestParam(value = "report_image2", required = false) MultipartFile file2,
        @RequestParam(value = "report_image3", required = false) MultipartFile file3,
        @RequestParam(value = "delete_image1", required = false) String deleteImage1,
        @RequestParam(value = "delete_image2", required = false) String deleteImage2,
        @RequestParam(value = "delete_image3", required = false) String deleteImage3,
        HttpSession session,
        RedirectAttributes rttr
    ) {
        logger.info("POST - 독후감 수정 처리, report_id: {}", report_id);
        
        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
        if (loginUser == null) {
            rttr.addFlashAttribute("msg", "로그인이 필요합니다.");
            return "redirect:/member/login";
        }
        
        // 기존 독후감 정보 조회 (권한 확인 및 기존 이미지 정보 확인용)
        BookReportVO originalReport = bookReportService.getBookReport(report_id);
        if (originalReport == null || originalReport.getMember_idx() != loginUser.getMember_idx()) {
            rttr.addFlashAttribute("msg", "수정 권한이 없습니다.");
            return "redirect:/book/view?book_id=" + book_id;
        }

        BookReportVO vo = new BookReportVO();
        vo.setReport_id(report_id);
        vo.setBook_id(book_id);
        vo.setMember_idx(loginUser.getMember_idx());
        vo.setAuthor_name(author_name); 
        vo.setReport_text(report_text);
        
        try {
            String uploadDir = session.getServletContext().getRealPath("/resources/upload");
            
            // [리팩토링] 이미지 업데이트 로직을 헬퍼 메서드로 추출
            vo.setReport_image1(processImageUpdate(file1, deleteImage1, originalReport.getReport_image1(), uploadDir));
            vo.setReport_image2(processImageUpdate(file2, deleteImage2, originalReport.getReport_image2(), uploadDir));
            vo.setReport_image3(processImageUpdate(file3, deleteImage3, originalReport.getReport_image3(), uploadDir));
            
            bookReportService.updateBookReport(vo);
            logger.info("독후감 수정 성공! report: {}", vo);
            rttr.addFlashAttribute("msg", "독후감이 성공적으로 수정되었습니다.");

        } catch (Exception e) {
            logger.error("독후감 수정 실패: {}", e.getMessage(), e); // [수정] e.printStackTrace() 대신 logger 사용
            rttr.addFlashAttribute("msg", "독후감 수정 중 오류가 발생했습니다.");
        }

        return "redirect:/book/view?book_id=" + book_id;
    }
    
    /**
     * 독후감 삭제 처리
     */
    @PostMapping("/delete")
    // [수정] 파라미터 이름을 report_id로 통일
    public String deleteBookReport(@RequestParam("report_id") int report_id, HttpSession session, RedirectAttributes rttr) {
        logger.info("POST - 독후감 삭제 요청, report_id: {}", report_id);

        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
        if (loginUser == null) {
            rttr.addFlashAttribute("msg", "로그인이 필요합니다.");
            return "redirect:/member/login";
        }

        BookReportVO report = bookReportService.getBookReport(report_id);

        if (report == null) {
            rttr.addFlashAttribute("msg", "해당 독후감이 존재하지 않습니다.");
            return "redirect:/";
        }
        
        if (report.getMember_idx() != loginUser.getMember_idx()) {
            rttr.addFlashAttribute("msg", "삭제 권한이 없습니다.");
            return "redirect:/book/view?book_id=" + report.getBook_id();
        }

        try {
            bookReportService.deleteBookReport(report_id); // [수정] report_id만 넘기는 것이 더 효율적
            rttr.addFlashAttribute("msg", "독후감이 삭제되었습니다.");
        } catch (Exception e) {
            logger.error("독후감 삭제 실패: {}", e.getMessage());
            rttr.addFlashAttribute("msg", "독후감 삭제에 실패했습니다.");
        }
        
        return "redirect:/book/view?book_id=" + report.getBook_id();
    }
    
    // ====================== Private Helper Methods ======================
    
    /**
     * [리팩토링] 단일 파일 업로드 처리를 위한 헬퍼 메서드
     * @param file 업로드된 MultipartFile
     * @param uploadDir 저장 경로
     * @return 저장된 파일명 (성공 시) 또는 null (실패 또는 파일 없음)
     * @throws IOException
     */
    private String uploadFile(MultipartFile file, String uploadDir) throws IOException {
        if (file == null || file.isEmpty()) {
            return null;
        }
        
        // 폴더 없으면 자동 생성
        File uploadFolder = new File(uploadDir);
        if (!uploadFolder.exists()) {
            uploadFolder.mkdirs();
        }
        
        String originalFileName = file.getOriginalFilename();
        String storedFileName = UUID.randomUUID().toString() + "_" + originalFileName;
        
        file.transferTo(new File(uploadDir, storedFileName));
        logger.info("파일 업로드 성공: {}", storedFileName);
        
        return storedFileName;
    }
    
    /**
     * [리팩토링] 이미지 업데이트 로직 처리를 위한 헬퍼 메서드
     * @param newFile 새로 업로드된 파일
     * @param deleteFlag 삭제 체크박스 값 ("on"이면 삭제)
     * @param originalFileName 기존 파일명
     * @param uploadDir 업로드 디렉토리
     * @return 최종 저장될 파일명
     * @throws IOException
     */
    private String processImageUpdate(MultipartFile newFile, String deleteFlag, String originalFileName, String uploadDir) throws IOException {
        // 1. "이미지 삭제"를 체크한 경우
        if ("on".equals(deleteFlag)) {
            // (추가 개선) 서버에서 실제 파일도 삭제하는 로직을 여기에 추가할 수 있습니다.
            return null; 
        }
        
        // 2. 새로운 파일이 업로드된 경우
        if (newFile != null && !newFile.isEmpty()) {
            return uploadFile(newFile, uploadDir);
        }
        
        // 3. 아무런 변경이 없는 경우 기존 파일명 유지
        return originalFileName;
    }
}