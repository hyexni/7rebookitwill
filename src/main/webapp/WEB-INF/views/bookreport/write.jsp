<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<%-- 1. 페이지 기본 골격과 공통 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>

<style>
    /* ================================================================ */
    /* 페이지 전체 레이아웃 설정 */
    /* ================================================================ */
    html {
        height: 100%;
    }
    body {
        min-height: 100%;
        display: flex;
        flex-direction: column;
        font-family: 'Noto Sans KR', sans-serif;
        color: #343a40;
        background-color: #f8f9fa; /* 부드러운 배경색 추가 */
    }

    /* ▼▼▼▼▼▼▼▼▼▼▼▼▼▼ 여기가 가장 중요한 수정 부분입니다 ▼▼▼▼▼▼▼▼▼▼▼▼▼▼ */
    main {
        flex: 1; /* footer를 하단에 고정하는 역할 */
        display: flex; /* 자식 요소(사이드바, 콘텐츠)를 가로로 배치 */
        justify-content: flex-start; /* 자식 요소들을 왼쪽으로 정렬! */
        align-items: flex-start; /* 자식 요소들을 위쪽으로 정렬 */
    }
    /* ▲▲▲▲▲▲▲▲▲▲▲▲▲▲ 이 코드가 왼쪽 정렬을 수행합니다 ▲▲▲▲▲▲▲▲▲▲▲▲▲▲ */

    /* 콘텐츠 컨테이너 스타일 */
    .report-container {
        max-width: 1200px;
        /* auto 대신 고정된 여백을 주어 정렬을 직접 제어합니다. */
        margin: 20px 10px; 
        /* 부모(main)가 flex-grow로 늘어나는 자식을 제어할 것이므로 여기선 너비 100%를 줍니다. */
        width: 100%; 
    }

    /* 폼 전체를 감싸는 카드 디자인 */
    .report-form-card {
        background: #ffffff;
        border: 1px solid #e0e0e0;
        border-radius: 16px;
        padding: 40px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.07);
    }
    
    /* 페이지 제목 스타일 */
    .page-title {
        text-align: center;
        font-size: 2.8rem;
        font-weight: 700;
        color: #131212;
        margin-bottom: 40px;
    }

    /* 폼 라벨 스타일 */
    .form-label {
        font-weight: 500;
        color: #343a40;
        margin-bottom: 8px;
        font-size: 1.05rem;
    }

    /* 입력 필드(input) 스타일 */
    .form-control {
        border-radius: 10px;
        border: 1px solid #ced4da;
        padding: 12px 15px;
        width: 100%; /* 너비를 100%로 설정 */
        transition: border-color 0.2s ease, box-shadow 0.2s ease;
    }

    /* 텍스트 영역(textarea) 스타일 - 분리하여 관리 */
    .form-control.report-content {
        min-height: 300px;
        resize: vertical;
    }

    .form-control:focus {
        border-color: #fbb710;
        box-shadow: 0 0 0 0.25rem rgba(251, 183, 16, 0.2);
        outline: none;
    }

    /* 버튼 공통 스타일 */
    .btn {
        border-radius: 10px;
        font-weight: 700;
        padding: 12px 30px;
        transition: all 0.3s ease;
        border: none;
        cursor: pointer;
    }
    
    .btn:hover {
        transform: translateY(-3px);
        box-shadow: 0 8px 15px rgba(0, 0, 0, 0.15);
    }
    
    .btn-primary { /* 등록하기 버튼 */
        background-color: #fbb710;
        color: white;
    }
    
    .btn-secondary { /* 목록으로 버튼 */
        background-color: #adb5bd;
        color: white;
    }
    
    /* 글자 수 카운터 스타일 */
    .char-counter {
        text-align: right;
        font-size: 0.9em;
        color: #6c757d;
        margin-top: 5px;
        font-weight: 500;
    }
    
    /* 유효성 검사 에러 메시지 스타일 */
    .error-message {
        color: #e55075;
        font-size: 0.85em;
        margin-top: 5px;
        display: none; /* 기본적으로 숨김 */
        font-weight: 500;
    }
</style>

<%-- ... (header, sidebar, alert include는 그대로 유지) ... --%>
<%@include file="/WEB-INF/views/include/header.jsp" %> 
<%@include file="/WEB-INF/views/include/sidebar.jsp" %>
<%@ include file="/WEB-INF/views/include/alert.jsp" %>

<main>
<div class="container report-container">
    <div class="report-form-card">
        <h1 class="page-title">✏️ 나의 독후감 작성하기</h1>
        
        <%-- 유효성 검사를 위해 form에 id 추가 --%>
        <form id="reportForm" action="/bookreport/write" method="post">
            <div class="mb-3">
                <label for="report_title" class="form-label">📖 독후감 제목</label>
                <input type="text" class="form-control" id="report_title" name="report_title" placeholder="멋진 제목을 붙여주세요!" required>
                <div id="title-error" class="error-message">독후감 제목을 입력해주세요.</div>
            </div>

            <div class="row mb-3">
                <div class="col-md-4">
                    <label for="rbook_title" class="form-label">📚 도서명</label>
                    <input type="text" class="form-control" id="rbook_title" name="rbook_title" placeholder="예: 어린왕자" required>
                    <div id="rbook-title-error" class="error-message">도서명을 입력해주세요.</div>
                </div>
                <div class="col-md-4">
                    <label for="author_name" class="form-label">🖋️ 저자</label>
                    <input type="text" class="form-control" id="author_name" name="author_name" placeholder="예: 생텍쥐페리" required>
                    <div id="author-error" class="error-message">저자를 입력해주세요.</div>
                </div>
                <div class="col-md-4">
                    <label for="publisher" class="form-label">🏢 출판사</label>
                    <input type="text" class="form-control" id="publisher" name="publisher" placeholder="예: 열린책들" required>
                    <div id="publisher-error" class="error-message">출판사를 입력해주세요.</div>
                </div>
            </div>

            <div class="mb-3">
                <div class="form-group">                
                <label for="report_text" class="form-label">내용</label>

                <textarea class="form-control" id="report_text" minlenght="100" name="report_text" rows="12" placeholder="책을 읽고 느낀 점이나 인상 깊었던 구절을 자유롭게 작성해보세요.(최소 100자이상)" required></textarea>

            <div id="content-error" class="error-message">내용을 100자 이상 입력해주세요.</div>

            <div id="charCounter" class="char-counter">0 / 1000자</div>
</div>
        </div> 

            

            </div>
            
            <div class="d-flex justify-content-end gap-2 mt-4">
                <button type="submit" class="btn btn-primary">등록하기 ✨</button>
                <a href="/bookreport/list" class="btn btn-secondary">목록으로</a>
            </div>
        </form>
    </div>
</div>
</main>
<script>
document.addEventListener("DOMContentLoaded", function () {
    const reportForm = document.getElementById("reportForm");
    
    // 유효성 검사 대상 필드들
    const reportTitle = document.getElementById("report_title");
    const bookTitle = document.getElementById("rbook_title");
    const authorName = document.getElementById("author_name");
    const publisher = document.getElementById("publisher");
    const reportText = document.getElementById("report_text");
    
    const charCounter = document.getElementById('charCounter');
    const minLength = 100;
    const maxLength = 1000;

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


    // 필드에서 포커스가 벗어날 때 에러 메시지 초기화
    function clearErrorOnFocus(field, errorId) {
        field.addEventListener('focus', function() {
            document.getElementById(errorId).style.display = "none";
            field.style.border = "1px solid #ced4da";
        });
    }

    clearErrorOnFocus(reportTitle, "title-error");
    clearErrorOnFocus(bookTitle, "rbook-title-error");
    clearErrorOnFocus(authorName, "author-error");
    clearErrorOnFocus(publisher, "publisher-error");
    clearErrorOnFocus(reportText, "content-error");

    // 폼 제출 시 유효성 검사
    reportForm.addEventListener("submit", function (e) {
        let isValid = true;

        // 필드 유효성 검사 함수
        function validateField(field, errorId) {
            if (field.value.trim() === "") {
                document.getElementById(errorId).style.display = "block";
                field.style.border = "1px solid #e55075";
                return false;
            }
            return true;
        }

        if (!validateField(reportTitle, "title-error")) isValid = false;
        if (!validateField(bookTitle, "rbook-title-error")) isValid = false;
        if (!validateField(authorName, "author-error")) isValid = false;
        if (!validateField(publisher, "publisher-error")) isValid = false;
        
        // 독후감 본문 100자 이상 검사
        if (reportText.value.trim().length < minLength) { 
            document.getElementById("content-error").style.display = "block";
            reportText.style.border = "1px solid #e55075";
            isValid = false;
        }

        if (!isValid) {
            e.preventDefault(); // 폼 제출 중단
        }
    });
});
</script>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>