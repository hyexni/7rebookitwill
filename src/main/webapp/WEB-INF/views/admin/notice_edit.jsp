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

<main class="main-content">
	<div class="notice-form">
	  <div class="notice-meta">
	   공지사항 번호: ${notice.notice_id}
	  </div>
	
	  <h1>공지사항 수정</h1>
	
	  <form action="${pageContext.request.contextPath}/admin/edit" method="post">
	    <input type="hidden" name="notice_id" value="${notice.notice_id}" />
	
	    <div class="form-group">
	      <label for="title">제목</label>
	      <input type="text" id="title" name="notice_title" value="${notice.notice_title}" placeholder="제목을 입력하세요" required />
	    </div>
	
	    <div class="form-group">
	      <label for="content">내용</label>
	      <textarea id="content" name="notice_content" rows="8" placeholder="내용을 입력하세요" required>${notice.notice_content}</textarea>
	    </div>
	
	    <div class="form-group btn-wrapper">
	      <button type="submit" class="btn-primary">수정 완료</button>
	    </div>
	  </form>
	</div>
</main>


<%-- 4. 하단 푸터를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>