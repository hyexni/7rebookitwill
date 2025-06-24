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
  //  @Inject
   // private BookService bookService;

    @Inject
    private BookReportService bookReportService;

    private static final Logger logger = LoggerFactory.getLogger(BookReportController.class);
    
    
    /**
     * [수정] 독후감 글쓰기 폼 이동 (단순화)
     * - book_id 파라미터를 완전히 제거했습니다.
     * - 이제 이 메소드는 로그인 여부만 확인하고 글쓰기 폼으로 이동시킵니다.
     */
    @GetMapping("/write")
    public String insertBookReportForm(HttpSession session, RedirectAttributes rttr) {
        logger.info("GET - 독후감 작성 폼 요청");

        // 1. 로그인 상태 확인
        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
        if (loginUser == null) {
            // 인터셉터가 이 역할을 대신 처리하므로 없어도 되지만, 안전을 위해 유지합니다.
            rttr.addFlashAttribute("msg", "로그인이 필요한 서비스입니다."); 
            return "redirect:/member/login"; 
        }
logger.info("1111111111111111111111111111111");
        // 2. 독후감 작성 폼(View)으로 바로 이동
        return "bookreport/write";

    }
    
   
    @PostMapping("/write")
    public String insertBookReport(BookReportVO vo, // 파라미터를 VO로 한 번에 받도록 변경
    							@RequestParam("read_date") String imgdate,
                               //   @RequestParam(value = "report_image1", required = false) MultipartFile file1,
                                //  @RequestParam(value = "report_image2", required = false) MultipartFile file2,
                                //  @RequestParam(value = "report_image3", required = false) MultipartFile file3,
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
           // vo.setReport_image1(uploadFile(file1, uploadDir));
          //  vo.setReport_image2(uploadFile(file2, uploadDir));
           // vo.setReport_image3(uploadFile(file3, uploadDir));
            bookReportService.insertBookReport(vo); 
            rttr.addFlashAttribute("msg", "게시글이 성공적으로 등록되었습니다.");
        } catch (Exception e) {
            logger.error("독후감 등록 실패: {}", e.getMessage());
            rttr.addFlashAttribute("msg", "게시글 등록 중 오류가 발생했습니다.");
        }
        return "redirect:/bookreport/list";
    }

        /**
         * [수정] 독후감 수정 폼 이동
         * - 기존 게시글 정보를 조회하여 폼에 채워줍니다.
         * - 작성자와 로그인 유저가 일치하는지 권한을 확인합니다.
         */
        @GetMapping("/update")
        public String updateBookReportForm(@RequestParam("report_id") int report_id, HttpSession session, Model model, RedirectAttributes rttr) {
            logger.info("GET - 독후감 수정 폼 요청, report_id: {}", report_id);

            // 1. 로그인 여부 확인
            MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
            if (loginUser == null) {
                rttr.addFlashAttribute("msg", "로그인이 필요합니다.");
                return "redirect:/member/login";
            }

            // 2. (필수) DB에서 수정할 독후감 정보를 가져옴
            BookReportVO report = bookReportService.getBookReport(report_id);

            // 3. (필수) 본인 글이 맞는지 권한 확인
            if (report == null || report.getMember_idx() != loginUser.getMember_idx()) {
                rttr.addFlashAttribute("msg", "수정 권한이 없습니다.");
                return "redirect:/bookreport/list"; // 권한이 없으면 목록으로
            }
            
            // 4. (정상) 조회된 정보를 모델에 담아 수정 폼(update.jsp/html)으로 전달
            model.addAttribute("report", report);
            
            return "bookreport/update";
        }

        /**
         * [유지 및 개선] 독후감 수정 처리
         * - 로직은 대부분 올바르므로 유지하되, 성공 시 상세 페이지로 리다이렉트하여 사용자 경험을 개선합니다.
         */
        @PostMapping("/update")
        public String updateBookReport(BookReportVO vo, // 폼 데이터를 VO로 받음
                                       @RequestParam(value = "report_image1", required = false) MultipartFile file1,
                                       @RequestParam(value = "report_image2", required = false) MultipartFile file2,
                                       @RequestParam(value = "report_image3", required = false) MultipartFile file3,
                                       @RequestParam(value = "delete_image1", required = false) String deleteImage1,
                                       @RequestParam(value = "delete_image2", required = false) String deleteImage2,
                                       @RequestParam(value = "delete_image3", required = false) String deleteImage3,
                                       HttpSession session,
                                       RedirectAttributes rttr) {
            logger.info("POST - 독후감 수정 처리, report_id: {}", vo.getReport_id());
            
            MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
            if (loginUser == null) {
                rttr.addFlashAttribute("msg", "세션이 만료되었거나 로그인이 필요합니다.");
                return "redirect:/member/login";
            }
            
            // (보안) 수정 전, 다시 한번 DB의 원본 데이터와 소유권을 확인
            BookReportVO originalReport = bookReportService.getBookReport(vo.getReport_id());
            if (originalReport == null || originalReport.getMember_idx() != loginUser.getMember_idx()) {
                rttr.addFlashAttribute("msg", "수정 권한이 없습니다.");
                return "redirect:/bookreport/list";
            }

            vo.setMember_idx(loginUser.getMember_idx());
            
            try {
                // 이미지 처리 로직은 기존과 동일 (processImageUpdate 메소드가 있다고 가정)
                // String uploadDir = session.getServletContext().getRealPath("/resources/upload");
                // vo.setReport_image1(processImageUpdate(file1, deleteImage1, originalReport.getReport_image1(), uploadDir));
                // ... (이미지 2, 3 처리) ...
                
                bookReportService.updateBookReport(vo);
                rttr.addFlashAttribute("msg", "게시글이 성공적으로 수정되었습니다.");
                // 수정 완료 후, 목록이 아닌 수정된 게시글의 상세 페이지로 이동하는 것이 더 자연스러움
                return "redirect:/bookreport/detail?report_id=" + vo.getReport_id();
            } catch (Exception e) {
                logger.error("독후감 수정 실패: {}", e.getMessage(), e);
                rttr.addFlashAttribute("msg", "게시글 수정 중 오류가 발생했습니다.");
                // 실패 시에도 수정 폼으로 다시 돌아가는 것이 좋음
                return "redirect:/bookreport/update?report_id=" + vo.getReport_id();
            }
        }
        
        /**
         * [유지] 독후감 삭제 처리
         * - 기존 권한 확인 로직은 보안상 필수이므로 그대로 유지합니다.
         */
        @PostMapping("/delete")
        public String deleteBookReport(@RequestParam("report_id") int report_id, HttpSession session, RedirectAttributes rttr) {
            logger.info("POST - 독후감 삭제 요청, report_id: {}", report_id);

            MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
            if (loginUser == null) {
                rttr.addFlashAttribute("msg", "로그인이 필요합니다.");
                return "redirect:/member/login";
            }
            
            // (보안) 삭제 전, DB에서 해당 게시글 정보를 가져와 본인 글이 맞는지 반드시 확인
            BookReportVO report = bookReportService.getBookReport(report_id);
            if (report == null || report.getMember_idx() != loginUser.getMember_idx()) {
                rttr.addFlashAttribute("msg", "삭제 권한이 없습니다.");
                return "redirect:/bookreport/list";
            }

            try {
                bookReportService.deleteBookReport(report_id);
                rttr.addFlashAttribute("msg", "게시글이 삭제되었습니다.");
            } catch (Exception e) {
                logger.error("독후감 삭제 실패: {}", e.getMessage(), e);
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