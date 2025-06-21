<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 1. 페이지 기본 골격과 공통 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="include/layout_head.jsp" %>

<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@ include file="include/header.jsp" %> 

<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@ include file="include/sidebar.jsp" %>  



<!-- 페이지 제목 -->
<h2 style="text-align:center; margin: 40px 0 30px;">📢 공지사항 관리</h2>

<!-- 공지사항 테이블 -->
<table style="width: 100%; border-collapse: collapse; font-size: 15px;">
  <thead style="background-color: #f8f9fa;">
    <tr>
      <th style="padding: 12px;">등록번호</th>
      <th style="padding: 12px;">제목</th>
      <th style="padding: 12px;">등록일자</th>
      <th style="padding: 12px;">수정 / 삭제</th>
    </tr>
  </thead>
  <tbody>
    <c:forEach var="notice" items="${noticeList}">
      <tr style="text-align: center; border-bottom: 1px solid #dee2e6;">
        <td style="padding: 12px;">${notice.notice_id}</td>
        <td style="padding: 12px;">
		  <c:if test="${notice.fixed}">
		    <span style="color: red; font-weight: bold;">[공지]</span>
		  </c:if>
		  <a href="${pageContext.request.contextPath}/admin/read?notice_id=${notice.notice_id}"
		     style="font-size: 15px; font-weight: 500; color: #333; text-decoration: none;">
		    ${notice.notice_title}
		  </a>
		</td>
        <td style="padding: 12px;">
          <fmt:formatDate value="${notice.notice_date}" pattern="yyyy-MM-dd"/>
        </td>
        <td style="padding: 12px;">
          <form action="${pageContext.request.contextPath}/admin/edit" method="get" style="display:inline;">
            <input type="hidden" name="notice_id" value="${notice.notice_id}" />
            <button type="submit" class="btn btn-outline-primary">수정</button>
          </form>
          <form action="${pageContext.request.contextPath}/admin/delete" method="post" style="display:inline;">
            <input type="hidden" name="notice_id" value="${notice.notice_id}" />
            <button type="submit" class="btn btn-outline-danger" onclick="return confirm('삭제하시겠습니까?')">삭제</button>
          </form>
        </td>
      </tr>
    </c:forEach>
  </tbody>
</table>

<!-- 새 글 등록 버튼 -->
<div style="text-align: right; margin-top: 20px;">
  <a href="${pageContext.request.contextPath}/admin/notice_write">
    <button class="btn btn-primary">+ 새 글 등록</button>
  </a>
</div>

<!-- 페이징 -->
<!-- 페이지네이션 버튼 -->
<div class="pagination">
  <a href="${pageContext.request.contextPath}/admin/notice_list?page=${currentPage - 1}"
     class="${currentPage == 1 ? 'disabled' : ''}">&laquo;</a>

  <c:forEach var="i" begin="1" end="${totalPages}">
    <a href="${pageContext.request.contextPath}/admin/notice_list?page=${i}"
       class="${i == currentPage ? 'active' : ''}">
      ${i}
    </a>
  </c:forEach>

  <a href="${pageContext.request.contextPath}/admin/notice_list?page=${currentPage + 1}"
     class="${currentPage == totalPages ? 'disabled' : ''}">&raquo;</a>
</div>


<%-- 4. 하단 푸터를 불러옵니다. --%>
<%@ include file="include/footer.jsp" %> 
