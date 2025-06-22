<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 1. 페이지 기본 골격과 공통 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="include/layout_head.jsp" %>

<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@ include file="include/header.jsp" %> 

<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@ include file="include/sidebar.jsp" %> 


	
	<!-- 공통 CSS 불러오기 -->
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/custom.css">
	
<div class="container">
  <h2>회원 관리</h2>

  <!-- 🔍 검색 & 정렬 -->
  <form action="${pageContext.request.contextPath}/admin/member_list" method="get" class="search-form">
    <input type="text" name="keyword" placeholder="아이디, 이름, 이메일 검색" value="${keyword}"/>
    <select name="sort" onchange="this.form.submit()">
      <option value="regdate" ${sort == 'regdate' ? 'selected' : ''}>가입일순</option>
      <option value="name" ${sort == 'name' ? 'selected' : ''}>이름순</option>
    </select>
    <button type="submit">검색</button>
  </form>

  <!-- 📋 회원 목록 테이블 -->
  <table class="admin-table">
    <thead>
      <tr>
        <th>번호</th>
        <th>회원 ID</th>
        <th>상태</th>
        <th>닉네임</th>
        <th>이름</th>
        <th>전화번호</th>
        <th>이메일</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="member" items="${memberList}" varStatus="loop">
        <tr>
          <td>${member.member_idx}</td>
          <td>${member.member_id}</td>
          <td class="${member.member_status == 'Y' ? 'status-active' : 'status-deleted'}">
          	<c:choose><c:when test="${member.member_status == 'Y'}">활성</c:when>
          	<c:otherwise>탈퇴</c:otherwise></c:choose>
          </td>
          <td>${member.member_nick}</td>
          <td>${member.member_name}</td>
          <td>${member.member_phone}</td>
          <td>${member.member_email}</td>
        </tr>
      </c:forEach>
    </tbody>
  </table>

  <!-- 📄 페이징 -->
  <div class="pagination">
    <c:forEach var="i" begin="1" end="${totalPages}">
      <c:url var="pageUrl" value="/admin/member_list">
        <c:param name="page" value="${i}"/>
        <c:if test="${not empty keyword}"><c:param name="keyword" value="${keyword}"/></c:if>
        <c:if test="${not empty sort}"><c:param name="sort" value="${sort}"/></c:if>
      </c:url>
      <a href="${pageUrl}" class="${i == currentPage ? 'active' : ''}">${i}</a>
    </c:forEach>
  </div>
</div>








<%-- 4. 하단 푸터를 불러옵니다. --%>
<%@ include file="include/footer.jsp" %> 