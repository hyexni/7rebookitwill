<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 1. 페이지 기본 골격 링크 --%>
<%@include file="/WEB-INF/views/include/layout_head.jsp" %>

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
        color: #343a40;
    }

    /* ▼▼▼▼▼▼▼▼▼▼▼▼▼▼ 여기가 가장 중요한 수정 부분입니다 ▼▼▼▼▼▼▼▼▼▼▼▼▼▼ */
    main {
        flex: 1; /* footer를 하단에 고정하는 역할 */
        display: flex; /* 자식 요소(사이드바, 콘텐츠)를 가로로 배치 */
        justify-content: flex-start; /* 자식 요소들을 왼쪽으로 정렬! */
        align-items: flex-start; /* 자식 요소들을 위쪽으로 정렬 */
    }
   
    .container {
       max-width: 1000px;
        /* auto 대신 고정된 여백을 주어 정렬을 직접 제어합니다. */
        margin: 20px 10px; 
        /* 부모(main)가 flex-grow로 늘어나는 자식을 제어할 것이므로 여기선 너비 100%를 줍니다. */
        width: 100%; 
    }

    /* 페이지 제목 스타일 */
    .page-title {
        font-weight: 700;
        font-size: 3rem;
        color: #212529;
        text-align: center;
        margin-bottom: 40px;
    }

    /* 폼 전체를 감싸는 카드 디자인 */
    .card {
        background: #ffffff;
        border: 1px solid #e0e0e0;
        border-radius: 16px;
        padding: 40px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.07);
    }
    
    }
    .card-header {
        background-color: #ffffff;
        border-bottom: 1px solid #e9ecef;
        padding: 20px 25px;
    }
    .card-header h3 {
        margin: 0;
        font-size: 1.75rem;
        font-weight: 700;
    }
    .card-body {
        padding: 25px;
        font-size: 1rem;
    }
    .card-body p {
        margin-bottom: 10px;
    }

    /* 독후감 본문 가독성 향상 */
    .report-content {
        line-height: 1.8; /* 줄 간격 넓히기 */
        white-space: pre-wrap; /* DB에 저장된 줄바꿈, 공백을 그대로 표시 */
        font-size: 1.05rem;
        color: #495057;
    }

    .card-footer {
        background-color: #f8f9fa;
        border-top: 1px solid #e9ecef;
        color: #6c757d;
        font-size: 0.9rem;
        padding: 15px 25px;
    }
    
    hr {
        margin: 25px 0;
        border-color: #dee2e6;
    }

    /* 버튼 공통 스타일 */
    .btn {
        display: inline-block;
        font-weight: 500;
        text-align: center;
        vertical-align: middle;
        cursor: pointer;
        user-select: none;
        border: 1px solid transparent;
        padding: 10px 20px;
        font-size: 1rem;
        border-radius: 8px;
        text-decoration: none;
        transition: all 0.2s ease-in-out;
    }
    
    /* 버튼 개별 스타일 및 호버 효과 */
    .btn-secondary { /* 목록 */
        background-color: #6c757d;
        color: white;
    }
    .btn-secondary:hover {
        background-color: #5a6268;
    }
    .btn-warning { /* 수정 */
        background-color: #ffc107;
        color: #212529;
    }
    .btn-warning:hover {
        background-color: #e0a800;
    }
    .btn-danger { /* 삭제 */
        background-color: #dc3545;
        color: white;
    }
    .btn-danger:hover {
        background-color: #c82333;
    }
</style>

<%@include file="/WEB-INF/views/include/header.jsp" %>

<main class="d-flex">
    <%@include file="/WEB-INF/views/include/sidebar.jsp" %>
    <%@ include file="/WEB-INF/views/include/alert.jsp" %>

    <div class="container">
    
    <div class="card">
        <h2 class="page-title">독후감 상세 보기✏️</h2>        
        
            <div class="card-header">
                <h3><c:out value="${vo.report_title}"/></h3>
            </div>
            <div class="card-body">
                <p><strong>책제목:</strong> <c:out value="${vo.rbook_title}"/></p>
                <p><strong>저자:</strong> <c:out value="${vo.author_name}"/></p>
                <p><strong>출판사:</strong> <c:out value="${vo.publisher}"/></p>
                <hr>
                <p class="card-text report-content"><c:out value="${vo.report_text}"/></p>
            </div>
            <div class="card-footer text-muted">
                작성일: <fmt:formatDate value="${vo.report_regdate}" pattern="yyyy-MM-dd HH:mm"/>
            </div>
        </div>
        
        <div class="d-flex justify-content-end gap-3 mt-4">
            <a href="/bookreport/list" class="btn btn-secondary">목록으로</a>
            
            <c:if test="${sessionScope.member_idx == vo.member_idx}">
                <a href="/bookreport/modify?report_id=${vo.report_id}" class="btn btn-warning">수정</a>
                
                <form action="/bookreport/delete" method="post" onsubmit="return confirm('정말로 삭제하시겠습니까?');" style="display: inline;">
                    <input type="hidden" name="report_id" value="${vo.report_id}">
                    <button type="submit" class="btn btn-danger">삭제</button> <%-- btn-primary에서 btn-danger로 변경 --%>
                </form>
            </c:if>
        </div>
    </div>
</main>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>