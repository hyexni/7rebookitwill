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
    /* 기존 스타일은 유지하고, 필요한 스타일만 추가/수정합니다. */
    .report-container { width: 100%; max-width: 800px; margin: 2rem auto; padding: 2rem; background-color: #ffffff; border-radius: 8px; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08); }
    .report-header h2 { font-size: 1.8rem; font-weight: 600; color: #333; text-align: center; margin-bottom: 2rem; }
    .form-group { margin-bottom: 1.5rem; }
    .form-group label { display: block; font-weight: 600; margin-bottom: 0.5rem; color: #495057; }
    .form-group input[type="text"], .form-group input[type="date"], .form-group textarea {
        width: 100%; padding: 0.75rem; border: 1px solid #ced4da; border-radius: 4px; font-size: 1rem;
    }
    .form-group textarea { min-height: 300px; resize: vertical; }
    .form-group input:focus, .form-group textarea:focus { border-color: #80bdff; box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25); outline: none; }
    .form-control-readonly { background-color: #e9ecef; cursor: not-allowed; }
    .btn-container { text-align: right; margin-top: 2rem; }
    .btn { padding: 0.8rem 1.5rem; font-size: 1rem; font-weight: 600; border: none; border-radius: 4px; cursor: pointer; }
    .btn-primary { background-color: #007bff; color: white; }
    .btn-secondary { background-color: #6c757d; color: white; margin-left: 0.5rem; }
    
    /* 파일 입력 관련 스타일 */
    .file-input-wrapper { position: relative; overflow: hidden; display: inline-block; width: 100%; }
    .file-input-wrapper .btn-upload { border: 1px solid #007bff; color: #007bff; background-color: white; padding: 0.75rem; border-radius: 4px; cursor: pointer; font-weight: 500; }
    .file-input-wrapper input[type=file] { font-size: 100px; position: absolute; left: 0; top: 0; opacity: 0; cursor: pointer; }
    .file-name { margin-left: 1rem; color: #6c757d; font-style: italic; }
    .image-preview { margin-top: 1rem; max-width: 200px; max-height: 200px; border: 1px solid #ddd; border-radius: 4px; display: none; }

    /* 유효성 검사 및 안내 메시지 스타일 */
    .help-text { font-size: 0.85rem; color: #6c757d; margin-top: 0.25rem; }
    .error-message { color: #dc3545; font-size: 0.85rem; display: none; margin-top: 0.25rem; }
    .char-counter { text-align: right; font-size: 0.9rem; color: #6c757d; margin-top: 0.25rem; }
    
    /* 공개여부 라디오 버튼 스타일 */
    .radio-group label { margin-right: 1.5rem; font-weight: normal; }
    .radio-group input[type="radio"] { margin-right: 0.5rem; }
</style>

<div class="report-container">
    <div class="report-header">
        <h2>독후감 작성</h2>
    </div>

    <%-- 폼 시작: id를 부여하고, 파일 업로드를 위해 enctype 설정 --%>
    <form action="<c:url value='/bookreport/write'/>" method="post" enctype="multipart/form-data" id="reportForm">

        <%-- book_id가 있는 경우(책 선택 후 글쓰기)와 없는 경우(자유 글쓰기)를 분기 처리 --%>
        <c:choose>
            <%-- Case 1: 책을 선택하고 온 경우 (book 객체가 존재) --%>
            <c:when test="${not empty book}">
                <input type="hidden" name="book_id" value="${book.book_id}">
                <div class="form-group">
                    <label for="book_title">책 제목</label>
                    <input type="text" id="book_title" name="book_title" class="form-control-readonly" value="<c:out value='${book.book_title}'/>" readonly>
                </div>
                <div class="form-group">
                    <label for="author_name">저자</label>
                    <input type="text" id="author_name" name="author_name" class="form-control-readonly" value="<c:out value='${book.author}'/>" readonly>
                </div>
                <div class="form-group">
                    <label for="publisher">출판사</label>
                    <input type="text" id="publisher" name="publisher" class="form-control-readonly" value="<c:out value='${book.publisher}'/>" readonly>
                </div>
            </c:when>

            <%-- Case 2: 자유롭게 글을 쓰는 경우 (book 객체가 없음) --%>
            <c:otherwise>
                <div class="form-group">
                    <label for="book_title">책 제목</label>
                    <input type="text" id="book_title" name="book_title" placeholder="책 제목을 입력하세요" required>
                    <div id="title-error" class="error-message">책 제목을 입력해주세요.</div>
                </div>
                <div class="form-group">
                    <label for="author_name">저자</label>
                    <input type="text" id="author_name" name="author_name" placeholder="저자를 입력하세요" required>
                    <div id="author-error" class="error-message">저자를 입력해주세요.</div>
                </div>
                <div class="form-group">
                    <label for="publisher">출판사</label>
                    <input type="text" id="publisher" name="publisher" placeholder="출판사를 입력하세요" required>
                    <div id="publisher-error" class="error-message">출판사를 입력해주세요.</div>
                </div>
            </c:otherwise>
        </c:choose>

        <div class="form-group">
            <label for="read_date">독서 날짜</label>
            <input type="date" id="read_date" name="read_date" required>
            <div id="date-error" class="error-message">독서 날짜를 선택해주세요.</div>
        </div>
        
        <hr>

        <div class="form-group">
            <label for="report_text">독후감 본문</label>
            <textarea id="report_text" name="report_text" minlength="100"  placeholder="여기에 독후감을 작성해주세요." required></textarea>
            <div class="help-text">최소 100자 이상 작성해주세요.</div>
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

        <%-- 이미지 첨부 (요구사항 반영) --%>
        <div class="form-group">
            <label>파일 첨부</label>
            <p class="help-text">책 사진, 메모 등을 JPG, PNG, PDF 형식으로 첨부할 수 있습니다. (최대 10MB)</p>
            <div class="file-input-wrapper" style="margin-top: 1rem;">
                <button type="button" class="btn-upload">파일 선택</button>
                <input type="file" name="report_image1" class="file-input" data-preview-id="preview1" accept=".jpg, .jpeg, .png, .pdf">
                <span class="file-name">파일 1</span>
            </div>
            <img id="preview1" class="image-preview" src="#" alt="이미지 미리보기"/>
        </div>
         <div class="form-group">
            <div class="file-input-wrapper">
                <button type="button" class="btn-upload">파일 선택</button>
                <input type="file" name="report_image2" class="file-input" data-preview-id="preview2" accept=".jpg, .jpeg, .png, .pdf">
                <span class="file-name">파일 2</span>
            </div>
            <img id="preview2" class="image-preview" src="#" alt="이미지 미리보기"/>
        </div>
         <div class="form-group">
            <div class="file-input-wrapper">
                <button type="button" class="btn-upload">파일 선택</button>
                <input type="file" name="report_image3" class="file-input" data-preview-id="preview3" accept=".jpg, .jpeg, .png, .pdf">
                <span class="file-name">파일 3</span>
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
    const bookTitle = document.getElementById("book_title");
    const authorName = document.getElementById("author_name");
    const publisher = document.getElementById("publisher");
    const readDate = document.getElementById("read_date");
    const reportText = document.getElementById("report_text");
    const charCounter = document.getElementById("charCounter");
    
    const minLength = 100; // 

    // 본문 글자 수 실시간 카운트
    reportText.addEventListener('input', function() {
        const textLength = this.value.length;
        // [최대 글자 수를 1000으로 통일
        charCounter.textContent = textLength + " / 1000자"; 
        
        // minLength 변수(100)로 변경
        if (textLength >= minLength) { 
            charCounter.style.color = '#28a745'; // 기준 충족 시 녹색
        } else {
            charCounter.style.color = '#6c757d'; // 기준 미달 시 회색
        }
    });

    // 폼 제출 시 유효성 검사
    reportForm.addEventListener("submit", function (e) {
        let isValid = true;

        // 에러 메시지 초기화
        document.querySelectorAll('.error-message').forEach(el => el.style.display = 'none');
        document.querySelectorAll('input, textarea').forEach(el => el.style.border = "1px solid #ced4da");
        
        // '자유 글쓰기' 모드일 때만 책 정보 필드 검사 (readonly가 아닐 때)
        if (!bookTitle.readOnly && bookTitle.value.trim() === "") {
            document.getElementById("title-error").style.display = "block";
            bookTitle.style.border = "1px solid #dc3545";
            isValid = false;
        }
        if (!authorName.readOnly && authorName.value.trim() === "") {
            document.getElementById("author-error").style.display = "block";
            authorName.style.border = "1px solid #dc3545";
            isValid = false;
        }
        if (!publisher.readOnly && publisher.value.trim() === "") {
            document.getElementById("publisher-error").style.display = "block";
            publisher.style.border = "1px solid #dc3545";
            isValid = false;
        }
        
        // 독서 날짜 검사
        if (readDate.value === "") {
            document.getElementById("date-error").style.display = "block";
            readDate.style.border = "1px solid #dc3545";
            isValid = false;
        }

        // [수정] 독후감 본문 100자 이상 검사
        if (reportText.value.trim().length < minLength) { 
            document.getElementById("content-error").style.display = "block";
            reportText.style.border = "1px solid #dc3545";
            isValid = false;
        }

        if (!isValid) {
            e.preventDefault(); // 폼 제출 중단
            alert("입력 내용을 다시 확인해주세요.");
        }
    });
    
    // 파일 입력 및 미리보기 스크립트 (기존 로직 유지)
    document.querySelectorAll('.file-input').forEach(function(input) {
        input.closest('.file-input-wrapper').querySelector('.btn-upload').addEventListener('click', function() {
            input.click();
        });
        
        input.addEventListener('change', function(event) {
            const fileNameSpan = this.closest('.file-input-wrapper').querySelector('.file-name');
            const fileName = this.files.length > 0 ? this.files[0].name : (fileNameSpan.dataset.default || '파일 선택');
            fileNameSpan.textContent = fileName;
            
            const previewId = this.dataset.previewId;
            const preview = document.getElementById(previewId);
            if (this.files && this.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.src = e.target.result;
                    preview.style.display = 'block';
                }
                reader.readAsDataURL(this.files[0]);
            } else {
                preview.style.display = 'none';
            }
        });
    });
});
</script>

<%-- 5. 페이지 하단 푸터 --%>
<%-- 주석 처리된 footer include는 파일 경로 문제 등이 있을 수 있으니 확인 후 주석을 해제하세요. --%>
<%-- <%@ include file="/WEB-INF/views/include/footer.jsp" %> --%>