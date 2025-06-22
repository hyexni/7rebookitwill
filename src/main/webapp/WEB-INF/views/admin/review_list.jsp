<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="include/layout_head.jsp" %>
<%@ include file="include/header.jsp" %> 
<%@ include file="include/sidebar.jsp" %>

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
          <td>
            <button class="openModalBtn"
                    data-book="${review.book_title}"
                    data-writer="${review.member_name}"
                    data-date="<fmt:formatDate value='${review.review_date}' pattern='yyyy-MM-dd'/>"
                    data-score="${review.review_score}"
                    data-text="${review.review_text}">
              상세보기
            </button>
          </td>
        </tr>
      </c:forEach>
      <c:if test="${empty reviewList}">
        <tr><td colspan="9">조회된 리뷰가 없습니다.</td></tr>
      </c:if>
    </tbody>
  </table>

  <!-- 📌 페이징 -->
  <div class="pagination">
    <c:if test="${currentPage > 1}">
      <a href="?page=${currentPage - 1}&keyword=${param.keyword}">&laquo; 이전</a>
    </c:if>
    <span>${currentPage}</span>
    <c:if test="${reviewList.size() == pageSize}">
      <a href="?page=${currentPage + 1}&keyword=${param.keyword}">다음 &raquo;</a>
    </c:if>
  </div>
</div>

<!-- ✅ 상세보기 모달 -->
<div id="reviewModal" class="modal" style="display:none;">
  <div class="modal-content">
    <span class="close">&times;</span>
    <h3>리뷰 상세 내용</h3>
    <p><strong>도서명:</strong> <span id="modalBookTitle"></span></p>
    <p><strong>작성자:</strong> <span id="modalWriter"></span></p>
    <p><strong>작성일:</strong> <span id="modalDate"></span></p>
    <p><strong>평점:</strong> <span id="modalScore"></span></p>
    <p><strong>내용:</strong> <span id="modalText"></span></p>
  </div>
</div>

<style>
  .modal { position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.4); }
  .modal-content { background-color: #fff; margin: 10% auto; padding: 20px; width: 500px; border-radius: 8px; }
  .close { float: right; font-size: 24px; cursor: pointer; }
</style>

<script>
  document.querySelectorAll('.openModalBtn').forEach(btn => {
    btn.addEventListener('click', function () {
      document.getElementById('modalBookTitle').textContent = this.dataset.book;
      document.getElementById('modalWriter').textContent = this.dataset.writer;
      document.getElementById('modalDate').textContent = this.dataset.date;
      document.getElementById('modalScore').textContent = this.dataset.score;
      document.getElementById('modalText').textContent = this.dataset.text;
      document.getElementById('reviewModal').style.display = 'block';
    });
  });

  document.querySelector('.modal .close').addEventListener('click', () => {
    document.getElementById('reviewModal').style.display = 'none';
  });

  window.addEventListener('click', e => {
    const modal = document.getElementById('reviewModal');
    if (e.target === modal) modal.style.display = 'none';
  });
</script>

<%@ include file="include/footer.jsp" %>
