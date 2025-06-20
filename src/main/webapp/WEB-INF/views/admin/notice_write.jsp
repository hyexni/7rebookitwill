<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 1. 페이지 기본 골격과 공통 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>

<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/admin/include/header.jsp" %>

<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/admin/include/sidebar.jsp" %>

	<h2>공지사항 작성</h2>
	
	    <div class="content">
		<h1> /admin/notice_write.jsp </h1>
		
			<form action="${pageContext.request.contextPath}/admin/notice_write" method="post">
	
	  <div class="form-group">
	    <label for="title">제목</label>
	    <input class="form-control" id="title" name="notice_title" placeholder="제목을 입력하세요" required />
	  </div>
	
	  <div class="form-group">
	    <label for="content">내용</label>
	    <textarea class="form-control" id="content" name="notice_content" rows="8" placeholder="내용을 입력하세요" required></textarea>
	  </div>
	
	  <button type="submit" class="btn btn-primary">등록</button>
	</form>

	

<%-- 4. 하단 푸터를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/admin/include/footer.jsp" %>