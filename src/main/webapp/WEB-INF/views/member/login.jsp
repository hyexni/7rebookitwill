<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 1. 페이지 기본 골격과 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>

<!-- ✅ 로그인 CSS 직접 추가 (layout_head 못 건드릴 경우) -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main.css">

<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/header.jsp" %> 

<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>


<div class="login-container">
  <h2>로그인</h2>

   <form action="${pageContext.request.contextPath}/member/login" method="post">
    <label for="member_id">아이디:</label>
    <input type="text" id="member_id" name="member_id" required />

    <label for="member_pw">비밀번호:</label>
    <input type="password" id="member_pw" name="member_pw" required />

    <!-- 로그인 실패 메시지 출력 -->
    <c:if test="${not empty message}">
	  <p class="login-error">${message}</p>
	</c:if>

    <button type="submit">로그인</button>
  </form>

  <div class="login-links">
    <a href="${pageContext.request.contextPath}/member/findId">아이디 찾기</a> |
    <a href="${pageContext.request.contextPath}/member/findPw">비밀번호 찾기</a> |
    <a href="${pageContext.request.contextPath}/member/join">회원가입</a>
  </div>
</div>


<%-- 5. 페이지의 끝을 마무리하는 footer 파일을 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>