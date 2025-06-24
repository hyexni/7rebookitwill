<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- 1. 페이지 기본 골격과 CSS/폰트 링크 --%>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>
<%-- 2. 상단 헤더 --%>
<%@ include file="/WEB-INF/views/include/header.jsp" %>
<%-- 3. 왼쪽 사이드바 메뉴 --%>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>

<%-- 4. '독후감 목록' 페이지 고유 컨텐츠 시작 --%>
<style>
    /* 페이지 컨테이너 스타일 */
    .list-container {
        width: 100%;
        max-width: 1200px; /* 목록 페이지이므로 너비를 조금 더 넓게 설정 */
        margin: 2rem auto;
        padding: 2rem;
        background-color: #f8f9fa;
        border-radius: 8px;
    }

    .list-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 2rem;
        padding-bottom: 1rem;
        border-bottom: 2px solid #dee2e6;
    }

    .list-header h2 {
        font-size: 1.8rem;
        font-weight: 600;
        color: #333;
    }

    /* 검색창 및 글쓰기 버튼 영역 */
    .action-bar {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 2rem;
    }

    .search-form {
        display: flex;
        gap: 0.5rem;
    }

    .search-form input[type="text"] {
        width: 300px;
        padding: 0.75rem;
        border: 1px solid #ced4da;
        border-radius: 4px;
        font-size: 1rem;
    }

    /* 버튼 스타일 (write.jsp의 스타일 재사용 및 확장) */
    .btn {
        padding: 0.8rem 1.5rem;
        font-size: 1rem;
        font-weight: 600;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        text-decoration: none; /* a 태그의 밑줄 제거 */
        display: inline-block;
        transition: background-color 0.2s, box-shadow 0.2s;
    }

    .btn-primary {
        background-color: #007bff;
        color: white;
    }
    .btn-primary:hover {
        background-color: #0056b3;
        box-shadow: 0 4px 8px rgba(0, 123, 255, 0.2);
    }
    
    .btn-secondary {
        background-color: #6c757d;
        color: white;
    }
    .btn-secondary:hover {
        background-color: #5a6268;
    }

    /* 독후감 카드 그리드 */
    .report-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
        gap: 1.5rem;
        margin-bottom: 2rem;
    }

    /* 개별 독후감 카드 */
    .report-card {
        background-color: #ffffff;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        overflow: hidden;
        transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
    }
    .report-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 16px rgba(0, 0, 0, 0.12);
    }
    
    .report-card a {
        text-decoration: none;
        color: inherit;
        display: block;
    }

    .card-thumbnail {
        width: 100%;
        height: 180px;
        background-color: #e9ecef;
        display: flex;
        align-items: center;
        justify-content: center;
        overflow: hidden;
    }
    .card-thumbnail img {
        width: 100%;
        height: 100%;
        object-fit: cover; /* 이미지가 영역에 꽉 차도록 설정 */
    }
    
    .card-thumbnail .no-image {
        font-size: 1.2rem;
        color: #6c757d;
    }

    .card-body {
        padding: 1rem;
    }

    .card-body h3 {
        font-size: 1.25rem;
        font-weight: 600;
        margin-bottom: 0.5rem;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis; /* 제목이 길 경우 ... 처리 */
    }

    .card-info {
        font-size: 0.9rem;
        color: #6c757d;
        margin-bottom: 0.25rem;
    }

    /* 목록이 비었을 때 메시지 */
    .empty-list {
        text-align: center;
        padding: 5rem 2rem;
        background-color: #ffffff;
        border-radius: 8px;
        color: #6c757d;
        font-size: 1.2rem;
        border: 1px dashed #ced4da;
    }

    /* 페이지네이션 스타일 */
    .pagination {
        display: flex;
        justify-content: center;
        align-items: center;
        margin-top: 2rem;
        list-style: none;
        padding: 0;
    }
    .pagination li a {
        color: #007bff;
        padding: 0.5rem 1rem;
        margin: 0 0.25rem;
        border: 1px solid #dee2e6;
        border-radius: 4px;
        text-decoration: none;
        transition: background-color 0.2s, color 0.2s;
    }
    .pagination li a:hover {
        background-color: #e9ecef;
        border-color: #ced4da;
    }
    .pagination li.active a {
        background-color: #007bff;
        color: white;
        border-color: #007bff;
        font-weight: bold;
    }
    .pagination li.disabled a {
        color: #6c757d;
        pointer-events: none;
        background-color: #e9ecef;
    }
</style>

<div class="list-container">
    <div class="list-header">
        <h2>독후감 목록</h2>
    </div>

    <div class="action-bar">
        <%-- 검색 폼 --%>
        <form action="<c:url value='/bookreport/list' />" method="get" class="search-form">
            <input type="text" name="keyword" placeholder="제목 또는 저자로 검색" value="${param.keyword}">
            <button type="submit" class="btn btn-secondary">검색</button>
        </form>
        
        <%-- 글쓰기 버튼 --%>
        <a href="<c:url value='/bookreport/write'/>" class="btn btn-primary">독후감 작성하기</a>
    </div>

    <%-- 독후감 목록 그리드 --%>
    <div class="report-grid">
        <%-- JSTL을 사용하여 컨트롤러에서 전달받은 독후감 목록(reportList)을 반복 처리 --%>
        <c:choose>
            <c:when test="${not empty reportList}">
                <c:forEach var="report" items="${reportList}">
                    <div class="report-card">
                        <%-- 각 카드를 클릭하면 상세 페이지로 이동 --%>
                        <a href="<c:url value='/bookreport/detail/${report.report_id}'/>">
                            <div class="card-thumbnail">
                                <%-- 첨부된 이미지가 있으면 표시, 없으면 "No Image" 텍스트 표시 --%>
                                <c:choose>
                                    <c:when test="${not empty report.thumbnail_path}">
                                        <img src="<c:url value='${report.thumbnail_path}'/>" alt="${report.report_title} 표지">
                                    </c:when>
                                    <c:otherwise>
                                        <span class="no-image">No Image</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="card-body">
                                <h3>${report.report_title}</h3>
                                <p class="card-info"><strong>저자:</strong> ${report.author_name}</p>
                                <p class="card-info"><strong>작성일:</strong> 
                                    <fmt:formatDate value="${report.created_at}" pattern="yyyy-MM-dd"/>
                                </p>
                            </div>
                        </a>
                    </div>
                </c:forEach>
            </c:when>
            <%-- 목록이 비어있을 경우 메시지 표시 --%>
            <c:otherwise>
                <div class="empty-list">
                    <p>작성된 독후감이 없습니다. 첫 독후감을 작성해보세요!</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <%-- 페이지네이션 (Pagination) --%>
    <%-- 컨트롤러에서 pagination 객체를 전달받았다고 가정 --%>
    <c:if test="${not empty pagination}">
        <ul class="pagination">
            <%-- 이전 페이지 버튼 --%>
            <li class="${pagination.prev ? '' : 'disabled'}">
                <a href="<c:url value='/bookreport/list?page=${pagination.startPage - 1}&keyword=${param.keyword}'/>">&laquo;</a>
            </li>

            <%-- 페이지 번호들 --%>
            <c:forEach begin="${pagination.startPage}" end="${pagination.endPage}" var="pageNum">
                <li class="${pagination.cri.page == pageNum ? 'active' : ''}">
                    <a href="<c:url value='/bookreport/list?page=${pageNum}&keyword=${param.keyword}'/>">${pageNum}</a>
                </li>
            </c:forEach>

            <%-- 다음 페이지 버튼 --%>
            <li class="${pagination.next ? '' : 'disabled'}">
                <a href="<c:url value='/bookreport/list?page=${pagination.endPage + 1}&keyword=${param.keyword}'/>">&raquo;</a>
            </li>
        </ul>
    </c:if>

</div>

<%-- 5. 하단 푸터 --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
