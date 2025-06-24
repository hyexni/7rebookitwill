<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 1. 페이지 기본 골격과 공통 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/header.jsp" %>
<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>

<%-- 4. '독후감 상세' 페이지 고유 컨텐츠 시작 --%>
<style>
    .view-container {
        width: 100%;
        max-width: 800px;
        margin: 2rem auto;
        padding: 2.5rem;
        background-color: #ffffff;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
    }
    .view-header {
        border-bottom: 2px solid #f1f3f5;
        padding-bottom: 1.5rem;
        margin-bottom: 1.5rem;
    }
    .view-title {
        font-size: 2.2rem;
        font-weight: 700;
        color: #343a40;
        margin-bottom: 0.5rem;
    }
    .view-meta {
        display: flex;
        justify-content: space-between;
        align-items: center;
        color: #868e96;
        font-size: 0.95rem;
    }
    .writer-info, .date-info {
        display: flex;
        align-items: center;
    }
    .writer-info .fa-user-circle {
        margin-right: 0.5rem;
        font-size: 1.2rem;
    }
    .date-info span {
        margin-left: 1rem;
    }
    .book-info {
        background-color: #f8f9fa;
        padding: 1rem;
        border-radius: 4px;
        margin-bottom: 2rem;
        font-size: 0.9rem;
        color: #495057;
    }
    .book-info span { margin-right: 1.5rem; }
    .book-info strong { font-weight: 600; margin-right: 0.5rem; }
    
    .view-images {
        margin-bottom: 2rem;
        text-align: center;
    }
    .view-images img {
        max-width: 100%;
        max-height: 400px;
        border-radius: 4px;
        margin: 0.5rem;
        border: 1px solid #dee2e6;
    }
    
    .view-content {
        line-height: 1.8;
        font-size: 1.1rem;
        color: #343a40;
        min-height: 200px;
        white-space: pre-wrap; /* \n (줄바꿈) 문자를 그대로 표시 */
    }
    
    .btn-container {
        text-align: right;
        margin-top: 3rem;
        padding-top: 1.5rem;
        border-top: 1px solid #e9ecef;
    }
    .btn {
        padding: 0.7rem 1.4rem;
        font-size: 1rem;
        font-weight: 600;
        border: 1px solid transparent;
        border-radius: 4px;
        cursor: pointer;
        transition: all 0.2s;
        text-decoration: none;
        display: inline-block;
        margin-left: 0.5rem;
    }
    .btn-primary { background-color: #007bff; color: white; border-color: #007bff; }
    .btn-primary:hover { background-color: #0056b3; border-color: #0056b3; }
    .btn-secondary { background-color: #6c757d; color: white; border-color: #6c757d; }
    .btn-secondary:hover { background-color: #5a6268; border-color: #5a6268; }
    .btn-danger { background-color: #dc3545; color: white; border-color: #dc3545; }
    .btn-danger:hover { background-color: #c82333; border-color: #bd2130; }
</style>

<div class="view-container">
    <%-- 게시글 정보를 Model에서 가져와 출력 --%>
    <c:if test="${not empty report}">
        <div class="view-header">
            <h2 class="view-title">${report.report_title}</h2>
            <div class="view-meta">
                <div class="writer-info">
                    <i class="fas fa-user-circle"></i>
                    <span>${report.nickname}</span>
                </div>
                <div class="date-info">
                    <span><i class="fas fa-calendar-alt"></i> <fmt:formatDate value="${report.report_regdate}" pattern="yyyy.MM.dd HH:mm"/></span>
                    <span><i class="fas fa-eye"></i> ${report.view_count}</span>
                </div>
            </div>
        </div>

        <div class="book-info">
            <span><strong>저자:</strong> ${report.author_name}</span>
            <span><strong>출판사:</strong> ${report.publisher}</span>
            <span><strong>독서일:</strong> <fmt:formatDate value="${report.read_date}" pattern="yyyy년 MM월 dd일"/></span>
        </div>

        <div class="view-images">
            <c:if test="${not empty report.report_image1}"><img src="<c:url value='/resources/upload/${report.report_image1}'/>" alt="첨부 이미지 1"></c:if>
            <c:if test="${not empty report.report_image2}"><img src="<c:url value='/resources/upload/${report.report_image2}'/>" alt="첨부 이미지 2"></c:if>
            <c:if test="${not empty report.report_image3}"><img src="<c:url value='/resources/upload/${report.report_image3}'/>" alt="첨부 이미지 3"></c:if>
        </div>

        <div class="view-content">
            ${report.report_text}
        </div>

        <div class="btn-container">
            <a href="<c:url value='/bookreport/list'/>" class="btn btn-secondary">목록</a>
            
            <%-- ✅ [수정] 로그인 여부를 먼저 확인하여 NullPointerException을 방지합니다. --%>
            <c:if test="${not empty sessionScope.loginUser and sessionScope.loginUser.member_idx == report.member_idx}">
                <a href="<c:url value='/bookreport/update?report_id=${report.report_id}'/>" class="btn btn-primary">수정</a>
                <button type="button" id="deleteBtn" class="btn btn-danger">삭제</button>
            </c:if>
        </div>

        <%-- 삭제 요청을 위한 숨겨진 form --%>
        <form id="deleteForm" action="<c:url value='/bookreport/delete'/>" method="post">
            <input type="hidden" name="report_id" value="${report.report_id}">
        </form>

    </c:if>
    <c:if test="${empty report}">
        <p style="text-align:center; padding: 5rem;">해당 게시글을 찾을 수 없습니다.</p>
    </c:if>
</div>

<script>
document.addEventListener("DOMContentLoaded", function() {
    const deleteBtn = document.getElementById('deleteBtn');
    
    if(deleteBtn) {
        deleteBtn.addEventListener('click', function() {
            if (confirm("정말로 이 독후감을 삭제하시겠습니까? 삭제 후에는 복구할 수 없습니다.")) {
                document.getElementById('deleteForm').submit();
            }
        });
    }
});
</script>

<%-- 5. 페이지 하단 푸터 --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
