<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 1. 공통 레이아웃 구성 요소 불러오기 --%>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>  <%-- CSS/폰트 등 --%>
<%@ include file="/WEB-INF/views/include/header.jsp" %>       <%-- 상단 헤더 --%>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>      <%-- 왼쪽 사이드 메뉴 --%>

	<%-- 2. 메인 페이지 컨텐츠 시작 --%>
	<h1>/member/main.jsp</h1>
	
	<%-- 로그인 안 한 사용자는 로그인 페이지로 리다이렉트 시킴 --%>
	<c:if test="${empty sessionScope.id}">
	  <c:redirect url="/member/login" />
	</c:if>
	
	<%-- 로그인/회원정보 수정 메시지 출력 (FlashAttribute) --%>
	<c:if test="${not empty message}">
	  <div style="padding: 10px; background-color: #e0ffe0; border: 1px solid #00c853; color: #2e7d32; font-weight: bold; margin-bottom: 15px;">
	    ✅ ${message}
	  </div>
	</c:if>
	
	<c:if test="${not empty msg}">
	  <div style="padding: 10px; background-color: #e0ffe0; border: 1px solid #00c853; color: #2e7d32; font-weight: bold; margin-bottom: 15px;">
	    ✅ ${msg}
	  </div>
	</c:if>
		
	<%--  로그인한 사용자 정보 출력 --%>
	<h2>${sessionScope.id}님, 환영합니다!</h2>
	
	<%--  로그아웃 버튼 --%>
	<input type="button" value="로그아웃"
	       onclick="location.href='/member/logout';"
	       style="margin: 10px 0;" />
	
	<hr>
	
	<%-- 회원정보 조회 페이지 이동 --%>
	<a href="/member/info">🔎 회원정보 조회 (마이페이지)</a>
	
	<hr>
	
	<%-- 회원정보 수정 페이지 이동 --%>
	<a href="/member/update">✏️ 회원정보 수정</a>
	
	<%-- 3. 공통 푸터 불러오기 --%>
	<%@ include file="/WEB-INF/views/include/footer.jsp" %>
