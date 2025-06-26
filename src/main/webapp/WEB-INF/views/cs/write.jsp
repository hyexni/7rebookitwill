<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 공통 레이아웃 --%>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>
<%@ include file="/WEB-INF/views/include/header.jsp" %>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>
<%@ include file="/WEB-INF/views/include/alert.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/custom.css">

<!-- 선택: 필수값 누락 시 테두리만 노란색으로 표시 -->
<style>
  input:required:invalid,
  textarea:required:invalid,
  select:required:invalid {
    border: 2px solid #f4c430;
  }
</style>

<div class="container" style="max-width:700px; margin:50px auto;">
  <h2 class="mb-5">1:1 문의 작성</h2>

  <!-- ✨ 브라우저 기본 validation(말풍선) 사용: onsubmit / novalidate X -->
  <form action="${pageContext.request.contextPath}/cs/write" method="post">

    <!-- ▣ 분류 -->
    <label for="category" class="form-label">분류:</label>
    <select name="category" id="category" class="form-control mb-4" required>
      <option value="" disabled selected hidden>분류를 선택하세요</option>
      <option value="회원정보/로그인">회원정보/로그인</option>
      <option value="주문/결제 문의">주문/결제 문의</option>
      <option value="배송 문의">배송 문의</option>
      <option value="도서 관련 문의">도서 관련 문의</option>
      <option value="리워드/포인트">리워드/포인트</option>
      <option value="영수증 인증 문의">영수증 인증 문의</option>
      <option value="이벤트/쿠폰">이벤트/쿠폰</option>
      <option value="서비스 제안">서비스 제안</option>
      <option value="기타">기타</option>
    </select>

    <!-- ▣ 제목 -->
    <label for="title" class="form-label">제목:</label>
    <input type="text" id="title" name="title" class="form-control mb-3" placeholder="제목을 입력하세요!" required>

    <!-- ▣ 내용 -->
    <label for="content" class="form-label">내용:</label>
    <textarea id="content" name="content" class="form-control mb-4" rows="6" placeholder="내용을 입력하세요!" required></textarea>

    <!-- ▣ 버튼 -->
    <div class="d-flex gap-2">
      <button type="submit" class="btn btn-primary flex-fill">문의 접수</button>
      <a href="${pageContext.request.contextPath}/cs/list" class="btn btn-outline-secondary">과거 1:1문의 확인</a>
    </div>
  </form>
</div>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>
