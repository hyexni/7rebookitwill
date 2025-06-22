<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>
<%@ include file="/WEB-INF/views/include/header.jsp" %>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>

<div class="container" style="max-width: 500px; margin: 50px auto; text-align: center;">
  <h2>🔐 비밀번호 찾기 결과</h2>

  <c:choose>
    <c:when test="${not empty resultPw}">
      <p style="margin-top: 30px; font-size: 18px;">
        <strong>회원님의 비밀번호는</strong><br><br>
        <span style="font-size: 22px; color: #dc3545;">${resultPw}</span><br><br>입니다.
      </p>
      <a href="${pageContext.request.contextPath}/member/login" class="btn btn-success" style="margin-top: 20px;">로그인하러 가기</a>
    </c:when>

    <c:otherwise>
      <p style="margin-top: 30px; color: red;">일치하는 회원 정보가 없습니다.</p>
      <a href="${pageContext.request.contextPath}/member/findPw" class="btn btn-secondary" style="margin-top: 20px;">다시 시도하기</a>
    </c:otherwise>
  </c:choose>
</div>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>
