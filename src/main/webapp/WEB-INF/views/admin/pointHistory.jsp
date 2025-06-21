<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 1. 페이지 기본 골격과 공통 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="include/layout_head.jsp" %>

<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@ include file="include/header.jsp" %> 

<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@ include file="include/sidebar.jsp" %> 

<%-- 
=========================================================================
    [핵심] 관리자 포인트 내역 페이지 전용 스타일 정의
=========================================================================
--%>
<style>
    /* 이 스타일은 다른 페이지에 영향을 주지 않도록, 
      모든 선택자 앞에 고유 클래스인 .admin-point-container 를 붙여 범위를 제한합니다. 
    */

    .admin-point-container h1 {
        font-size: 26px;
        font-weight: 700;
        color: #212529;
        margin-top: 0;
        margin-bottom: 30px;
        text-align: center;
    }

    /* 검색 폼 */
    .admin-point-container .search-form {
        margin-bottom: 30px;
        padding: 20px;
        background-color: #f1f3f5;
        border-radius: 6px;
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 10px;
    }
    .admin-point-container .search-form select,
    .admin-point-container .search-form input[type="text"] {
        padding: 9px 12px;
        border: 1px solid #dee2e6;
        border-radius: 4px;
        font-size: 15px;
        transition: border-color 0.2s, box-shadow 0.2s;
    }
    .admin-point-container .search-form select:focus,
    .admin-point-container .search-form input[type="text"]:focus {
        outline: none;
        border-color: #4c6ef5;
        box-shadow: 0 0 0 2px rgba(76, 110, 245, 0.2);
    }
    .admin-point-container .search-form input[type="submit"] {
        padding: 9px 25px;
        font-size: 15px;
        font-weight: 500;
        color: #fff;
        background-color: #4c6ef5;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        transition: background-color 0.2s;
    }
    .admin-point-container .search-form input[type="submit"]:hover {
        background-color: #364fc7;
    }

    /* 테이블 */
    .admin-point-container table {
        width: 100%;
        border-collapse: collapse;
        font-size: 15px;
    }
    .admin-point-container thead {
        background-color: #f8f9fa;
    }
    .admin-point-container th, 
    .admin-point-container td {
        padding: 14px 10px;
        text-align: center;
        border-bottom: 1px solid #dee2e6;
    }
    .admin-point-container th {
        color: #495057;
        font-weight: 500;
        vertical-align: middle;
    }
    .admin-point-container tbody tr:hover {
        background-color: #f1f3f5;
    }

    /* 정렬 기능 시각적 표현 (화살표) */
    .admin-point-container th a {
        text-decoration: none;
        color: inherit;
        display: inline-block;
        position: relative;
        padding-right: 15px;
    }
    .admin-point-container th.asc a::after,
    .admin-point-container th.desc a::after {
        content: '';
        position: absolute;
        right: 0;
        top: 50%;
        transform: translateY(-50%);
        font-size: 10px;
        color: #4c6ef5;
    }
    .admin-point-container th.asc a::after {
        content: '▲';
    }
    .admin-point-container th.desc a::after {
        content: '▼';
    }

    /* 내역 없을 때 메시지 */
    .admin-point-container .no-records {
        text-align: center;
        padding: 60px 20px;
        color: #868e96;
    }

    /* 페이지네이션 */
    .admin-point-container .pagination {
        margin-top: 30px;
        text-align: center;
    }
    .admin-point-container .pagination a {
        display: inline-block;
        width: 36px;
        height: 36px;
        line-height: 36px;
        margin: 0 4px;
        text-align: center;
        text-decoration: none;
        color: #495057;
        background-color: #fff;
        border: 1px solid #dee2e6;
        border-radius: 4px;
        transition: all 0.2s;
    }
    .admin-point-container .pagination a:hover {
        background-color: #f1f3f5;
        border-color: #4c6ef5;
        color: #4c6ef5;
    }
    .admin-point-container .pagination a.active {
        background-color: #4c6ef5;
        border-color: #4c6ef5;
        color: #fff;
        font-weight: 500;
        cursor: default;
    }
</style>


<%-- 공통 레이아웃의 메인 콘텐츠 영역 (예시) --%>
<main class="main-content">
    <%-- 이 페이지의 모든 콘텐츠를 감싸는 고유한 컨테이너 클래스 추가 --%>
    <div class="admin-point-container">
        <h1>고객 포인트 전체 내역</h1>

        <div class="search-form">
            <%-- [수정] URL 경로를 하이픈(-)이 없는 이전 버전으로 되돌렸습니다. --%>
            <%-- 컨트롤러가 @GetMapping("/admin/pointHistory") 라면 이 코드를, --%>
            <%-- @GetMapping("/admin/point-history") 라면 이전 답변의 코드를 사용하세요. --%>
            <form action="<c:url value='/admin/pointHistory'/>" method="get">
                <select name="searchType">
                    <option value="member_id" ${pageMaker.cri.searchType == 'member_id' ? 'selected' : ''}>회원 아이디</option>
                    <option value="change_reason" ${pageMaker.cri.searchType == 'change_reason' ? 'selected' : ''}>변경 사유</option>
                    <option value="point_status" ${pageMaker.cri.searchType == 'point_status' ? 'selected' : ''}>상태</option>
                </select>
                <input type="text" name="keyword" value="${pageMaker.cri.keyword}" placeholder="검색어를 입력하세요">
                <input type="submit" value="검색">
            </form>
        </div>

        <table>
            <thead>
                <tr>
                    <th class="${pageMaker.cri.sortColumn == 'point_id' ? pageMaker.cri.sortOrder : ''}">
                        <a href="<c:url value='/admin/pointHistory${pageMaker.cri.sortUrl("point_id")}' />">내역번호</a>
                    </th>
                    <th class="${pageMaker.cri.sortColumn == 'member_id' ? pageMaker.cri.sortOrder : ''}">
                        <a href="<c:url value='/admin/pointHistory${pageMaker.cri.sortUrl("member_id")}' />">회원 아이디</a>
                    </th>
                    <th class="${pageMaker.cri.sortColumn == 'change_date' ? pageMaker.cri.sortOrder : ''}">
                        <a href="<c:url value='/admin/pointHistory${pageMaker.cri.sortUrl("change_date")}' />">변경일시</a>
                    </th>
                    <th>변경 사유</th>
                    <th>변경 포인트</th>
                    <th>적용 후 포인트</th>
                    <th>상태</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty historyList}">
                        <c:forEach var="history" items="${historyList}">
                            <tr>
                                <td>${history.point_id}</td>
                                <td>${history.member_id}</td>
                                <td><fmt:formatDate value="${history.change_date}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                                <td>${history.change_reason}</td>
                                <td><fmt:formatNumber value="${history.change_amount}" pattern="+ #,##0;- #,##0"/></td>
                                <td><fmt:formatNumber value="${history.point_amount}" pattern="#,###"/> P</td>
                                <td>${history.point_status}</td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="7" class="no-records">포인트 내역이 없습니다.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>

        <div class="pagination">
            <c:if test="${pageMaker.prev}">
                <a href="<c:url value='/admin/pointHistory${pageMaker.cri.pageUrl(pageMaker.startPage - 1)}'/>">&laquo;</a>
            </c:if>

            <c:forEach begin="${pageMaker.startPage}" end="${pageMaker.endPage}" var="pageNum">
                <a href="<c:url value='/admin/pointHistory${pageMaker.cri.pageUrl(pageNum)}'/>" class="${pageMaker.cri.page == pageNum ? 'active' : ''}">${pageNum}</a>
            </c:forEach>

            <c:if test="${pageMaker.next}">
                <a href="<c:url value='/admin/pointHistory${pageMaker.cri.pageUrl(pageMaker.endPage + 1)}'/>">&raquo;</a>
            </c:if>
        </div>
    </div> <%-- /.admin-point-container --%>
</main> <%-- /.main-content --%>

<%-- 4. 하단 푸터를 불러옵니다. --%>
<%@ include file="include/footer.jsp" %> 