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

<h2 style="text-align:center; margin: 40px 0 30px;">📢 공지사항</h2>

<table style="width: 100%; border-collapse: collapse; font-size: 15px;">
  <thead style="background-color: #f8f9fa;">
    <tr>
      <th style="padding: 12px;">번호</th>
      <th style="padding: 12px;">제목</th>
      <th style="padding: 12px;">등록일</th>
    </tr>
  </thead>
  <tbody>
    <c:forEach var="vo" items="${noticeList}">
      <tr style="text-align: center; border-bottom: 1px solid #dee2e6;">
        <td style="padding: 12px;">${vo.notice_id}</td>
        <td style="padding: 12px;">
          <c:if test="${vo.fixed}">
		    <span style="color: red; font-weight: bold;">[공지]</span>
		  </c:if>	
          <a href="read?notice_id=${vo.notice_id}"
          	 style="font-size: 15px; font-weight: 500; color: #333; text-decoration: none;">
            ${vo.notice_title}
          </a>
        </td>
        <td style="padding: 12px;">
          <fmt:formatDate value="${vo.notice_date}" pattern="yyyy-MM-dd" />
        </td>
      </tr>
    </c:forEach>
  </tbody>
</table>

   <!-- 페이지네이션 버튼 -->
	<div class="pagination">
	  <!-- << 이전 페이지 -->
	  <a href="${pageContext.request.contextPath}/notice/list?page=${currentPage - 1}"
	     <c:if test="${currentPage == 1}">class="disabled"</c:if>>&laquo;</a>
	
	  <!-- 페이지 번호 -->
	  <c:forEach var="i" begin="1" end="${totalPages}">
	    <a href="${pageContext.request.contextPath}/notice/list?page=${i}"
	       <c:if test="${i == currentPage}">class="active"</c:if>>${i}</a>
	  </c:forEach>
	
	  <!-- >> 다음 페이지 -->
	  <a href="${pageContext.request.contextPath}/notice/list?page=${currentPage + 1}"
	     <c:if test="${currentPage == totalPages}">class="disabled"</c:if>>&raquo;</a>
	</div>

<style>
/* Table */
table {
    width: 100%;
    border-collapse: collapse;
    font-size: 15px;
}
thead {
    background-color: #f8f9fa;
}
th, td {
    padding: 14px 10px;
    text-align: center;
    border-bottom: 1px solid #dee2e6;
}
th {
    color: #495057;
    font-weight: 500;
    vertical-align: middle;
}
tbody tr:hover {
    background-color: #f1f3f5;
}
</style>	

<%-- 4. 하단 푸터를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
