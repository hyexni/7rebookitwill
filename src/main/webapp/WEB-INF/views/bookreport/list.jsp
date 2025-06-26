<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 1. 페이지 기본 골격과 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>

<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/header.jsp" %> 

<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>

<%-- 4. 여기서부터 '1:1 문의 목록' 페이지만의 고유한 컨텐츠가 시작됩니다. --%>

<section class="mypage-inquiry-list">
  <div class="inquiry-header">
    <h2><i class="fa fa-clipboard-list"></i>📋 나의 독후감 리스트</h2>
    <a href="/bookreport/write" class="btn-write">새글 등록</a>
  </div>

  <div class="table-wrapper">
    <table class="styled-table">
        <thead class="table-dark">
            <tr>
                <th>글번호</th>
                <th>제목</th>
                <th>도서명</th>
                <th>저자</th>
                <th>작성일</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="report" items="${reportList}">
                <tr style="cursor:pointer;" onclick="location.href='/bookreport/read?report_id=${report.report_id}'">
                    <td>${report.report_id}</td>
                    <td><c:out value="${report.report_title}"/></td>
                    <td><c:out value="${report.rbook_title}"/></td>
                    <td><c:out value="${report.author_name}"/></td>
                    <td>
                        <fmt:formatDate value="${report.report_regdate}" pattern="yyyy-MM-dd"/>
                    </td>
                </tr>
            </c:forEach>
             <c:if test="${empty reportList}">
                <tr>
                    <td colspan="4">작성된 독후감이 없습니다.</td>
                </tr>
            </c:if>
        </tbody>
    </table>

    <div class="d-flex justify-content-end mt-3">
        <a href="/bookreport/write" class="btn btn-primary">독후감 쓰기</a>
    </div>
</div>

</body>
</html>