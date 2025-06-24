<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main.css">

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>
<%@ include file="/WEB-INF/views/include/header.jsp" %>

<div class="main-wrapper">
  <%@ include file="/WEB-INF/views/include/sidebar.jsp" %>

  <!-- 🧾 회원 기본정보 박스 -->
  <div class="mypage-container">
    <h2 class="section-title">👤 회원 기본정보</h2>

    <div class="info-card">
      <div class="info-row"><span class="info-label">이름</span><span class="info-value">${memberVO.member_name}</span></div>
      <div class="info-row"><span class="info-label">아이디</span><span class="info-value">${memberVO.member_id}</span></div>
      <div class="info-row"><span class="info-label">닉네임</span><span class="info-value">${memberVO.member_nick}</span></div>
      <div class="info-row"><span class="info-label">이메일</span><span class="info-value">${memberVO.member_email}</span></div>
      <div class="info-row"><span class="info-label">휴대폰 번호</span><span class="info-value">${memberVO.member_phone}</span></div>
      <div class="info-row"><span class="info-label">주소</span><span class="info-value">${memberVO.member_address} ${memberVO.member_address_detail}</span></div>
      <div class="info-row">
        <span class="info-label">관심 카테고리</span>
        <span class="info-value">
         	<c:forEach var="category" items="${categoryList}">
		  <span class="category-badge">${category.category_name_ko}</span>
		</c:forEach>
        </span>
      </div>
      <div class="info-row"><span class="info-label">가입일</span><span class="info-value"><fmt:formatDate value="${memberVO.member_regdate}" pattern="yyyy-MM-dd HH:mm" /></span></div>
      <div class="info-row"><span class="info-label">최근 수정일</span><span class="info-value"><fmt:formatDate value="${memberVO.member_update_date}" pattern="yyyy-MM-dd HH:mm" /></span></div>
    </div>

    <div class="btn-box">
      <a href="/member/update" class="btn btn-yellow">회원정보 수정하기</a>
    </div>
  </div>
</div>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>
