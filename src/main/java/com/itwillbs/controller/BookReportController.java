package com.itwillbs.controller;

import java.io.File;
import java.io.IOException;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.itwillbs.domain.BookReportVO;
import com.itwillbs.domain.MemberVO;
import com.itwillbs.service.BookReportService;

@Controller
@RequestMapping("/bookreport")
public class BookReportController {

    // BookService 주입은 /write 에서 더 이상 사용하지 않으므로 제거 가능합니다.
    // 만약 다른 곳에서 사용한다면 유지합니다.
    // @Inject
    // private BookService bookService; 
    
    @Inject
    private BookReportService bookreportService; 
    
    private static final Logger logger = LoggerFactory.getLogger(BookReportController.class);

    
    /**
     * ✅ 독후감 작성 폼으로 이동
     * - 이 메소드는 로그인한 사용자를 독후감 작성 페이지로 안내하는 역할만 합니다.
     * - 기존 도서 검색 및 선택은 작성 페이지 내부에서 JavaScript/Ajax로 처리하는 것을 전제로 합니다.
     */
    @GetMapping("/write")
    public String writeBookReportForm(HttpSession session, RedirectAttributes rttr) {
        // [필수] 로그인 상태를 확인하여 비로그인 시 로그인 페이지로 리다이렉트
        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
        if (loginUser == null) {
            logger.warn("⚠ 비로그인 상태에서 독후감 작성 페이지 접근 시도");
            rttr.addFlashAttribute("errorMsg", "로그인이 필요한 서비스입니다.");
            return "redirect:/member/login"; 
        }
        
        logger.info("✅ 독후감 작성 폼으로 이동");
        
        // book_id에 따른 분기 로직 제거. 항상 동일한 작성 폼 뷰를 반환.
        return "bookreport/write"; 
    }
    
    /**
     * ✅ 독후감 등록 처리
     * - 사용자가 작성한 독후감 정보를 DB에 저장합니다.
     */
    @PostMapping("/list")
    public String writeBookReport(
            @RequestParam(value = "report_id") int report_id,
            @RequestParam("report_title") String report_title,  
            @RequestParam(value = "author_name", required = false) String author_name,
            @RequestParam(value = "publisher", required = false) String publisher,            
            @RequestParam("read_date") @DateTimeFormat(pattern = "yyyy-MM-dd") Date read_date,           
            @RequestParam("report_text") String report_text, 
            @RequestParam(value = "report_image1", required = false) MultipartFile file1,
            @RequestParam(value = "report_image2", required = false) MultipartFile file2,
            @RequestParam(value = "report_image3", required = false) MultipartFile file3,
            HttpSession session,
            RedirectAttributes rttr) {
        
        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
        if (loginUser == null) {
            logger.warn("⚠ 비로그인 상태에서 독후감 등록 시도");
            rttr.addFlashAttribute("errorMsg", "로그인이 필요합니다.");
            return "redirect:/member/login";
        }
        int member_idx = loginUser.getMember_idx();

        // VO 객체 세팅
        BookReportVO vo = new BookReportVO();        
        
        vo.setBook_id(report_id);        
        vo.setMember_idx(member_idx);
        vo.setReport_title(report_title);
        vo.setReport_text(report_text);       
        vo.setAuthor_name(author_name);
        vo.setPublisher(publisher);        
        vo.setRead_date(read_date);
        

        // 파일 저장 처리
        String uploadDir = session.getServletContext().getRealPath("/resources/upload");
        File uploadFolder = new File(uploadDir);
        if (!uploadFolder.exists()) {
            uploadFolder.mkdirs();
        }
        
        vo.setReport_image1(saveFile(file1, uploadDir));
        vo.setReport_image2(saveFile(file2, uploadDir));
        vo.setReport_image3(saveFile(file3, uploadDir));
        
        try {
             bookreportService.writeBookReport(vo);
            
            logger.info("🎉 독후감 등록 성공! (report_id: {})", vo.getReport_id());
            rttr.addFlashAttribute("msg", "독후감이 등록되었습니다.");
            
            // [수정] 등록 성공 시, 생성된 독후감 상세 페이지로 이동
            return "redirect:/bookreport/view?report_id=" + vo.getReport_id();

        } catch (Exception e) {
            logger.error("❌ 독후감 등록 실패 - " + e.getMessage(), e);
            rttr.addFlashAttribute("errorMsg", "독후감 등록에 실패했습니다. 다시 시도해주세요.");

            // [수정] 실패 시, 작성하던 페이지로 다시 이동
            return "redirect:/bookreport/write";
        }
    }
 // =================================== [R]ead =====================================

    /**
     * ✅ [수정] '내 독후감' 목록 페이지
     * - 세션에서 로그인 정보를 확인하고, member_idx를 사용해 본인 글만 조회합니다.
     */
    @GetMapping("/list")
    public String bookReportList(Model model, HttpSession session, RedirectAttributes rttr) {
        logger.info("📚 내 독후감 목록 페이지 요청");
        
        // 1. 세션에서 로그인 정보 가져오기
        MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
        if (loginUser == null) {
            rttr.addFlashAttribute("errorMsg", "로그인이 필요한 서비스입니다.");
            return "redirect:/member/login";
        }

        try {
            // 2. 로그인한 사용자의 member_idx로 서비스 호출
            int member_idx = loginUser.getMember_idx();
            List<BookReportVO> reportList = bookreportService.getReportListByMember(member_idx);
            
            // 3. 조회된 결과를 모델에 담아 JSP로 전달
            model.addAttribute("reportList", reportList);
            
        } catch (Exception e) {
            logger.error("❌ 내 독후감 목록 조회 실패", e);
            model.addAttribute("reportList", Collections.emptyList()); // 오류 발생 시 빈 리스트 전달
            rttr.addFlashAttribute("errorMsg", "목록을 불러오는 중 오류가 발생했습니다.");
        }
        return "bookreport/list";
    }
    /**
     * ✅ [추가] 독후감 상세 페이지
     */
    @GetMapping("/view")
    public String bookReportView(@RequestParam("report_id") int report_id, Model model, RedirectAttributes rttr) {
        try {
            BookReportVO report = bookreportService.getBookReportDetail(report_id);
            model.addAttribute("report", report);
            return "redirect:/bookreport/view?report_id=" + report_id;
        } catch (Exception e) {
            logger.error("❌ 상세 페이지 로딩 실패 - report_id: {}", report_id, e);
            rttr.addFlashAttribute("errorMsg", "게시글을 불러오는 중 오류가 발생했습니다.");
            return "redirect:/bookreport/list";
        }
    }
    
 // =================================== [U]pdate ===================================

    @GetMapping("/update")
    public String updateBookReportForm(@RequestParam("report_id") int report_id, Model model, HttpSession session, RedirectAttributes rttr) {
        try {
            MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
            BookReportVO report = bookreportService.getBookReportDetail(report_id);

            if (report == null) {
                rttr.addFlashAttribute("errorMsg", "존재하지 않는 게시글입니다.");
                return "redirect:/bookreport/list";
            }

            if (loginUser == null || loginUser.getMember_idx() != report.getMember_idx()) {
                rttr.addFlashAttribute("errorMsg", "수정 권한이 없습니다.");
                return "redirect:/bookreport/list";
            }
            
            model.addAttribute("report", report);
            return "bookreport/update"; // update.jsp 뷰로 이동
        } catch (Exception e) {
            logger.error("❌ 수정 폼 로딩 실패 - report_id: {}", report_id, e);
            rttr.addFlashAttribute("errorMsg", "게시글을 불러오는 데 실패했습니다.");
            return "redirect:/bookreport/list";
        }
    }

    /**
     * ✅ [수정] 독후감 수정 처리
     * - 각 파라미터를 @RequestParam으로 명시적으로 받아 report_id 누락 문제를 방지합니다.
     */
    @PostMapping("/update")
    public String updateBookReport(
            @RequestParam("report_id") int report_id,
            @RequestParam("report_title") String report_title,
            @RequestParam(value = "author_name", required = false) String author_name,
            @RequestParam(value = "publisher", required = false) String publisher,
            @RequestParam("read_date") @DateTimeFormat(pattern = "yyyy-MM-dd") Date read_date,
            @RequestParam(value="status", defaultValue="private") String status,
            @RequestParam("report_text") String report_text, 
            @RequestParam(value = "report_image1", required = false) MultipartFile file1,
            @RequestParam(value = "report_image2", required = false) MultipartFile file2,
            @RequestParam(value = "report_image3", required = false) MultipartFile file3,
            HttpSession session, RedirectAttributes rttr) {
        
        try {
            MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
            
            // 수정 전 권한 확인
            BookReportVO existingReport = bookreportService.getBookReportDetail(report_id);
            if (loginUser == null || loginUser.getMember_idx() != existingReport.getMember_idx()) {
                 rttr.addFlashAttribute("errorMsg", "수정 권한이 없습니다.");
                 return "redirect:/bookreport/list";
            }

            // 전달받은 파라미터로 VO 객체 생성
            BookReportVO vo = new BookReportVO();
            vo.setReport_id(report_id);
            vo.setMember_idx(loginUser.getMember_idx());
            vo.setReport_title(report_title);
            vo.setAuthor_name(author_name);
            vo.setPublisher(publisher);
            vo.setRead_date(read_date);
            vo.setStatus(status);
            vo.setReport_text(report_text);
            
            // TODO: 파일 수정 로직 보강 필요 (기존 파일 삭제 등)
            String uploadDir = session.getServletContext().getRealPath("/resources/upload");
            vo.setReport_image1(saveFile(file1, uploadDir));
            vo.setReport_image2(saveFile(file2, uploadDir));
            vo.setReport_image3(saveFile(file3, uploadDir));

            bookreportService.updateBookReport(vo);
            rttr.addFlashAttribute("msg", "독후감이 수정되었습니다.");

        } catch (Exception e) {
            logger.error("❌ 독후감 수정 실패", e);
            rttr.addFlashAttribute("errorMsg", "독후감 수정에 실패했습니다.");
        }

        return "redirect:/bookreport/view?report_id=" + report_id;
    }
    // =================================== [D]elete ===================================
    
    /**
     * ✅ [추가] 독후감 삭제 처리
     */
    @PostMapping("/delete")
    public String deleteBookReport(@RequestParam("report_id") int report_id, HttpSession session, RedirectAttributes rttr) {
        try {
            MemberVO loginUser = (MemberVO) session.getAttribute("loginUser");
            BookReportVO reportToDelete = bookreportService.getBookReportDetail(report_id);
            
            if (reportToDelete == null) {
                 rttr.addFlashAttribute("errorMsg", "이미 삭제된 게시글입니다.");
                 return "redirect:/bookreport/list";
            }
            
            if (loginUser == null || loginUser.getMember_idx() != reportToDelete.getMember_idx()) {
                rttr.addFlashAttribute("errorMsg", "삭제 권한이 없습니다.");
                return "redirect:/bookreport/list";
            }
            
            bookreportService.deleteBookReport(reportToDelete);
            rttr.addFlashAttribute("msg", "독후감이 삭제되었습니다.");
        } catch (Exception e) {
            logger.error("❌ 독후감 삭제 실패", e);
            rttr.addFlashAttribute("errorMsg", "독후감 삭제에 실패했습니다.");
        }
        
        return "redirect:/bookreport/list";
    }

    // =================================== Helper Method ==============================

    /**
     * 파일 저장을 처리하는 헬퍼 메서드
     */
    private String saveFile(MultipartFile file, String uploadDir) {
        if (file == null || file.isEmpty()) {
            return null;
        }

        String originalFilename = file.getOriginalFilename();
        String savedFilename = UUID.randomUUID().toString() + "_" + originalFilename;

        try {
            file.transferTo(new File(uploadDir, savedFilename));
            logger.info("✅ 파일 저장 성공: {}", savedFilename);
            return savedFilename;
        } catch (IOException e) {
            logger.error("❌ 파일 저장 실패: {} - {}", originalFilename, e.getMessage());
            return null;
        }
    }
}
