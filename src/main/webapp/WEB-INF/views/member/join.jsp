<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>
<%@ include file="/WEB-INF/views/include/header.jsp" %>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/custom.css">

<div class="container" style="max-width: 700px; margin: 50px auto;">
  <h2 class="mb-5">1:1 문의 작성</h2>

  <form id="inquiryForm" action="${pageContext.request.contextPath}/cs/write" method="post" onsubmit="return validateInquiry();">

    <label for="category">분류:</label>
    <select name="category" id="category" class="form-control" required>
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

    <label for="title">제목:</label>
    <input type="text" id="title" name="title" class="form-control" placeholder="제목을 입력하세요!" required>

    <label for="content">내용:</label>
    <textarea id="content" name="content" class="form-control" rows="6" placeholder="내용을 입력하세요!" required></textarea>

    <div class="d-flex gap-2 mt-4">
      <button type="submit" class="btn btn-primary">문의 접수</button>
      <a href="${pageContext.request.contextPath}/cs/list" class="btn btn-outline-secondary">과거 1:1문의 확인</a>
    </div>
  </form>
</div>

<script>
function validateInquiry() {
  const category = document.getElementById("category");
  const title = document.getElementById("title");
  const content = document.getElementById("content");

  if (!category.value) {
    alert("분류를 선택해주세요.");
    category.focus();
    return false;
  }
  if (!title.value.trim()) {
    alert("제목을 입력해주세요.");
    title.focus();
    return false;
  }
  if (!content.value.trim()) {
    alert("내용을 입력해주세요.");
    content.focus();
    return false;
  }
  return true;
}
</script>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>
