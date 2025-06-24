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

<%-- 4. '내 독후감 목록' 페이지 고유 컨텐츠 시작 --%>
<style>
    .list-container {
        width: 100%;
        max-width: 1000px;
        margin: 2rem auto;
        padding: 2rem;
        background-color: #ffffff;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
    }
    .list-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 1.5rem;
    }
    .list-header h2 {
        font-size: 1.8rem;
        font-weight: 600;
        color: #333;
    }
    .btn { padding: 0.6rem 1.2rem; font-size: 1rem; font-weight: 600; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; display: inline-block; }
    .btn-primary { background-color: #007bff; color: white; }
    .btn-primary:hover { background-color: #0056b3; }
    
    /* 테이블 스타일 */
    .report-table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 1.5rem;
        font-size: 0.95rem;
    }
    .report-table th, .report-table td {
        padding: 0.9rem;
        text-align: center;
        border-bottom: 1px solid #dee2e6;
    }
    .report-table thead th {
        background-color: #f8f9fa;
        color: #495057;
        font-weight: 600;
        vertical-align: middle;
    }
    .report-table tbody tr:hover {
        background-color: #f1f3f5;
    }
    .report-table .title-cell { text-align: left; }
    .report-table .title-cell a { color: #0056b3; text-decoration: none; font-weight: 500; }
    .report-table .title-cell a:hover { text-decoration: underline; }
    .status-badge { padding: 0.25em 0.6em; font-size: 0.85em; font-weight: 700; border-radius: 10rem; }
    .status-public { background-color: #e2f0ff; color: #007bff; }
    .status-private { background-color: #f8f9fa; color: #6c757d; border: 1px solid #dee2e6; }
    
    /**
     * ✅ [추가] 페이지네이션 버튼 스타일
     */
    .pagination {
        display: flex;
        justify-content: center;
        margin-top: 2.5rem;
    }
    .pagination a {
        color: #007bff;
        padding: 0.6rem 0.9rem;
        margin: 0 0.25rem;
        border: 1px solid #dee2e6;
        text-decoration: none;
        border-radius: 4px;
        transition: background-color 0.2s, color 0.2s;
    }
    .pagination a:not(.disabled):hover {
        background-color: #e9ecef;
    }
    /* 현재 페이지 버튼 스타일 */
    .pagination a.active {
        background-color: #007bff;
        color: white;
        border-color: #007bff;
        cursor: default; /* 현재 페이지는 클릭할 필요 없음 */
    }
    /* 비활성화된 버튼 스타일 (이전/다음) */
    .pagination a.disabled {
        color: #ced4da;
        pointer-events: none; /* 클릭 이벤트 비활성화 */
    }
</style>

<div class="list-container">
    <div class="list-header">
        <h2>내 독후감 목록</h2>
        <a href="<c:url value='/bookreport/write'/>" class="btn btn-primary">
            <i class="fas fa-pen"></i> 새 독후감 쓰기
        </a>
    </div>

    <table class="report-table">
        <thead>
            <tr>
                <th>번호</th>
                <th style="width: 40%;">제목</th>
                <th>저자</th>
                <th>독서일</th>
                <th>공개여부</th>
                <th>작성일</th>
            </tr>
        </thead>
        <tbody>
            <c:if test="${empty reportList}">
                <tr>
                    <td colspan="6" style="padding: 5rem; color: #888;">작성한 독후감이 없습니다.</td>
                </tr>
            </c:if>

            <c:forEach var="report" items="${reportList}">
                <tr>
                    <td>${report.report_id}</td>
                    <td class="title-cell">
                        <a href="<c:url value='/bookreport/view?report_id=${report.report_id}'/>">${report.report_title}</a>
                    </td>
                    <td>${report.author_name}</td>
                    <td><fmt:formatDate value="${report.read_date}" pattern="yyyy-MM-dd" /></td>
                    <td>
                        <c:choose>
                            <c:when test="${report.status eq 'public'}"><span class="status-badge status-public">공개</span></c:when>
                            <c:otherwise><span class="status-badge status-private">비공개</span></c:otherwise>
                        </c:choose>
                    </td>
                    <td><fmt:formatDate value="${report.report_regdate}" pattern="yyyy-MM-dd" /></td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <!-- ✅ [추가] 페이지네이션 UI -->
    <div class="pagination">
        <!-- '이전' 페이지 블럭으로 이동 -->
        <a href="<c:url value='/bookreport/list${pageMaker.makeQuery(pageMaker.startPage - 1)}'/>" 
           class="${!pageMaker.prev ? 'disabled' : ''}">&laquo;</a>

        <!-- 페이지 번호 버튼 -->
        <c:forEach begin="${pageMaker.startPage}" end="${pageMaker.endPage}" var="idx">
            <a href="<c:url value='/bookreport/list${pageMaker.makeQuery(idx)}'/>" 
               class="${pageMaker.cri.page == idx ? 'active' : ''}">${idx}</a>
        </c:forEach>

        <!-- '다음' 페이지 블럭으로 이동 -->
        <a href="<c:url value='/bookreport/list${pageMaker.makeQuery(pageMaker.endPage + 1)}'/>" 
           class="${!pageMaker.next ? 'disabled' : ''}">&raquo;</a>
    </div>

</div>

<%-- 5. 페이지 하단 푸터 --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>