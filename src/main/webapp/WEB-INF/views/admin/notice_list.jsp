<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 1. 페이지 기본 골격과 공통 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="include/layout_head.jsp" %>

<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@ include file="include/header.jsp" %> 

<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@ include file="include/sidebar.jsp" %>  
<%@ include file="/WEB-INF/views/include/alert.jsp" %>

<main class="main-content" id="notice-list">
	<div class="admin-container" >
	<!-- 페이지 제목 -->
	<h1>📢 공지사항 관리</h1>
	
	<!-- 공지사항 테이블 -->
	<table>
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
	      	<tr class="row-link"
		        data-href="${pageContext.request.contextPath}/admin/notice/read?notice_id=${notice.notice_id}"
		        style="text-align: center; border-bottom: 1px solid #dee2e6;">
	        <td style="padding: 6px 8px;">${notice.notice_id}</td>
	        
	        <td style="padding: 6px 8px;">
			  <c:if test="${notice.fixed eq 'Y'}">
			    <span style="font-size: 16px;">📌</span>
			  </c:if>
			    ${notice.notice_title}
			</td>
			
	        <td style="padding: 6px 8px;">
	          <fmt:formatDate value="${notice.notice_date}" pattern="yyyy-MM-dd"/>
	        </td>
	        <td style="padding: 6px 8px;">
	          <form action="${pageContext.request.contextPath}/admin/notice/edit" method="get" style="display:inline;">
	            <input type="hidden" name="notice_id" value="${notice.notice_id}" />
	            <button type="submit" class="btn btn-outline-primary">수정</button>
	          </form>
	          <form action="${pageContext.request.contextPath}/admin/notice/delete" method="post" style="display:inline;">
	            <input type="hidden" name="notice_id" value="${notice.notice_id}" />
	            <button type="submit" class="btn btn-outline-danger" onclick="return confirm('삭제하시겠습니까?')">삭제</button>
	          </form>
	        </td>
	      </tr>
	    </c:forEach>
	  </tbody>
	</table>
	</div>
	
	<!-- 새 글 등록 버튼 -->
	<div style="margin-top: 20px; margin-right: 115px; text-align: right;">
	  <a href="${pageContext.request.contextPath}/admin/notice_write">
	    <button type="submit" class="btn btn-primary">+새글 등록</button>
	  </a>
	</div>

	
	<!-- 페이징 -->
	<!-- 페이지네이션 버튼 -->
	<div class="pagination">
	  <a href="${pageContext.request.contextPath}/admin/notice_list?page=${currentPage - 1}#notice-list"
	     class="${currentPage == 1 ? 'disabled' : ''}">&laquo;</a>
	
	  <c:forEach var="i" begin="1" end="${totalPages}">
	    <a href="${pageContext.request.contextPath}/admin/notice_list?page=${i}#notice-list"
	       class="${i == currentPage ? 'active' : ''}">
	      ${i}
	    </a>
	  </c:forEach>
	
	  <a href="${pageContext.request.contextPath}/admin/notice_list?page=${currentPage + 1}#notice-list"
	     class="${currentPage == totalPages ? 'disabled' : ''}">&raquo;</a>
	</div>
</main>
	
	<script>
		document.addEventListener('DOMContentLoaded', function () {
		  // 모든 .row-link tr 에 대해
		  document.querySelectorAll('.row-link').forEach(function (row) {
		    row.addEventListener('click', function () {
		      const url = this.getAttribute('data-href');
		      if (url) location.href = url;
		    });
		  });
		});
	</script>
	


<%-- 4. 하단 푸터를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>