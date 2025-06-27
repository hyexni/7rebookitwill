<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%-- 레이아웃 상단(head, header, sidebar)을 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>
<%@ include file="/WEB-INF/views/include/header.jsp" %> 
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %> 

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
    .bookreport-container {
        max-width: 1200px;
        /* auto 대신 고정된 여백을 주어 정렬을 직접 제어합니다. */
        margin: 20px 10px; 
        /* 부모(main)가 flex-grow로 늘어나는 자식을 제어할 것이므로 여기선 너비 100%를 줍니다. */
        width: 100%; 
    }

    /* 검색 폼 */
    .bookreport-container .search-form {
        margin-bottom: 40px;
        padding: 20px;
        background-color: #fff;
        border: 1px solid #e9ecef;
        border-radius: 8px;
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 10px;
    }
    .bookreport-container .search-form select,
    .bookreport-container .search-form input[type="text"] {
        padding: 10px 14px;
        border: 1px solid #ced4da;
        border-radius: 6px;
        font-size: 16px;
        transition: all 0.2s;
        min-width: 150px;
    }
    .bookreport-container .search-form input[type="text"] {
        min-width: 300px;
    }
    .bookreport-container .search-form select:focus,
    .bookreport-container .search-form input[type="text"]:focus {
        outline: none;
        border-color: #4a90e2;
        box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.2);
    }
    .bookreport-container .search-form input[type="submit"] {
        padding: 10px 25px;
        font-size: 16px;
        font-weight: 500;
        color: #fff;
        background-color: #4a90e2;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        transition: background-color 0.2s;
    }
    .bookreport-container .search-form input[type="submit"]:hover {
        background-color: #357ABD;
    }

    /* 테이블 래퍼 */
    .table-wrapper {
        background-color: #fff;
        border-radius: 8px;
        border: 1px solid #e9ecef;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
        overflow: hidden;
    }

    /* 테이블 스타일 */
    .bookreport-container table {
        width: 100%;
        border-collapse: collapse;
        font-size: 16px;
        line-height: 1.6;
    }
    .bookreport-container thead {
        background-color: #fff;
    }
    
    /* [수정] 모든 th의 기본 스타일을 재설정합니다. */
    .bookreport-container th {
        padding: 16px 0px;
        text-align: center;
        color: #343a40;
        font-weight: 600;
        font-size: 14px; /* 나머지 헤더들의 기본 폰트 크기 */
        border-bottom: 2px solid #343a40;
        vertical-align: middle;
    }
    
    /* [추가] 요청하신 특정 헤더(#번호, 독후감 제목)의 글자 크기를 키웁니다. */
    .bookreport-container th:nth-child(1),
    .bookreport-container th:nth-child(2) {
        font-size: 30px; /* 강조할 헤더의 폰트 크기 */
    }

    .bookreport-container td {
        padding: 16px 20px;
        text-align: center;
        border-bottom: 1px solid #f1f3f5;
        vertical-align: middle;
        color: #495057;
    }
    .bookreport-container tbody tr:last-child td {
        border-bottom: none;
    }

    .bookreport-container td:nth-child(2),
    .bookreport-container td:nth-child(3),
    .bookreport-container td:nth-child(4) {
        text-align: left;
    }

    .bookreport-container tbody tr {
        transition: all 0.2s ease-in-out;
    }
    .bookreport-container tbody tr:hover { 
        background-color: #f8f9fa;
        cursor: pointer;
        transform: translateY(-3px);
        box-shadow: 0 6px 20px rgba(0, 0, 0, 0.07);
    }

    /* 클릭 정렬 화살표 */
    .bookreport-container th a {
        text-decoration: none; color: inherit;
    }
    .bookreport-container th.asc a::after,
    .bookreport-container th.desc a::after {
        content: '▲';
        font-size: 10px;
        color: #4a90e2;
        margin-left: 5px;
    }
    .bookreport-container th.desc a::after { content: '▼'; }

    /* 데이터 없을 때 메시지 */
    .bookreport-container .no-records {
        text-align: center; padding: 80px 20px; color: #868e96; font-size: 18px;
    }

    /* 페이지네이션 */
    .bookreport-container .pagination {
        margin-top: 40px; display: flex; justify-content: center;
    }
    .bookreport-container .pagination a {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        width: 38px; height: 38px;
        margin: 0 5px;
        text-decoration: none;
        color: #495057;
        background-color: #fff;
        border: 1px solid #dee2e6;
        border-radius: 6px;
        transition: all 0.2s;
        font-size: 15px;
    }
    .bookreport-container .pagination a:hover {
        background-color: #e9ecef;
        border-color: #4a90e2;
        color: #4a90e2;
    }
    .bookreport-container .pagination a.active {
        background-color: #4a90e2;
        border-color: #4a90e2;
        color: #fff;
        font-weight: 600;
        cursor: default;
    }
    
    .content-wrapper {
        padding: 40px 20px;
        padding-bottom: 80px !important; 
    }
</style>
<%-- 메인 컨텐츠 영역 시작 --%>
<div class="content-wrapper" style="background-color: #fff;">
<main class="main-content" style="padding:20px;">
    <div class="bookreport-container">
        <h1>🗂️ 전체 독후감 목록</h1>

        <%-- 검색 기능 --%> 
        <div class="search-form">
            <form action="<c:url value='/bookreport/list'/>" method="get">
                <%-- 현재 정렬 기준을 숨겨진 값으로 함께 전송하여 정렬 상태를 유지합니다. --%>
                <input type="hidden" name="sortColumn" value="${pageMaker.cri.sortColumn}">
                <input type="hidden" name="sortOrder" value="${pageMaker.cri.sortOrder}">
            
                <%-- [수정] 검색 필드 value와 selected 조건 수정 --%>
                <select name="searchType">
                    <option value="report_title" ${pageMaker.cri.searchType == 'report_title' ? 'selected' : ''}>독후감 제목</option>
                    <option value="rbook_title" ${pageMaker.cri.searchType == 'rbook_title' ? 'selected' : ''}>책 제목</option>
                    <option value="author_name" ${pageMaker.cri.searchType == 'author_name' ? 'selected' : ''}>저자</option>
                </select>
                <input type="text" name="keyword" value="${pageMaker.cri.keyword}" placeholder="검색어를 입력하세요">
                <input type="submit" value="검색">
            </form>
        </div>

        <table>
            <thead>
                <tr>
                    <%-- 클릭 정렬 기능이 적용된 테이블 헤더 --%>
                    <th class="${pageMaker.cri.sortColumn == 'report_id' ? pageMaker.cri.sortOrder : ''}" style="width: 8%;">
                        <a href="<c:url value='/bookreport/list${pageMaker.cri.sortUrl("report_id")}' />">#번호</a>
                    </th>
                    <th class="${pageMaker.cri.sortColumn == 'report_title' ? pageMaker.cri.sortOrder : ''}" style="width: auto;"> <%-- [수정] 너비 자동 조정 --%>
                        <a href="<c:url value='/bookreport/list${pageMaker.cri.sortUrl("report_title")}' />">독후감 제목</a>
                    </th>
                    <th class="${pageMaker.cri.sortColumn == 'rbook_title' ? pageMaker.cri.sortOrder : ''}" style="width: 20%;">
                        <a href="<c:url value='/bookreport/list${pageMaker.cri.sortUrl("rbook_title")}' />">도서명</a>
                    </th>
                    <th class="${pageMaker.cri.sortColumn == 'author_name' ? pageMaker.cri.sortOrder : ''}" style="width: 15%;">
                        <a href="<c:url value='/bookreport/list${pageMaker.cri.sortUrl("author_name")}' />">저자</a>
                    </th>
                    <th class="${pageMaker.cri.sortColumn == 'report_regdate' ? pageMaker.cri.sortOrder : ''}" style="width: 15%;">
                        <a href="<c:url value='/bookreport/list${pageMaker.cri.sortUrl("report_regdate")}' />">작성일</a>
                    </th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty bookreportList}">
                        <c:forEach var="bookreport" items="${bookreportList}">
                            <%-- [수정] onclick 이벤트의 변수명 오류 수정 및 URL c:url 태그 적용, 중첩된 <tr> 제거 --%>
                            <tr onclick="location.href='<c:url value="/bookreport/read?report_id=${bookreport.report_id}&pageNum=${pageMaker.cri.page}&searchType=${pageMaker.cri.searchType}&keyword=${pageMaker.cri.keyword}" />'">
                                <td>${bookreport.report_id}</td>
                                <td>${bookreport.report_title}</td>
                                <td>${bookreport.rbook_title}</td>
                                <td>${bookreport.author_name}</td>
                                <td><fmt:formatDate value="${bookreport.report_regdate}" pattern="yyyy-MM-dd"/></td> <%-- [수정] 날짜 형식 간단하게 변경 --%>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="5" class="no-records">독후감 내역이 없습니다.</td> <%-- [수정] colspan 5로 변경 --%>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>

        <%-- 개선된 페이징 UI --%>
        <div class="pagination">
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
</div>

<%-- 하단 푸터를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>