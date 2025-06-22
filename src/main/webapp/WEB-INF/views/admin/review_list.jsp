<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<%-- 1. 페이지 기본 골격과 공통 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="include/layout_head.jsp" %>

<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@ include file="include/header.jsp" %> 

<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@ include file="include/sidebar.jsp" %>  

<!-- ✅ 공통 CSS -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/custom.css">

<div class="container">
  <h2 class="admin-title">리뷰 관리</h2>

  <!-- 🔍 검색창 -->
  <form method="get" action="${pageContext.request.contextPath}/admin/review_list" class="search-form">
    <input type="text" name="keyword" value="${param.keyword}" placeholder="도서명, 리뷰내용, 회원ID/이름 검색" />
    <button type="submit">검색</button>
  </form>

  <!-- 📋 테이블 -->
  <table class="admin-table">
    <thead>
      <tr>
        <th>리뷰ID</th>
        <th>도서명</th>
        <th>회원ID</th>
        <th>작성자</th>
        <th>작성일</th>
        <th>평점</th>
        <th>상태</th>
        <th>요약</th>
        <th>상세보기</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="review" items="${reviewList}">
        <tr>
          <td>${review.review_id}</td>
          <td>${review.book_title}</td>
          <td>${review.member_id}</td>
          <td>${review.member_name}</td>
          <td><fmt:formatDate value="${review.review_date}" pattern="yyyy-MM-dd" /></td>
          <td>${review.review_score}</td>
          <td>${review.review_status}</td>
          <td>${fn:substring(review.review_text, 0, 20)}...</td>
          <td><a href="${pageContext.request.contextPath}/admin/review_view?review_id=${review.review_id}">보기</a></td>
        </tr>
      </c:forEach>
      <c:if test="${empty reviewList}">
        <tr>
          <td colspan="9">조회된 리뷰가 없습니다.</td>
        </tr>
      </c:if>
    </tbody>
  </table>

  <!-- 📌 페이징 -->
  <div class="pagination">
    <c:if test="${currentPage > 1}">
      <a href="?page=${currentPage - 1}&keyword=${param.keyword}">&laquo; 이전</a>
    </c:if>
    <span>${currentPage}</span>
    <c:if test="${reviewList.size() == 10}">
      <a href="?page=${currentPage + 1}&keyword=${param.keyword}">다음 &raquo;</a>
    </c:if>
  </div>
</div>


<%-- 4. 하단 푸터를 불러옵니다. --%>
<%@ include file="include/footer.jsp" %> 