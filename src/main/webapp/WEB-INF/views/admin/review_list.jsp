<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="include/layout_head.jsp" %>
<%@ include file="include/header.jsp" %> 
<%@ include file="include/sidebar.jsp" %>
<%@ include file="/WEB-INF/views/include/alert.jsp" %>

<main class="main-content">
	<div class="admin-container">
	  <h1>💭 리뷰 관리
 		 <span style="font-size: 16px; color: #ff4d4f;">
   		 (미확인 리뷰: ${uncheckedCount}건)
  		</span>
	   </h1>
	  
	    <!-- 하나의 form으로 합침 -->
		<form method="get" action="${pageContext.request.contextPath}/admin/review_list" class="search-form">
		
		  <!-- 상태 필터 -->
		  <select name="status">
		    <option value="">🔍 상태 전체</option>
		    <option value="Y" ${param.status == 'Y' ? 'selected' : ''}>🟢 정상</option>
		    <option value="N" ${param.status == 'N' ? 'selected' : ''}>🟡 숨김</option>
		    <option value="D" ${param.status == 'D' ? 'selected' : ''}>🔴 삭제</option>
		  </select>
		
		  <select name="checked">
			  <option value="">✅ 확인 여부 전체</option>
			  <option value="N" ${param.checked == 'N' ? 'selected' : ''}>❗ 미확인</option>
			  <option value="Y" ${param.checked == 'Y' ? 'selected' : ''}>✔️ 확인됨</option>
		   </select>
		  	
		
		  <!-- 키워드 검색 -->
		  <input type="text" name="keyword" value="${param.keyword}" placeholder="도서명, 리뷰내용, 회원ID/이름 검색" />
		
		  <!-- 검색 버튼 -->
		  <input type="submit" value="검색">
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
		      <th>확인</th>
		      <th>요약</th>
		    </tr>
		  </thead>
		  <tbody>
		    <c:forEach var="review" items="${reviewList}">
		      <!-- 목록 행 -->
		      <tr class="review-row">
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
		            <c:when test="${review.review_status eq 'D'}"><span class="badge badge-red">삭제</span></c:when>
		            <c:otherwise><span class="badge">-</span></c:otherwise>
		          </c:choose>
		        </td>
		        <td>
		          <c:choose>
		            <c:when test="${review.review_checked eq 'Y'}">
		              <span class="badge badge-blue">확인됨</span>
		            </c:when>
		            <c:otherwise>
		              <span class="badge badge-gray">미확인</span>
		            </c:otherwise>
		          </c:choose>
		        </td>
		        <td>${fn:substring(review.review_text, 0, 20)}...</td>
		      </tr>
		
		      <!-- 상세보기 줄 -->
		      <tr class="review-detail-row" style="display:none;">
		        <td colspan="10">
		          <p><strong>전체 리뷰 내용:</strong><br>${review.review_text}</p>
		
		          <!-- ✅ 숨김/삭제/확인 처리 버튼 일렬 정렬 -->
		          <div class="review-action-buttons">
		            <!-- 숨김 -->
		            <form method="post" action="${pageContext.request.contextPath}/admin/review_hide" style="display:flex; align-items:center;">
		              <input type="hidden" name="review_id" value="${review.review_id}" />
		              <input type="text" name="reason" placeholder="숨김 사유" required class="input-small" />
		              <button type="submit" class="btn-sm btn-hide">숨김</button>
		            </form>
		
		            <!-- 삭제 -->
		            <form method="post" action="${pageContext.request.contextPath}/admin/review_delete" style="display:flex; align-items:center; margin-left:10px;" onsubmit="return confirm('정말 삭제하시겠습니까?')">
		              <input type="hidden" name="review_id" value="${review.review_id}" />
		              <input type="text" name="reason" placeholder="삭제 사유" required class="input-small" />
		              <button type="submit" class="btn-sm btn-danger">삭제</button>
		            </form>
		
		            <!-- 확인 -->
		            <c:if test="${review.review_checked eq 'N'}">
		              <form method="post" action="${pageContext.request.contextPath}/admin/review_check" style="margin-left:10px;">
		                <input type="hidden" name="review_id" value="${review.review_id}" />
		               <button type="submit" class="btn-check-confirm">
 							 <span>✅</span> 이 리뷰 확인 처리
					   </button>
		              </form>
		            </c:if>
		            <c:if test="${review.review_checked eq 'Y'}">
		              <span class="badge badge-confirmed" style="margin-left:10px;">✅ 이 리뷰는 확인 완료됨</span>
		            </c:if>
		          </div>
		        </td>
		      </tr>
		    </c:forEach>
		
		    <c:if test="${empty reviewList}">
		      <tr><td colspan="10">조회된 리뷰가 없습니다.</td></tr>
		    </c:if>
		  </tbody>
		</table>
	
	  <!-- 📌 페이징 -->
		<!-- 페이지네이션 버튼 -->
		<div class="pagination">
		  <a href="${pageContext.request.contextPath}/admin/review_list?page=${currentPage - 1}
		  			&status=${param.status}&keyword=${param.keyword}&checked=${param.checked}"
		     class="${currentPage == 1 ? 'disabled' : ''}">&laquo;</a>
		
		  <c:forEach var="i" begin="1" end="${totalPages}">
		    <a href="${pageContext.request.contextPath}/admin/review_list?page=${i}
		    			&status=${param.status}&keyword=${param.keyword}&checked=${param.checked}"
		       class="${i == currentPage ? 'active' : ''}">
		      ${i}
		    </a>
		  </c:forEach>
		
		  <a href="${pageContext.request.contextPath}/admin/review_list?page=${currentPage + 1}
		  			&status=${param.status}&keyword=${param.keyword}&checked=${param.checked}"
		     class="${currentPage == totalPages ? 'disabled' : ''}">&raquo;</a>
		</div>
	</div>
</main>
	
	<form id="reviewActionForm" method="post">
 		 <input type="hidden" name="review_id" id="modalReviewId_form">
 		 <input type="hidden" name="reason" id="modalReasonHidden">
	</form>

	<script>
		document.addEventListener("DOMContentLoaded", function () {
		  document.querySelectorAll('.review-row').forEach(row => {
		    row.addEventListener('click', function () {
		      const detailRow = this.nextElementSibling;
		      const isOpen = detailRow.style.display === 'table-row';
		      detailRow.style.display = isOpen ? 'none' : 'table-row';
		      this.classList.toggle('open', !isOpen);  // 선택적으로 스타일 변경
		
		      // 옵션: 클릭 시 배경색 토글
		      if (!isOpen) {
		        this.style.backgroundColor = '#f9f9f9';
		      } else {
		        this.style.backgroundColor = '';
		      }
		    });
		  });
		});
	</script>

	
	
	



	
	
<%-- 4. 하단 푸터를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>