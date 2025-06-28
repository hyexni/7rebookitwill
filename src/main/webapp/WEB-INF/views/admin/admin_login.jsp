<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="include/layout_head.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main.css">
<%@ include file="include/header.jsp" %> 
<%@ include file="include/sidebar.jsp" %> 
<%@ include file="/WEB-INF/views/include/alert.jsp" %> 

<div class="login-container">
  <h2>관리자 로그인</h2>


  <!-- ✅ 로그인 안 된 상태에서 접근 시 알림 -->
  <c:if test="${param.needLogin == 'true'}">
  	<script>alert("로그인이 필요한 서비스입니다.");</script>
  </c:if>
  

  <form action="${pageContext.request.contextPath}/admin/login" method="post">
    <input type="text" name="ad_id" placeholder="ID" required><br>
    <input type="password" name="ad_pw" placeholder="비밀번호" required><br>
    <button type="submit">로그인</button>
  
    <!-- 로그인 실패 메시지 -->
    <c:if test="${not empty message}">
      <p class="login-error">${message}</p>
    </c:if>


  </form>

</div>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>