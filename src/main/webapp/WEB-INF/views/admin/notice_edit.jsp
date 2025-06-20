<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 1. 페이지 기본 골격과 공통 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>

<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/admin/include/header.jsp" %>

<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/admin/include/sidebar.jsp" %>



	<h2>공지사항 수정</h2>
	
	<form action="${pageContext.request.contextPath}/admin/edit" method="post">
	  <input type="hidden" name="notice_id" value="${notice.notice_id}" />
	  <p>제목: <input type="text" name="notice_title" value="${notice.notice_title}" /></p>
	  <p>내용: <textarea name="notice_content" rows="5" cols="60">${notice.notice_content}</textarea></p>
	  <button type="submit">수정 완료</button>
	</form>


<%-- 4. 하단 푸터를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/admin/include/footer.jsp" %>