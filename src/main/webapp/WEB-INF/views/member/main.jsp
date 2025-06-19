<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 1. 페이지 기본 골격과 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>

<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/header.jsp" %> 

<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>

<%-- 4. 여기서부터 '로그인 메인' 페이지만의 고유한 컨텐츠가 시작됩니다. --%>
	<h1>/member/main.jsp</h1>

	<!-- 사용자가 로그인 정보없이 메인페이지 호출시
	     로그인페이지로 이동후 처리 
	 -->
	 
	 <c:if test="${ empty sessionScope.id }">
	 	 <c:redirect url="/member/login"/>
	 </c:if>
	 
		
	<!-- 로그인한 사용자의 아이디 정보를 출력 -->
	<h2>${sessionScope.id }님 환영합니다</h2>
	
	<input type="button" value="로그아웃" 
	 	onclick=" location.href='/member/logout'; " >
	 	
	
	<hr>
	<a href="/member/info"> 회원정보 조회(마이페이지) </a>
	
	<hr>
	<a href="/member/update"> 회원정보 수정 </a>
	
	 	
	
	
	
	
<%-- '로그인 메인' 페이지 컨텐츠 끝 --%>

<%-- 5. 페이지의 끝을 마무리하는 footer 파일을 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>