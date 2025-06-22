<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> <%-- JSTL functions 라이브러리 추가 --%>

<%-- 1. 페이지 기본 골격과 공통 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>

<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/header.jsp" %>

<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>

<h2>📢 공지사항</h2>
<table class="notice-table">
  <thead>
    <tr>
      <th>번호</th>
      <th>제목</th>
      <th>등록일</th>
    </tr>
  </thead>
  <tbody>
    <c:forEach var="vo" items="${noticeList}">
      <tr>
        <td>${vo.notice_id}</td>
        <td>
          <a href="read?notice_id=${vo.notice_id}">
            ${vo.notice_title}
          </a>
        </td>
        <td><fmt:formatDate value="${vo.notice_date}" pattern="yyyy-MM-dd" /></td>
      </tr>
    </c:forEach>
  </tbody>
</table>

<%-- 4. 하단 푸터를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
