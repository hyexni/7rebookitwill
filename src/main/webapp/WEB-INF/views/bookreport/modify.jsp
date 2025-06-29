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
       
    }

    main {
        flex: 1; /* footer를 하단에 고정하는 역할 */
        display: flex; 
        justify-content: flex-start; 
        align-items: flex-start; 
    }

    /* 콘텐츠 컨테이너 스타일 */
    .report-container {
        max-width: 1200px;
        margin: 20px 10px; 
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
    
</style>

<%@include file="/WEB-INF/views/include/header.jsp" %> 
<%@include file="/WEB-INF/views/include/sidebar.jsp" %>
<%@ include file="/WEB-INF/views/include/alert.jsp" %>

<main>
<div class="container report-container">
    <div class="report-form-card">
        <h1 class="page-title">✏️ 나의 독후감 수정하기</h1>
        
        <%-- [수정] 폼의 action을 수정 처리 주소로 변경 --%>
        <form id="reportForm" action="/bookreport/modify" method="post">

            <%-- [핵심 수정 1] 글 번호(report_id)를 form에 숨겨서 전송합니다. --%>
            <input type="hidden" name="report_id" value="${vo.report_id}">

            <div class="mb-3">
                <label for="report_title" class="form-label">📖 독후감 제목</label>
                <%-- [핵심 수정 2] value 속성에 컨트롤러에서 받은 vo의 값을 채워줍니다. --%>
                <input type="text" class="form-control" id="report_title" name="report_title" value="${vo.report_title}">
            </div>

            <div class="row mb-3">
                <div class="col-md-4">
                    <label for="rbook_title" class="form-label">📚 도서명</label>
                    <input type="text" class="form-control" id="rbook_title" name="rbook_title" value="${vo.rbook_title}">
                </div>
                <div class="col-md-4">
                    <label for="author_name" class="form-label">🖋️ 저자</label>
                    <input type="text" class="form-control" id="author_name" name="author_name" value="${vo.author_name}">
                </div>
                <div class="col-md-4">
                    <label for="publisher" class="form-label">🏢 출판사</label>
                    <input type="text" class="form-control" id="publisher" name="publisher" value="${vo.publisher}">
                </div>
            </div>

            <div class="mb-3">
                <div class="form-group">        
                    <label for="report_content" class="form-label">내용</label> 
                    <%-- [핵심 수정 3] textarea는 태그 사이에 vo의 값을 채워줍니다. --%>
                    <textarea class="form-control report-text" id="report_text" name="report_text" rows="12">${vo.report_text}</textarea>
                    <div id="charCounter" class="char-counter">0 / 1000자</div>
                </div>
            </div>  
            
            <div class="d-flex justify-content-end gap-2 mt-4">
                <%-- [수정] 버튼은 form의 submit 역할을 하도록 변경 --%>
                <button type="submit" class="btn btn-primary">수정 완료 ✨</button>
                <%-- [수정] 목록으로 가는 버튼은 일반 링크(a 태그)로 변경 --%>
                <a href="/bookreport/list" class="btn btn-secondary">취소</a>
            </div>
        </form>
    </div>
</div>
</main>
<script>
// 스크립트는 기존 코드와 거의 동일, textarea의 ID만 수정
document.addEventListener("DOMContentLoaded", function () {
    const reportText = document.getElementById("report_text"); // ID 수정
    const charCounter = document.getElementById('charCounter');
    const minLength = 100;
    const maxLength = 1000;

    // 페이지 로드 시 기존 내용의 글자 수 계산
    function updateCounter() {
        const textLength = reportText.value.length;
        charCounter.textContent = textLength + " / 1000자";
        if (textLength >= minLength) {
            charCounter.style.color = '#28a745';
        } else {
            charCounter.style.color = '#6c757d';
        }
    }

    // 페이지가 처음 열렸을 때 한 번 실행
    updateCounter(); 

    // 내용이 입력될 때마다 실행
    reportText.addEventListener('input', updateCounter);

    // 이하 유효성 검사 로직은 그대로 유지...
    const reportForm = document.getElementById("reportForm");
    reportForm.addEventListener("submit", function (e) {
        // ...
    });
});
</script>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>
