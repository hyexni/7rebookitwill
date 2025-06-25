<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="include/layout_head.jsp" %>
<%@ include file="include/header.jsp" %> 
<%@ include file="include/sidebar.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/custom.css">
	<div class="admin-container">
	  <h1>💭 리뷰 관리</h1>
	
	  <!-- 🔍 검색창 -->
	  <form method="get" action="${pageContext.request.contextPath}/admin/review_list" class="search-form">
	    <input type="text" name="keyword" value="${param.keyword}" placeholder="도서명, 리뷰내용, 회원ID/이름 검색" />
	    <button type="submit">검색</button>
	  </form>
	
	  <!-- 📋 테이블 -->
	  <table>
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
        <c:when test="${review.review_status eq 'Y'}"><span class="badge badge-green">정상</span></c:when>
        <c:when test="${review.review_status eq 'N'}"><span class="badge badge-yellow">숨김</span></c:when>
        <c:otherwise><span class="badge">-</span></c:otherwise>
      </c:choose>
    </td>
    <td>${fn:substring(review.review_text, 0, 20)}...</td>
    <td><button type="button" class="toggleDetailBtn">▼ 상세보기</button></td>
  </tr>

  <!-- 상세 정보 줄 -->
  <tr class="review-detail-row" style="display:none;">
    <td colspan="9">
      <p><strong>전체 리뷰 내용:</strong><br>${review.review_text}</p>
      <form method="post" action="${pageContext.request.contextPath}/admin/review_hide" style="display:inline;">
        <input type="hidden" name="review_id" value="${review.review_id}" />
        <input type="text" name="reason" placeholder="숨김 사유" required style="width: 90px;" />
        <button type="submit" class="btn-sm">숨김</button>
      </form>
      <form method="post" action="${pageContext.request.contextPath}/admin/review_delete" style="display:inline;" onsubmit="return confirm('정말 삭제하시겠습니까?')">
        <input type="hidden" name="review_id" value="${review.review_id}" />
        <input type="text" name="reason" placeholder="삭제 사유" required style="width: 90px;" />
        <button type="submit" class="btn-sm btn-danger">삭제</button>
      </form>
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
	</div>
</main>
	
	<form id="reviewActionForm" method="post">
 		 <input type="hidden" name="review_id" id="modalReviewId_form">
 		 <input type="hidden" name="reason" id="modalReasonHidden">
	</form>
	<c:if test="${not empty msg}">
  <script>alert('${msg}');</script>
</c:if>

<script>
document.addEventListener("DOMContentLoaded", function () {
	  document.querySelectorAll('.toggleDetailBtn').forEach(btn => {
	    btn.addEventListener('click', function () {
	      const row = this.closest('tr').nextElementSibling;
	      const isOpen = row.style.display === 'table-row';
	      row.style.display = isOpen ? 'none' : 'table-row';
	      this.textContent = isOpen ? '▼ 상세보기' : '▲ 닫기';
	    });
	  });
	});

</script>
	
	
	



	
	
<%-- 4. 하단 푸터를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>