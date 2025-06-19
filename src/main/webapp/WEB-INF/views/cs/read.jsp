<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 1. 페이지 기본 골격과 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>

<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/header.jsp" %> 

<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>

<%-- 4. 여기서부터 '문의 상세조회' 페이지만의 고유한 컨텐츠가 시작됩니다. --%>


	<div class="content">
		<h1> /cs/read.jsp </h1>
		
			<h2>문의 상세</h2>
			
			<p><strong>번호:</strong> ${vo.inquiry_id}</p>
			<p><strong>분류:</strong> ${vo.category}</p>
			<p><strong>제목:</strong> ${vo.title}</p>
			<p><strong>내용:</strong> ${vo.content}</p>
			<p><strong>작성일:</strong> ${vo.created_at}</p>
			<p><strong>상태:</strong> ${vo.status}</p>
			
			<a href="/cs/list">← 목록으로</a>
	</div>


<%-- '문의 상세조회' 페이지 컨텐츠 끝 --%>

<%-- 5. 페이지의 끝을 마무리하는 footer 파일을 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>