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
	          <td>
				  <c:choose>
				    <c:when test="${review.review_status eq 'Y'}">
				      <span class="badge badge-green">정상</span>
				    </c:when>
				    <c:when test="${review.review_status eq 'N'}">
				      <span class="badge badge-yellow">숨김</span>
				    </c:when>
				    <c:otherwise>
				      <span class="badge">-</span>
				    </c:otherwise>
				  </c:choose>
			  </td>
	          <td>${fn:substring(review.review_text, 0, 20)}...</td>
	          <td>
			   <button class="btn-modern openModalBtn"
			           data-id="${review.review_id}"
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
		<!-- 페이지네이션 버튼 -->
		<div class="pagination">
		  <a href="${pageContext.request.contextPath}/admin/review_list?page=${currentPage - 1}"
		     class="${currentPage == 1 ? 'disabled' : ''}">&laquo;</a>
		
		  <c:forEach var="i" begin="1" end="${totalPages}">
		    <a href="${pageContext.request.contextPath}/admin/review_list?page=${i}"
		       class="${i == currentPage ? 'active' : ''}">
		      ${i}
		    </a>
		  </c:forEach>
		
		  <a href="${pageContext.request.contextPath}/admin/review_list?page=${currentPage + 1}"
		     class="${currentPage == totalPages ? 'disabled' : ''}">&raquo;</a>
		</div>
	
	<form id="reviewActionForm" method="post">
 		 <input type="hidden" name="review_id" id="modalReviewId">
 		 <input type="hidden" name="reason" id="modalReasonHidden">
	</form>
	<c:if test="${not empty msg}">
  <script>alert('${msg}');</script>
</c:if>
	
	
	<!-- ✅ 상세보기 모달 -->
	<div id="reviewModal" class="modal" style="display:none;">
	  <div class="modal-content">
	    <span class="close">&times;</span>
	    <h3>리뷰 상세 내용</h3>
	
	    <!-- 숨겨진 리뷰 ID -->
	    <input type="hidden" id="modalReviewId">
	
	    <p><strong>도서명:</strong> <span id="modalBookTitle"></span></p>
	    <p><strong>작성자:</strong> <span id="modalWriter"></span></p>
	    <p><strong>작성일:</strong> <span id="modalDate"></span></p>
	    <p><strong>평점:</strong> <span id="modalScore"></span></p>
	    <p><strong>내용:</strong> <span id="modalText"></span></p>
	
	    <div class="modal-reason-box">
	      <label>사유 입력:</label><br>
	      <textarea id="modalReason" rows="3" style="width:100%;"></textarea>
	    </div>
	
	    <div class="modal-buttons" style="margin-top: 15px; text-align: right;">
	      <button id="hideBtn" class="btn-outline-primary">숨김</button>
	      <button id="deleteBtn" class="btn-outline-danger">삭제</button>
	    </div>
	  </div>
	</div>
	
	<script>
	  const ctx = '${pageContext.request.contextPath}';
	
	  // 상세보기 모달 열기
	  document.querySelectorAll('.openModalBtn').forEach(btn => {
	    btn.addEventListener('click', function () {
	      document.getElementById('modalBookTitle').textContent = this.dataset.book;
	      document.getElementById('modalWriter').textContent = this.dataset.writer;
	      document.getElementById('modalDate').textContent = this.dataset.date;
	      document.getElementById('modalScore').textContent = this.dataset.score;
	      document.getElementById('modalText').textContent = this.dataset.text;
	      document.getElementById('modalReviewId').value = this.dataset.id;
	      document.getElementById('modalReason').value = ''; // 초기화
	
	      document.getElementById('reviewModal').style.display = 'block';
	    });
	  });
	
	  // 모달 외부 클릭 시 닫기
	  window.addEventListener('click', e => {
	    const modal = document.getElementById('reviewModal');
	    if (e.target == modal) modal.style.display = 'none';
	  });
	
	  // X 버튼 클릭 시 닫기
	  document.querySelector('.modal .close').addEventListener('click', () => {
	    document.getElementById('reviewModal').style.display = 'none';
	  });
	
	  // 숨김 / 삭제 처리
	  function handleReviewAction(type) {
	    const reviewId = document.getElementById('modalReviewId').value;
	    const reason = document.getElementById('modalReason').value.trim();
	
	    if (!reason) return alert('사유를 입력해주세요.');
	    if (type == 'delete' && !confirm('정말 삭제하시겠습니까?')) return;
	
	    fetch(`${ctx}/admin/review_${type}`, {
	      method: 'POST',
	      headers: { 'Content-Type': 'application/json' },
	      body: JSON.stringify({ review_id: reviewId, reason })
	    })
	    .then(res => res.text())
	    .then(msg => {
	      if (msg == 'success') {
	        alert(`리뷰가 ${type == 'hide' ? '숨김 처리' : '삭제'}되었습니다.`);
	        location.reload();
	      } else {
	        alert('처리 실패');
	      }
	    });
	  }
	
	  // 버튼 연결
	  document.getElementById('hideBtn').addEventListener('click', () => handleReviewAction('hide'));
	  document.getElementById('deleteBtn').addEventListener('click', () => handleReviewAction('delete'));
	</script>


	
	

<%@ include file="include/footer.jsp" %>
