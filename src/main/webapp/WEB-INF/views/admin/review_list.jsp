<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="include/layout_head.jsp" %>
<%@ include file="include/header.jsp" %> 
<%@ include file="include/sidebar.jsp" %>
<%@ include file="/WEB-INF/views/include/alert.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin_review.css">


<main class="main-content">
	<div class="admin-container" id="review-list">
	  <h1>💭 리뷰 관리
 		 <span style="font-size: 16px; color: #ff4d4f;">
   		 (미확인 리뷰: ${uncheckedCount}건)
  		 </span>
	   </h1>
	  
	    <!-- 하나의 form으로 합침 -->
		<form method="get" action="${pageContext.request.contextPath}/admin/review_list#review-list" class="search-form" id="searchForm">
		
		  <!-- 상태 필터 -->
		  <select name="status" onchange="document.getElementById('searchForm').submit()">
		    <option value="">🔍 상태 전체</option>
		    <option value="Y" ${param.status == 'Y' ? 'selected' : ''}>🟢 정상</option>
		    <option value="N" ${param.status == 'N' ? 'selected' : ''}>🟡 숨김</option>
		    <option value="D" ${param.status == 'D' ? 'selected' : ''}>🔴 삭제</option>
		  </select>
		
		  <select name="checked" onchange="this.form.submit()">
			  <option value="">✅ 확인 여부 전체</option>
			  <option value="N" ${param.checked == 'N' ? 'selected' : ''}>❗ 미확인</option>
			  <option value="Y" ${param.checked == 'Y' ? 'selected' : ''}>✔️ 확인됨</option>
		   </select>
		  	
		
		  <!-- 키워드 검색 -->
		  <input type="text" name="keyword" value="${param.keyword}" placeholder="도서명, 리뷰내용, 회원ID 검색" />
		
		  <!-- 검색 버튼 -->
		  <input type="submit" value="검색">
		</form>
		  
		<!-- 📋 테이블 -->
		<table>
		  <thead>
		    <tr>
		      <th style="width: 10%;">리뷰ID</th>
		      <th style="width: 20%;">도서명</th>
		      <th style="width: 24%;">요약</th>
		      <th style="width: 5%;">평점</th>
		      <th style="width: 8%;">상태</th>
		      <th style="width: 10%;">회원ID</th>
		      <th style="width: 10%;">작성일</th>
		      <th style="width: 8%;">확인</th>
		    </tr>
		  </thead>
		  <tbody>
		    <c:forEach var="review" items="${reviewList}">
		      <!-- 목록 행 -->
		      <tr class="review-row">
		        <td>${review.review_id}</td>
		        <td>${review.book_title}</td>
		        <td>${fn:substring(review.review_text, 0, 20)}...</td>
		        <td>${review.review_score}</td>
		        <td>
		          <c:choose>
		            <c:when test="${review.review_status eq 'Y'}"><span class="badge badge-green">정상</span></c:when>
		            <c:when test="${review.review_status eq 'N'}"><span class="badge badge-yellow">숨김</span></c:when>
		            <c:when test="${review.review_status eq 'D'}"><span class="badge badge-red">삭제</span></c:when>
		            <c:otherwise><span class="badge">-</span></c:otherwise>
		          </c:choose>
		        </td>
		        <td>${review.member_id}</td>
		        <td><fmt:formatDate value="${review.review_date}" pattern="yyyy-MM-dd" /></td>
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
		      </tr>
		
		      <!-- 상세보기 줄 -->
			<tr class="review-detail-row" style="display:none;">
			  <td colspan="8">
			    <!-- ① 내용 + ② 버튼/사유 칸을 flex로 나눔 -->
			    <div class="detail-flex">
			      
			      <!-- ① 전체 리뷰 내용 -->
			      <div class="detail-text">
			        <strong>전체 리뷰 내용:</strong><br>
			        <pre>${review.review_text}</pre>
			      </div>
			
			      <!-- ② 버튼/사유 -->
			      <div class="detail-side">
			        
			        <!-- ▼ 버튼 영역 : 조건별로 노출 -->
			        <c:if test="${review.review_checked eq 'N' && review.review_status eq 'Y'}">
			          <!-- 숨김 -->
			          <form method="post" action="${pageContext.request.contextPath}/admin/review_hide">
			            <input type="hidden" name="review_id" value="${review.review_id}">
			            <select name="reason" class="reason-select" data-idx="${review.review_id}" onchange="toggleEtcReason(this)">
			              <option value="">숨김 사유 선택</option>
			              <option value="욕설/비방">욕설/비방</option>
			              <option value="도배성 내용">도배성 내용</option>
			              <option value="광고/홍보">광고/홍보</option>
			              <option value="부적절한 표현">부적절한 표현</option>
			              <option value="기타">기타</option>
			            </select>
			            <input type="text" name="etc_reason" class="etc-reason-input"
			                   placeholder="기타 사유 입력" style="display:none;">
			            <button type="submit" class="btn-sm btn-hide">숨김</button>
			          </form>
			
			          <!-- 삭제 -->
			          <form method="post" action="${pageContext.request.contextPath}/admin/review_delete"
			                onsubmit="return confirm('정말 삭제하시겠습니까?')">
			            <input type="hidden" name="review_id" value="${review.review_id}">
			            <select name="reason" class="reason-select" onchange="toggleEtcReason(this)">
			              <option value="">삭제 사유 선택</option>
			              <option value="욕설/비방">욕설/비방</option>
			              <option value="도배성 내용">도배성 내용</option>
			              <option value="광고/홍보">광고/홍보</option>
			              <option value="부적절한 표현">부적절한 표현</option>
			              <option value="기타">기타</option>
			            </select>
			            <input type="text" name="etc_reason" class="etc-reason-input"
			                   placeholder="기타 사유 입력" style="display:none;">
			            <button type="submit" class="btn-sm btn-danger">삭제</button>
			          </form>
			        </c:if>
			
			        <!-- 확인 버튼 (미확인일 때만) -->
			        <c:if test="${review.review_checked eq 'N'}">
			          <form method="post" action="${pageContext.request.contextPath}/admin/review_check">
			            <input type="hidden" name="review_id" value="${review.review_id}">
			            <button type="submit" class="btn-check-confirm">✅ 확인</button>
			          </form>
			        </c:if>
			
			        <!-- 확인 완료 뱃지 -->
			        <c:if test="${review.review_checked eq 'Y'}">
			          <span class="badge badge-confirmed">✅ 확인 완료</span>
			        </c:if>
			
			        <!-- ▼ 사유 박스 : 숨김(D)/삭제(N)일 때만 노출 -->
			        <c:if test="${review.review_status ne 'Y'}">
			          <div class="reason-box">
			            <span class="reason-label">📌 처리 사유</span>
			            <span class="reason-text">${review.reason}</span>
			          </div>
			        </c:if>
			      </div><!-- /.detail-side -->
			
			    </div><!-- /.detail-flex -->
			  </td>
			</tr>
			</c:forEach>
		
		    <c:if test="${empty reviewList}">
		      <tr><td colspan="8">조회된 리뷰가 없습니다.</td></tr>
		    </c:if>
		  </tbody>
		</table>
	
	  <!-- 📌 페이징 -->
		<!-- 페이지네이션 버튼 -->
		<div class="pagination">
		  <a href="${pageContext.request.contextPath}/admin/review_list?page=${currentPage - 1}
		  			&status=${param.status}&keyword=${param.keyword}&checked=${param.checked}#review-list"
		     class="${currentPage == 1 ? 'disabled' : ''}">&laquo;</a>
		
		  <c:forEach var="i" begin="1" end="${totalPages}">
		    <a href="${pageContext.request.contextPath}/admin/review_list?page=${i}
		    			&status=${param.status}&keyword=${param.keyword}&checked=${param.checked}#review-list"
		       class="${i == currentPage ? 'active' : ''}">
		      ${i}
		    </a>
		  </c:forEach>
		
		  <a href="${pageContext.request.contextPath}/admin/review_list?page=${currentPage + 1}
		  			&status=${param.status}&keyword=${param.keyword}&checked=${param.checked}#review-list"
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
	
	<!-- 기타 사유 입력 필드 제어 -->
	<script>
	  function toggleEtcReason(selectElement) {
	    const form = selectElement.closest("form");
	    const etcInput = form.querySelector(".etc-reason-input");
	    if (selectElement.value === "기타") {
	      etcInput.style.display = "inline-block";
	    } else {
	      etcInput.style.display = "none";
	      etcInput.value = ""; // 기타 선택 안하면 입력값 제거
	    }
	  }
	</script>
	

	
	
	



	
	
<%-- 4. 하단 푸터를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>