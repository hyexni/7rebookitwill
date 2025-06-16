package com.itwillbs.controller;

import com.itwillbs.domain.ReceiptVO;
import com.itwillbs.service.OcrUtil;
import com.itwillbs.service.ReceiptService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.inject.Inject;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.security.MessageDigest; // 해시 계산을 위해 추가
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.UUID;


//http://localhost:8088/receipt/upload
@Controller
@RequestMapping("/receipt")
public class ReceiptController {

    private static final Logger logger = LoggerFactory.getLogger(ReceiptController.class);

    @Inject
    private ReceiptService rService;

    @Value("${upload.path}")
    private String uploadPath;

    @GetMapping("/upload")
    public String receiptUploadForm() {
        logger.info("GET - receiptUploadForm() 호출");
        return "receipt/upload";
    }

    @PostMapping("/upload")
    public String receiptUploadPost(MultipartFile file, Model model, RedirectAttributes redirectAttributes, HttpSession session) {
        logger.info("POST - receiptUploadPost() 호출");

        
        // 1. 파일 유효성 검사
        if (file == null || file.isEmpty()) {
            model.addAttribute("message", "파일이 선택되지 않았습니다.");
            return "receipt/upload";
        }
        
        logger.info("11111111111111111111111");
        String originalFilename = Paths.get(file.getOriginalFilename()).getFileName().toString();
        // ... (용량, 확장자 검사 생략) ...

        File targetFile = null;
        try {
            // [강화] 2. 파일 내용으로 고유 해시(SHA-256) 생성
        	logger.info("22222222222222222222222");
            String fileHash = generateFileHash(file);

            // [강화] 3. 파일 해시로 중복 확인 (파일명보다 훨씬 정확함)
            if (rService.isDuplicate(fileHash)) {
                model.addAttribute("message", "완전히 동일한 파일(내용)이 이미 등록되었습니다.");
                return "receipt/upload";
            }

            // 4. 파일 저장 처리
            logger.info("3333333333333333333");
            String uuid = UUID.randomUUID().toString();
            String savedName = uuid + "_" + originalFilename;
            targetFile = new File(uploadPath, savedName);
            new File(uploadPath).mkdirs();
            file.transferTo(targetFile);
            logger.info("파일 저장 성공: {}", targetFile.getAbsolutePath());

            // 5. OCR 수행
            logger.info("444444444444444444444444");
            String ocrResult = OcrUtil.extractTextFromImage(targetFile);
            ReceiptVO vo = new ReceiptVO(); // try 블록 안으로 이동

            if (ocrResult == null || ocrResult.trim().isEmpty()) {
                vo.setUpload_status("FAIL_OCR");
                // DB에 실패 기록을 남기려면 여기서 서비스 호출
                // rService.recordUpload(vo); 
                throw new IOException("영수증 내용을 인식하지 못했습니다.");
            }

            logger.info("55555555555555555555");
            // 6. VO 객체에 모든 정보 설정
            // 파일 정보
            vo.setOriginalfilename(originalFilename);
            vo.setSavedfilename(savedName);
            vo.setFilepath(uploadPath);
            vo.setFile_size((int) file.getSize());
            vo.setFile_type(file.getContentType());
            vo.setFileHash(fileHash); // 파일 해시값 저장
            vo.setOcr_text(ocrResult);

            // =================================================================
            // [핵심 수정 부분] 세션 정보 처리
            // =================================================================
            
            // [수정] 로그인 기능을 임시로 비활성화하고, 테스트를 위해 고정된 회원 ID를 사용합니다.
            // 나중에 실제 로그인 기능이 구현되면 이 부분의 주석을 풀고 아래 줄은 삭제해야 합니다.
            /*
            Integer memberIdx = (Integer) session.getAttribute("member_idx");
            if (memberIdx == null) {
                throw new IllegalStateException("오류: 로그인이 필요합니다.");
            }
            vo.setMember_idx(memberIdx);
            */
            vo.setMember_idx(1); // 임시로 1번 회원으로 설정하여 로그인 없이도 작동하게 함
            // =================================================================


            // OCR 추출 정보
            logger.info("**********************1");
            vo.setOcr_store(OcrUtil.extractStoreName(ocrResult));
            logger.info("-----------------------");
            vo.setOcr_amount(OcrUtil.extractTotalAmount(ocrResult));
            logger.info("///////////////////////////");
            vo.setItems(OcrUtil.extractItems(ocrResult));
            // ... (날짜, 승인번호 등 설정) ...

            // [추가] 7. 조작 의심 탐지 (금액 검증)
            logger.info("66666666666666666666666");
            int sumOfItems = vo.getItems().stream()
                               .mapToInt(item -> item.getPrice() * item.getQuantity())
                               .sum();

            if (vo.getOcr_amount() == sumOfItems) {
                vo.setVerification_status("VERIFIED"); // 검증 완료
            } else {
                vo.setVerification_status("MISMATCH_AMOUNT"); // 금액 불일치
                logger.warn("금액 불일치 탐지! OCR 총액: {}, 품목 합계: {}", vo.getOcr_amount(), sumOfItems);
            }
            
            vo.setUpload_status("SUCCESS"); // 모든 처리 성공

            logger.info("7777777777777777777777");
            // 8. 서비스 호출하여 DB에 최종 저장
            logger.info("DB에 저장할 최종 VO: {}", vo);
            rService.ReceiptUpload(vo);
            logger.info("영수증 정보 DB 저장 완료!");

            redirectAttributes.addFlashAttribute("uploadResult", vo);
            return "redirect:/receipt/upload-result";

        } catch (Exception e) {
            // 예외 발생 시, 생성된 파일이 있다면 삭제 (롤백)
            if (targetFile != null && targetFile.exists()) {
                targetFile.delete();
            }
            logger.error("영수증 처리 중 오류 발생", e);
            redirectAttributes.addFlashAttribute("message", e.getMessage());
            return "redirect:/receipt/upload";
        }
    }

    /**
     * 파일의 내용을 SHA-256 해시로 변환하는 헬퍼 메서드
     */
    private String generateFileHash(MultipartFile file) throws Exception {
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] hash = digest.digest(file.getBytes());
        StringBuilder hexString = new StringBuilder();
        for (byte b : hash) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) hexString.append('0');
            hexString.append(hex);
        }
        return hexString.toString();
    }

    @GetMapping("/upload-result")
    public String uploadResultPage() {
        return "receipt/uploadresult";
    }
}