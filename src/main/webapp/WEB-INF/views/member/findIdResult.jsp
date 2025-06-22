<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 1. 페이지 기본 골격과 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>

<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/header.jsp" %> 

<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>

<div class="container" style="max-width: 500px; margin: 50px auto; text-align: center;">
  <h2>🔐 아이디 찾기 결과</h2>

  <c:choose>
    <c:when test="${not empty resultId}">
      <p style="margin-top: 30px; font-size: 18px;">
        <strong>회원님의 아이디는</strong><br><br>
        <span style="font-size: 22px; color: #007bff;">${resultId}</span>
        <br><br>입니다.
      </p>
      
        <!-- ✅ 버튼 묶음: 로그인 / 비번 찾기 -->
  <div style="margin-top: 20px;">
    <a href="${pageContext.request.contextPath}/member/login" class="btn btn-success" style="margin-right: 10px;">로그인하러 가기</a>
    <a href="${pageContext.request.contextPath}/member/findPw" class="btn btn-outline-secondary">비밀번호 찾기</a>
  </div>
	</c:when>


    <c:otherwise>
      <p style="margin-top: 30px; color: red;">일치하는 회원 정보가 없습니다.</p>
      <a href="${pageContext.request.contextPath}/member/findId" class="btn btn-secondary" style="margin-top: 20px;">다시 시도하기</a>
    </c:otherwise>
  </c:choose>
</div>

<jsp:include page="/WEB-INF/views/include/footer.jsp" />