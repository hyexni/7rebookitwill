<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%-- 레이아웃 상단(head, header, sidebar)을 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>
<%@ include file="/WEB-INF/views/include/header.jsp" %> 
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %> 

<style>
    /* ================================================================ */
    /* 기본 레이아웃 및 페이지 컨테이너 설정 */
    /* ================================================================ */
    main.main-content {
        display: flex;
        flex: 1;
        
        padding: 30px;
    }

    .bookreport-container {
        width: 100%;
        max-width: 1400px; /* 최대 너비 설정 */
        margin: 0 auto;
    }

    .bookreport-container h1 {
        font-size: 2.5rem;
        font-weight: 700;
        margin-bottom: 30px;
        color: #212529;
    }

    /* ================================================================ */
    /* 검색 폼 스타일 */
    /* ================================================================ */
    .search-form-wrapper {
        margin-bottom: 30px;
        padding: 25px;
        background-color: #ffffff;
        border: 1px solid #dee2e6;
        border-radius: 12px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.04);
    }
    .search-form-wrapper form {
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 15px;
    }
    .search-form-wrapper select,
    .search-form-wrapper input[type="text"] {
        padding: 10px 14px;
        border: 1px solid #ced4da;
        border-radius: 8px;
        font-size: 16px;
        transition: all 0.2s;
        min-width: 150px;
    }
    .search-form-wrapper input[type="text"] {
        min-width: 300px;
    }
    .search-form-wrapper select:focus,
    .search-form-wrapper input[type="text"]:focus {
        outline: none;
        border-color: #4a90e2;
        box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.2);
    }
    .search-form-wrapper input[type="submit"] {
        padding: 10px 25px;
        font-size: 16px;
        font-weight: 500;
        color: #fff;
        background-color: #4a90e2;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        transition: background-color 0.2s;
    }
    .search-form-wrapper input[type="submit"]:hover {
        background-color: #357ABD;
    }

    /* ================================================================ */
    /* 테이블 스타일 */
    /* ================================================================ */
    .2tables-2 {
        background-color: #fff;
        border-radius: 12px;
        border: 1px solid #dee2e6;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
        overflow: hidden; /* for border-radius */
    }

    .book-report-table {
        width: 100%;
        border-collapse: collapse;
        font-size: 16px;
        line-height: 1.6;
    }

    /* [수정] 다른 CSS 규칙을 무시하고 강제로 스타일을 적용하기 위해 !important를 추가합니다. */
    .bookreport-container .book-report-table thead th {
        padding: 18px 20px;
        color: #343a40;
        font-weight: 700;
        font-size: 20px !important; /* !important 추가 */
        border-bottom: 2px solid #adb5bd;
        vertical-align: middle;
        white-space: nowrap;
    }

    .book-report-table tbody td {
        padding: 16px 20px;
        text-align: center;
        border-bottom: 1px solid #f1f3f5;
        vertical-align: middle;
        color: #495057;
    }
    
    /* 제목, 도서명, 저자는 왼쪽 정렬 */
    .book-report-table th:nth-child(2), .book-report-table td:nth-child(2),
    .book-report-table th:nth-child(3), .book-report-table td:nth-child(3),
    .book-report-table th:nth-child(4), .book-report-table td:nth-child(4) {
        text-align: left;
    }

    .book-report-table tbody tr:last-child td {
        border-bottom: none;
    }
    
    .book-report-table tbody tr {
        transition: background-color 0.2s ease-in-out;
    }
    .book-report-table tbody tr:hover { 
        background-color: #f8f9fa;
        cursor: pointer;
    }

    /* 정렬 링크 및 화살표 스타일 */
    .book-report-table th a {
        text-decoration: none; 
        color: inherit;
        transition: color 0.2s;
    }
    .book-report-table th a:hover {
        color: #4a90e2;
    }
    .book-report-table th.asc a::after,
    .book-report-table th.desc a::after {
        content: '▲';
        font-size: 12px;
        color: #4a90e2;
        margin-left: 6px;
        vertical-align: middle;
    }
    .book-report-table th.desc a::after { 
        content: '▼'; 
    }

    /* 데이터 없을 때 메시지 */
    .no-records td {
        text-align: center; 
        padding: 80px 20px; 
        color: #868e96; 
        font-size: 18px;
    }

    /* ================================================================ */
    /* 페이지네이션 스타일 */
    /* ================================================================ */
    .pagination-wrapper {
        margin-top: 40px; 
        display: flex; 
        justify-content: center;
    }
    .pagination-wrapper a {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        width: 38px; height: 38px;
        margin: 0 5px;
        text-decoration: none;
        color: #495057;
        background-color: #fff;
        border: 1px solid #dee2e6;
        border-radius: 8px;
        transition: all 0.2s;
        font-size: 15px;
    }
    .pagination-wrapper a:hover {
        background-color: #e9ecef;
        border-color: #adb5bd;
    }
    .pagination-wrapper a.active {
        background-color: #4a90e2;
        border-color: #4a90e2;
        color: #fff;
        font-weight: 600;
        cursor: default;
    }
    
}
</style>

<%-- 메인 컨텐츠 영역 시작 --%>
<main class="main-content">
    <div class="bookreport-container">
        <h1>🗂️ 전체 독후감 목록</h1>

        <%-- 검색 기능 --%> 
        <div class="search-form-wrapper">
    <div style="display: flex; justify-content: center; align-items: center; gap: 15px;">
        <!-- 검색 form -->
        <form action="<c:url value='/bookreport/list'/>" method="get" style="display: flex; align-items: center; gap: 15px;">
            <input type="hidden" name="sortColumn" value="${pageMaker.cri.sortColumn}">
            <input type="hidden" name="sortOrder" value="${pageMaker.cri.sortOrder}">
        
            <select name="searchType">
                <option value="report_title" ${pageMaker.cri.searchType == 'report_title' ? 'selected' : ''}>독후감 제목</option>
                <option value="rbook_title" ${pageMaker.cri.searchType == 'rbook_title' ? 'selected' : ''}>책 제목</option>
                <option value="author_name" ${pageMaker.cri.searchType == 'author_name' ? 'selected' : ''}>저자</option>
            </select>
            <input type="text" name="keyword" value="${pageMaker.cri.keyword}" placeholder="검색어를 입력하세요">
            <input type="submit" value="검색">
        </form>

        <!-- 글쓰기 form (같은 라인에 붙임) -->
        <form action="<c:url value='/bookreport/write'/>" method="get">
            <input type="submit" value="글쓰기" style="background-color: #28a745;">
        </form>
    </div>
</div>

        <div class="2tables-2">
            <table class="book-report-table">
                <thead>
                    <tr>
                        <th class="${pageMaker.cri.sortColumn == 'report_id' ? pageMaker.cri.sortOrder : ''}" style="width: 10%;">
                            <a href="<c:url value='/bookreport/list${pageMaker.cri.sortUrl("report_id")}' />"><h5>#번호</h5></a>
                        </th>
                        <th class="${pageMaker.cri.sortColumn == 'report_title' ? pageMaker.cri.sortOrder : ''}" style="width: auto;">
                            <a href="<c:url value='/bookreport/list${pageMaker.cri.sortUrl("report_title")}' />"><h5>독후감 제목</h5></a>
                        </th>
                        <th class="${pageMaker.cri.sortColumn == 'rbook_title' ? pageMaker.cri.sortOrder : ''}" style="width: 20%;">
                            <a href="<c:url value='/bookreport/list${pageMaker.cri.sortUrl("rbook_title")}' />"><h5>도서명</h5></a>
                        </th>
                        <th class="${pageMaker.cri.sortColumn == 'author_name' ? pageMaker.cri.sortOrder : ''}" style="width: 15%;">
                            <a href="<c:url value='/bookreport/list${pageMaker.cri.sortUrl("author_name")}' />"><h5>저자</h5></a>
                        </th>
                        <th class="${pageMaker.cri.sortColumn == 'report_regdate' ? pageMaker.cri.sortOrder : ''}" style="width: 15%;">
                            <a href="<c:url value='/bookreport/list${pageMaker.cri.sortUrl("report_regdate")}' />"><h5>작성일</h5></a>
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty bookreportList}">
                            <c:forEach var="bookreport" items="${bookreportList}">
                                <tr onclick="location.href='<c:url value="/bookreport/read?report_id=${bookreport.report_id}&pageNum=${pageMaker.cri.page}&searchType=${pageMaker.cri.searchType}&keyword=${pageMaker.cri.keyword}" />'">
                                    <td>${bookreport.report_id}</td>
                                    <td>${bookreport.report_title}</td>
                                    <td>${bookreport.rbook_title}</td>
                                    <td>${bookreport.author_name}</td>
                                    <td><fmt:formatDate value="${bookreport.report_regdate}" pattern="yyyy-MM-dd"/></td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr class="no-records">
                                <td colspan="5">독후감 내역이 없습니다.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

        <%-- 페이징 UI --%>
        <div class="pagination-wrapper">
            <c:if test="${pageMaker.prev}">
                <a href="<c:url value='/bookreport/list${pageMaker.cri.pageUrl(pageMaker.startPage - 1)}'/>">&laquo;</a>
            </c:if>
            <c:forEach begin="${pageMaker.startPage}" end="${pageMaker.endPage}" var="pageNum">
                <a href="<c:url value='/bookreport/list${pageMaker.cri.pageUrl(pageNum)}'/>" 
                   class="${pageMaker.cri.page == pageNum ? 'active' : ''}">${pageNum}</a>
            </c:forEach>
            <c:if test="${pageMaker.next}">
                <a href="<c:url value='/bookreport/list${pageMaker.cri.pageUrl(pageMaker.endPage + 1)}'/>">&raquo;</a>
            </c:if>
        </div>
        
    </div>
</main>

<%-- 하단 푸터를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
