<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 1. 페이지 기본 골격과 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>

<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/header.jsp" %> 

<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>
<%@ include file="/WEB-INF/views/include/alert.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/jw.css">

<%-- 4. 여기서부터 '1:1 문의 목록' 페이지만의 고유한 컨텐츠가 시작됩니다. --%>

<main class="main-content" id="cs-list">
  <div class="jw-container">
    <h1>📋 나의 1:1 문의 내역</h1>
    
    <!-- 새글 등록 버튼 -->
	<div style="display: flex; justify-content: flex-end; margin-bottom: 20px;">
	  <a href="/cs/write" class="btn-jw-new">새글 등록</a>
	</div>


	  <div class="table-wrapper">
	    <table class="styled-table">
	      <thead>
	        <tr>
	          <th>번호</th>
	          <th>분류</th>
	          <th>제목</th>
	          <th>작성일</th>
	          <th>상태</th>
	        </tr>
	      </thead>
	      <tbody>
	        <c:forEach var="inquiry" items="${inquiryList}">
	          <tr class="clickable-row" data-id="${inquiry.inquiry_id}">
	            <td>${inquiry.inquiry_id}</td>
	            <td>${inquiry.category}</td>
	            <td>${inquiry.title}</td>
	            <td><fmt:formatDate value="${inquiry.created_at}" pattern="yyyy-MM-dd" /></td>
	            <td><span class="status received">${inquiry.status}</span></td>
	          </tr>
	        </c:forEach>
	      </tbody>
	    </table>
	  </div>
    </div>
</main>


	<script>
	  // 문서가 로드되면 실행
	  document.addEventListener("DOMContentLoaded", function () {
	    const rows = document.querySelectorAll(".clickable-row");
	    rows.forEach(row => {
	      row.addEventListener("click", function () {
	        const id = this.dataset.id;
	        if (id) {
	          window.location.href = "/cs/read?inquiry_id=" + id;
	        }
	      });
	    });
	  });
	</script>





<%-- '1:1 문의 목록' 페이지 컨텐츠 끝 --%>

<%-- 5. 페이지의 끝을 마무리하는 footer 파일을 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>