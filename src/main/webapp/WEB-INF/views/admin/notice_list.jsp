<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 1. 페이지 기본 골격과 공통 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="include/layout_head.jsp" %>

<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@ include file="include/header.jsp" %> 

<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@ include file="include/sidebar.jsp" %>  



<h2>공지사항 관리</h2>

<td>${notice.ad_id}</td>

<table border="1" width="100%" style="border-collapse: collapse; text-align: center;">
  <thead>
    <tr>
      <th>등록번호</th>
      <th>제목</th>
      <th>등록일자</th>
      <th>수정 / 삭제</th>
    </tr>
  </thead>
  <tbody>
    <c:forEach var="notice" items="${noticeList}">
      <tr>
        <td>${notice.notice_id}</td>
        <td>
          <c:if test="${notice.fixed}">
            <span style="color: red; font-weight: bold;">[공지]</span>
          </c:if>
          <a href="${pageContext.request.contextPath}/admin/read?notice_id=${notice.notice_id}">
            ${notice.notice_title}
          </a>
        </td>
        <td>${notice.notice_date}</td>
        <td>
          <form action="${pageContext.request.contextPath}/admin/edit" method="get" style="display:inline;">
            <input type="hidden" name="notice_id" value="${notice.notice_id}" />
            <button type="submit">수정</button>
          </form>
          <form action="${pageContext.request.contextPath}/admin/delete" method="post" style="display:inline;">
            <input type="hidden" name="notice_id" value="${notice.notice_id}" />
            <button type="submit" onclick="return confirm('삭제하시겠습니까?')">삭제</button>
          </form>
        </td>
      </tr>
    </c:forEach>
  </tbody>
</table>

<br/>
<div style="text-align: right;">
  <a href="${pageContext.request.contextPath}/admin/notice_write">
    <button>새 글 등록</button>
  </a>
</div>

<!-- 페이징 처리는 이후 구현 가능 -->
<p style="text-align: center; color: gray;">(10건 단위로 페이징 처리)</p>


<%-- 4. 하단 푸터를 불러옵니다. --%>
<%@ include file="include/footer.jsp" %> 
