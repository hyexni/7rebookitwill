<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 1. 페이지 기본 골격과 CSS/폰트 링크 --%>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>
<%-- 2. 상단 헤더 --%>
<%@ include file="/WEB-INF/views/include/header.jsp" %> 
<%-- 3. 왼쪽 사이드바 메뉴 --%>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>

<%-- 4. '독후감 작성' 페이지 고유 컨텐츠 시작 --%>
<style>
    /* 페이지 컨테이너 스타일 */
    .report-container { 
        width: 100%; 
        max-width: 800px; 
        margin: 2rem auto; 
        padding: 2rem; 
        background-color: #ffffff; 
        border-radius: 8px; 
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08); 
    }
    .report-header h2 { 
        font-size: 1.8rem; 
        font-weight: 600; 
        color: #333; 
        text-align: center; 
        margin-bottom: 2rem; 
    }
    /* 폼 그룹 스타일 */
    .form-group { 
        margin-bottom: 1.5rem; 
    }
    .form-group label { 
        display: block; 
        font-weight: 600; 
        margin-bottom: 0.5rem; 
        color: #495057; 
    }
    .form-group input[type="text"], 
    .form-group input[type="date"], 
    .form-group textarea {
        width: 100%; 
        padding: 0.75rem; 
        border: 1px solid #ced4da; 
        border-radius: 4px; 
        font-size: 1rem;
        transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
    }
    .form-group textarea { 
        min-height: 300px; 
        resize: vertical; 
    }
    .form-group input:focus, 
    .form-group textarea:focus { 
        border-color: #80bdff; 
        box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25); 
        outline: none; 
    }
    /* 버튼 컨테이너 스타일 */
    .btn-container { 
        text-align: right; 
        margin-top: 2rem; 
    }
    .btn { 
        padding: 0.8rem 1.5rem; 
        font-size: 1rem; 
        font-weight: 600; 
        border: none; 
        border-radius: 4px; 
        cursor: pointer; 
        transition: background-color 0.2s;
    }
    .btn-primary { 
        background-color: #007bff; 
        color: white; 
    }
    .btn-primary:hover {
        background-color: #0056b3;
    }
    .btn-secondary { 
        background-color: #6c757d; 
        color: white; 
        margin-left: 0.5rem; 
    }
    .btn-secondary:hover {
        background-color: #5a6268;
    }
    
    /* 파일 입력 관련 스타일 */
    .file-input-wrapper { 
        position: relative; 
        overflow: hidden; 
        display: inline-block; 
        width: 100%; 
    }
    .file-input-wrapper .btn-upload { 
        border: 1px solid #007bff; 
        color: #007bff; 
        background-color: white; 
        padding: 0.75rem; 
        border-radius: 4px; 
        cursor: pointer; 
        font-weight: 500; 
    }
    .file-input-wrapper input[type=file] { 
        font-size: 100px; 
        position: absolute; 
        left: 0; 
        top: 0; 
        opacity: 0; 
        cursor: pointer; 
    }
    .file-name { 
        margin-left: 1rem; 
        color: #6c757d; 
        font-style: italic; 
        vertical-align: middle;
    }
    .image-preview { 
        margin-top: 1rem; 
        max-width: 200px; 
        max-height: 200px; 
        border: 1px solid #ddd; 
        border-radius: 4px; 
        display: none; 
    }

    /* 유효성 검사 및 안내 메시지 스타일 */
    .help-text { 
        font-size: 0.85rem; 
        color: #6c757d; 
        margin-top: 0.25rem; 
    }
    .error-message { 
        color: #dc3545; 
        font-size: 0.85rem; 
        display: none; 
        margin-top: 0.25rem; 
    }
    .char-counter { 
        text-align: right; 
        font-size: 0.9rem; 
        color: #6c757d; 
        margin-top: 0.25rem; 
    }
    
    /* 공개여부 라디오 버튼 스타일 */
    .radio-group label { 
        margin-right: 1.5rem; 
        font-weight: normal; 
        cursor: pointer;
    }
    .radio-group input[type="radio"] { 
        margin-right: 0.5rem; 
        vertical-align: middle;
    }
</style>

<div class="report-container">
    <div class="report-header">
        <h2>독후감 작성</h2>
    </div>

    <%-- 폼 시작: id를 부여하고, 파일 업로드를 위해 enctype 설정 --%>
    <form action="<c:url value='/bookreport/write'/>" method="post" enctype="multipart/form-data" id="reportForm">

        <%-- book_id가 없으므로 사용자가 직접 책 정보를 입력하는 부분만 남깁니다. --%>
        <div class="form-group">
            <label for="report_title">제 목</label>
            <input type="text" id="report_title" name="report_title" placeholder="제목을 입력하세요" required>
            <div id="title-error" class="error-message">제목을 입력해주세요.</div>
        </div>
        <div class="form-group">
            <label for="author_name">저 자</label>
            <input type="text" id="author_name" name="author_name" placeholder="저자를 입력하세요" required>
            <div id="author-error" class="error-message">저자를 입력해주세요.</div>
        </div>
        <div class="form-group">
            <label for="publisher">출판사</label>
            <input type="text" id="publisher" name="publisher" placeholder="출판사를 입력하세요" required>
            <div id="publisher-error" class="error-message">출판사를 입력해주세요.</div>
        </div>

        <div class="form-group">
            <label for="read_date">독서 날짜</label>
            <input type="date" id="read_date" name="read_date" required>
            <div id="date-error" class="error-message">독서 날짜를 선택해주세요.</div>
        </div>
        
        <hr>

        <div class="form-group">
            <label for="report_text">독후감 본문</label>
            <textarea id="report_text" name="report_text" minlength="100" placeholder="여기에 독후감을 작성해주세요. (최소 100자)" required></textarea>
            <div id="content-error" class="error-message">내용을 100자 이상 입력해주세요.</div>
            <div id="charCounter" class="char-counter">0 / 1000자</div>
        </div>
        
        <div class="form-group">
            <label>공개 여부</label>
            <div class="radio-group">
                <label><input type="radio" name="status" value="public" checked> 공개</label>
                <label><input type="radio" name="status" value="private"> 비공개</label>
                   
            </div>
        </div>

        <hr>

        이미지 첨부
        <div class="form-group">
            <label>파일 첨부</label>
            <p class="help-text">책 사진, 메모 등을 이미지 파일(JPG, PNG 등)로 첨부할 수 있습니다.</p>
            <div class="file-input-wrapper" style="margin-top: 1rem;">
                <button type="button" class="btn-upload">파일 선택</button>
                <input type="file" name="report_image1" class="file-input" data-preview-id="preview1" accept="image/*">
                <span class="file-name" data-default-text="파일 1">파일 1</span>
            </div>
            <img id="preview1" class="image-preview" src="#" alt="이미지 미리보기"/>
        </div>
         <div class="form-group">
            <div class="file-input-wrapper">
                <button type="button" class="btn-upload">파일 선택</button>
                <input type="file" name="report_image2" class="file-input" data-preview-id="preview2" accept="image/*">
                <span class="file-name" data-default-text="파일 2">파일 2</span>
            </div>
            <img id="preview2" class="image-preview" src="#" alt="이미지 미리보기"/>
        </div>
         <div class="form-group">
            <div class="file-input-wrapper">
                <button type="button" class="btn-upload">파일 선택</button>
                <input type="file" name="report_image3" class="file-input" data-preview-id="preview3" accept="image/*">
                <span class="file-name" data-default-text="파일 3">파일 3</span>
            </div>
            <img id="preview3" class="image-preview" src="#" alt="이미지 미리보기"/>
        </div>

        <div class="btn-container">
            <button type="submit" class="btn btn-primary">등록하기</button>
            <button type="button" class="btn btn-secondary" onclick="history.back()">취소</button>
        </div>
    </form>
</div>

<script>
document.addEventListener("DOMContentLoaded", function () {
    const reportForm = document.getElementById("reportForm");
    
    // 유효성 검사 대상 필드들
    const bookTitle = document.getElementById("report_title");
    const authorName = document.getElementById("author_name");
    const publisher = document.getElementById("publisher");
    const readDate = document.getElementById("read_date");
    const reportText = document.getElementById("report_text");
    const charCounter = document.getElementById("charCounter");
    
    const minLength = 100;

    // 본문 글자 수 실시간 카운트
    reportText.addEventListener('input', function() {
        const textLength = this.value.length;
        charCounter.textContent = textLength + " / 1000자"; 
        
        if (textLength >= minLength) { 
            charCounter.style.color = '#28a745'; // 기준 충족 시 녹색
        } else {
            charCounter.style.color = '#6c757d'; // 기준 미달 시 회색
        }
    });

    // 폼 제출 시 유효성 검사
    reportForm.addEventListener("submit", function (e) {
        let isValid = true;

        
        // 필드 유효성 검사 함수
        function validateField(field, errorId) {
            if (field.value.trim() === "") {
                document.getElementById(errorId).style.display = "block";
                field.style.border = "1px solid #dc3545";
                return false;
            }
            return true;
        }

        if (!validateField(bookTitle, "title-error")) isValid = false;
        if (!validateField(authorName, "author-error")) isValid = false;
        if (!validateField(publisher, "publisher-error")) isValid = false;
        if (!validateField(readDate, "date-error")) isValid = false;
        
        // 독후감 본문 100자 이상 검사
        if (reportText.value.trim().length < minLength) { 
            document.getElementById("content-error").style.display = "block";
            reportText.style.border = "1px solid #dc3545";
            isValid = false;
        }

        if (!isValid) {
            e.preventDefault(); // 폼 제출 중단
            alert("입력 내용을 다시 확인해주세요.");
            // 첫번째 에러 필드로 포커스 이동 (사용자 편의성)
            const firstErrorField = reportForm.querySelector('.error-message[style*="block"]');
            if (firstErrorField) {
                firstErrorField.previousElementSibling.focus();
            }
        }
    });
    
    // 파일 입력 및 미리보기 스크립트
    document.querySelectorAll('.file-input').forEach(function(input) {
        const wrapper = input.closest('.file-input-wrapper');
        const button = wrapper.querySelector('.btn-upload');
        const fileNameSpan = wrapper.querySelector('.file-name');
        const defaultText = fileNameSpan.dataset.defaultText;

        button.addEventListener('click', function() {
            input.click();
        });
        
        input.addEventListener('change', function(event) {
            const fileName = this.files.length > 0 ? this.files[0].name : defaultText;
            fileNameSpan.textContent = fileName;
            
            const previewId = this.dataset.previewId;
            const preview = document.getElementById(previewId);
            if (this.files && this.files[0] && this.files[0].type.startsWith('image/')) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.src = e.target.result;
                    preview.style.display = 'block';
                }
                reader.readAsDataURL(this.files[0]);
            } else {
                preview.src = '#';
                preview.style.display = 'none';
            }
        });
    });
});
</script>

<%-- 5. 페이지 하단 푸터 --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>