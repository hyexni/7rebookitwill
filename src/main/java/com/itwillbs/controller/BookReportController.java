package com.itwillbs.controller;

import java.io.File;
import java.io.IOException;
import java.util.List;
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

    // book_id로 책 정보를 조회할 때만 사용되므로 의존성은 유지합니다.
    @Inject
    private BookService bookService;

    @Inject
    private BookReportService bookReportService;

    private static final Logger logger = LoggerFactory.getLogger(BookReportController.class);
    
    @GetMapping("/list")
    public String bookReportList(Model model) {
        logger.info("GET - 독후감 목록 페이지 요청");
        
        // ✅ 파라미터 없이 서비스의 목록 조회 메소드를 호출
        List<BookReportVO> reportList = bookReportService.getBookReportList(); 
        
        model.addAttribute("reportList", reportList);
        return "bookreport/list";
    }

    @GetMapping("/write")
    public String writeBookReportForm(@RequestParam(value = "book_id", required = false) Integer book_id, 
                                      Model model,
                                      HttpSession session,          //  세션 객체를 사용하기 위해
                                      RedirectAttributes rttr) {    // 리다이렉트 시 메시지를 전달하기 위해

        logger.info("GET - 독후감 작성 폼 요청, book_id: {}", book_id);

        // [추가] 로그인 상태 확인 로직
        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
        if (loginUser == null) {
            logger.warn("비로그인 사용자의 글쓰기 페이지 접근 시도 차단");
            rttr.addFlashAttribute("msg", "로그인이 필요한 서비스입니다.");
            return "redirect:/member/login"; // 로그인 페이지로 리다이렉트
        }

        // --- 이하 기존 로직 (로그인한 사용자에게만 실행됨) ---
        if (book_id != null) {
            BookVO book = bookService.getBookDetail(book_id);
            model.addAttribute("book", book);
        }
        return "bookreport/write"; 
    }

    
   
    @PostMapping("/write")
    public String writeBookReport(BookReportVO vo, // 파라미터를 VO로 한 번에 받도록 변경
                                  @RequestParam(value = "report_image1", required = false) MultipartFile file1,
                                  @RequestParam(value = "report_image2", required = false) MultipartFile file2,
                                  @RequestParam(value = "report_image3", required = false) MultipartFile file3,
                                  HttpSession session,
                                  RedirectAttributes rttr) {
        logger.info("POST - 독후감 등록 처리, vo: {}", vo);

        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
        if (loginUser == null) {
            rttr.addFlashAttribute("msg", "로그인이 필요합니다.");
            return "redirect:/member/login";
        }
        
        vo.setMember_idx(loginUser.getMember_idx());

        try {
            String uploadDir = session.getServletContext().getRealPath("/resources/upload");
            vo.setReport_image1(uploadFile(file1, uploadDir));
            vo.setReport_image2(uploadFile(file2, uploadDir));
            vo.setReport_image3(uploadFile(file3, uploadDir));
            bookReportService.writeBookReport(vo); 
            rttr.addFlashAttribute("msg", "게시글이 성공적으로 등록되었습니다.");
        } catch (Exception e) {
            logger.error("독후감 등록 실패: {}", e.getMessage());
            rttr.addFlashAttribute("msg", "게시글 등록 중 오류가 발생했습니다.");
        }
        return "redirect:/bookreport/list";
    }

    /**
     * [핵심 변경] 독후감 수정 폼 이동
     */
    @GetMapping("/update")
    public String updateBookReportForm(@RequestParam("report_id") int report_id, HttpSession session, Model model, RedirectAttributes rttr) {
        logger.info("GET - 독후감 수정 폼 요청, report_id: {}", report_id);
        
        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
        if (loginUser == null) {
            rttr.addFlashAttribute("msg", "로그인이 필요합니다.");
            return "redirect:/member/login";
        }

        // [변경] 서비스 계층에서 JOIN된 쿼리를 호출하여 책 제목까지 한번에 가져옴
        BookReportVO report = bookReportService.getBookReport(report_id); // 예시: getBookReportById 호출
        
        if (report == null || report.getMember_idx() != loginUser.getMember_idx()) {
            rttr.addFlashAttribute("msg", "수정 권한이 없습니다.");
            return "redirect:/bookreport/list";
        }
        
        // [변경] 별도의 book 객체를 조회할 필요 없이, 조회된 report 객체 하나만 모델에 담음
        model.addAttribute("report", report);
        
        return "bookreport/update";
    }

    @PostMapping("/update")
    public String updateBookReport(BookReportVO vo, // 파라미터를 VO로 받음
                                   @RequestParam(value = "report_image1", required = false) MultipartFile file1,
                                   @RequestParam(value = "report_image2", required = false) MultipartFile file2,
                                   @RequestParam(value = "report_image3", required = false) MultipartFile file3,
                                   @RequestParam(value = "delete_image1", required = false) String deleteImage1,
                                   @RequestParam(value = "delete_image2", required = false) String deleteImage2,
                                   @RequestParam(value = "delete_image3", required = false) String deleteImage3,
                                   HttpSession session,
                                   RedirectAttributes rttr) {
        logger.info("POST - 독후감 수정 처리, vo: {}", vo);
        
        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
        if (loginUser == null) {
            rttr.addFlashAttribute("msg", "로그인이 필요합니다.");
            return "redirect:/member/login";
        }
        
        BookReportVO originalReport = bookReportService.getBookReport(vo.getReport_id());
        if (originalReport == null || originalReport.getMember_idx() != loginUser.getMember_idx()) {
            rttr.addFlashAttribute("msg", "수정 권한이 없습니다.");
            return "redirect:/bookreport/list";
        }

        vo.setMember_idx(loginUser.getMember_idx());
        
        try {
            String uploadDir = session.getServletContext().getRealPath("/resources/upload");
            vo.setReport_image1(processImageUpdate(file1, deleteImage1, originalReport.getReport_image1(), uploadDir));
            vo.setReport_image2(processImageUpdate(file2, deleteImage2, originalReport.getReport_image2(), uploadDir));
            vo.setReport_image3(processImageUpdate(file3, deleteImage3, originalReport.getReport_image3(), uploadDir));
            bookReportService.updateBookReport(vo);
            rttr.addFlashAttribute("msg", "게시글이 성공적으로 수정되었습니다.");
        } catch (Exception e) {
            logger.error("독후감 수정 실패: {}", e.getMessage(), e);
            rttr.addFlashAttribute("msg", "게시글 수정 중 오류가 발생했습니다.");
        }
        return "redirect:/bookreport/list";
    }
    
    @PostMapping("/delete")
    public String deleteBookReport(@RequestParam("report_id") int report_id, HttpSession session, RedirectAttributes rttr) {
        // ... (기존 삭제 로직과 동일, 리다이렉트 경로는 /bookreport/list)
        logger.info("POST - 독후감 삭제 요청, report_id: {}", report_id);

        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
        if (loginUser == null) {
            rttr.addFlashAttribute("msg", "로그인이 필요합니다.");
            return "redirect:/member/login";
        }

        BookReportVO report = bookReportService.getBookReport(report_id);

        if (report == null) {
            rttr.addFlashAttribute("msg", "해당 게시글이 존재하지 않습니다.");
            return "redirect:/bookreport/list";
        }
        
        if (report.getMember_idx() != loginUser.getMember_idx()) {
            rttr.addFlashAttribute("msg", "삭제 권한이 없습니다.");
            return "redirect:/bookreport/list";
        }

        try {
            bookReportService.deleteBookReport(report_id);
            rttr.addFlashAttribute("msg", "게시글이 삭제되었습니다.");
        } catch (Exception e) {
            logger.error("독후감 삭제 실패: {}", e.getMessage());
            rttr.addFlashAttribute("msg", "게시글 삭제에 실패했습니다.");
        }
        
        return "redirect:/bookreport/list";
    }
    
// ====================== Private Helper Methods (기존과 동일) ======================
    
    private String uploadFile(MultipartFile file, String uploadDir) throws IOException {
        if (file == null || file.isEmpty()) {
            return null;
        }
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
    
    private String processImageUpdate(MultipartFile newFile, String deleteFlag, String originalFileName, String uploadDir) throws IOException {
        if ("on".equals(deleteFlag)) {
            return null; 
        }
        if (newFile != null && !newFile.isEmpty()) {
            return uploadFile(newFile, uploadDir);
        }
        return originalFileName;
    }
}