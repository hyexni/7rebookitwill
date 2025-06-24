<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main.css">
<%@ include file="/WEB-INF/views/include/header.jsp" %> 
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>
<%@ include file="/WEB-INF/views/include/alert.jsp" %> 

<div class="login-container">
  <h2>로그인</h2>

  <form action="${pageContext.request.contextPath}/member/login" method="post">
    <label for="member_id">아이디:</label>
    <input type="text" id="member_id" name="member_id" required />

    <label for="member_pw">비밀번호:</label>
    <input type="password" id="member_pw" name="member_pw" required />

    <!-- 로그인 실패 메시지 -->
    <c:if test="${not empty message}">
      <p class="login-error">${message}</p>
    </c:if>

    <button type="submit">로그인</button>
  </form>

  <!-- ✅ 링크 정리 -->
  <div class="login-links">
    <a href="${pageContext.request.contextPath}/member/findId">아이디 찾기</a> |
    <a href="${pageContext.request.contextPath}/member/findPw">비밀번호 찾기</a> |
    <a href="${pageContext.request.contextPath}/member/join">회원가입</a>
  </div>
</div>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>
