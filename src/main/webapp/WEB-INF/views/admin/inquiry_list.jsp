<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 1. 페이지 기본 골격과 공통 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="include/layout_head.jsp" %>

<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@ include file="include/header.jsp" %> 

<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@ include file="include/sidebar.jsp" %> 
<%@ include file="/WEB-INF/views/include/alert.jsp" %>


<main class="main-content">
	<div class="admin-container" id="inquiry-list">
	  <h1>📩 1:1 문의 관리
	  	<span style="font-size: 16px; color: #ff4d4f;">
   		 (미답변 문의: ${uncheckedCount}건)
  		</span>
	  </h1>

    <!-- 🔍 검색 영역 -->
    <form class="search-form" method="get" action="list#inquiry-list" id="searchForm">
    
    	<select name="category" onchange="document.getElementById('searchForm').submit()">
		    <option value="">분류 전체</option>
		    <option value="회원정보/로그인" ${param.category == '회원정보/로그인' ? 'selected' : ''}>회원정보/로그인</option>
		    <option value="주문/결제 문의" ${param.category == '주문/결제 문의' ? 'selected' : ''}>주문/결제 문의</option>
		    <option value="배송 문의" ${param.category == '배송 문의' ? 'selected' : ''}>배송 문의</option>
		    <option value="도서 관련 문의" ${param.category == '도서 관련 문의' ? 'selected' : ''}>도서 관련 문의</option>
		    <option value="리워드/포인트" ${param.category == '리워드/포인트' ? 'selected' : ''}>리워드/포인트</option>
		    <option value="영수증 인증 문의" ${param.category == '영수증 인증 문의' ? 'selected' : ''}>영수증 인증 문의</option>
		    <option value="이벤트/쿠폰" ${param.category == '이벤트/쿠폰' ? 'selected' : ''}>이벤트/쿠폰</option>
		    <option value="서비스 제안" ${param.category == '서비스 제안' ? 'selected' : ''}>서비스 제안</option>
		    <option value="기타" ${param.category == '기타' ? 'selected' : ''}>기타</option>
		</select>
		
		
		 <select name="status" onchange="this.form.submit()">
		    <option value="" ${empty param.status ? 'selected' : ''}>상태 전체</option>
		    <option value="접수" ${param.status == '접수' ? 'selected' : ''}>접수</option>
		    <option value="답변완료" ${param.status == '답변완료' ? 'selected' : ''}>답변완료</option>
		 </select>
    
        <input type="text" name="keyword" placeholder="제목/작성자 검색" value="${keyword}">
        <input type="submit" value="검색">
    </form>

    <!-- 📋 문의 목록 테이블 -->
    <table>
        <thead>
            <tr>
                <th style="width: 5%;">등록번호</th>
                <th style="width: 10%;">분류</th>
                <th style="width: 9%;">문의자</th>
                <th style="width: 15%;">제목</th>
                <th style="width: 9%;">문의일</th>
                <th style="width: 9%;">처리상태</th>
                <th style="width: 9%;">처리자</th>
                <th style="width: 9%;">처리일자</th>
	            </tr>
	        </thead>
	        <tbody>
	            <c:forEach var="inquiry" items="${inquiryList}">
	               <tr onclick="location.href='view?inquiry_id=${inquiry.inquiry_id}'" style="cursor: pointer;">
	                    <td>${inquiry.inquiry_id}</td>
	                    <td>${inquiry.category }</td>
	                    <td>${inquiry.member_id}</td>
	                    <td>${inquiry.title}</td>
	                    <td><fmt:formatDate value="${inquiry.created_at}" pattern="yyyy-MM-dd" /></td>
	                    <!-- 처리상태 -->
					      <td>
					        <c:choose>
					          <c:when test="${inquiry.status eq '답변완료'}">
					            <span class="status-badge status-done">답변완료</span>
					          </c:when>
					          <c:otherwise>
					            <span class="status-badge status-received">접수</span>
					          </c:otherwise>
					        </c:choose>
					      </td>
					
					      <!-- ✅ 처리자 -->
					      <td>
					        <c:choose>
					          <c:when test="${not empty inquiry.ad_id}">
					            ${inquiry.ad_id}
					          </c:when>
					          <c:otherwise>-</c:otherwise>
					        </c:choose>
					      </td>
					
					      <!-- 처리일자 -->
					      <td>
					        <c:choose>
					          <c:when test="${inquiry.response_created_at != null}">
					            <fmt:formatDate value="${inquiry.response_created_at}" pattern="yyyy-MM-dd" />
					          </c:when>
					          <c:otherwise>-</c:otherwise>
					        </c:choose>
					      </td>
					    </tr>
					  </c:forEach>
				      <c:if test="${empty inquiryList}">
		                <tr>
		                    <td colspan="8" class="no-records">등록된 문의가 없습니다.</td>
		                </tr>
		            </c:if>
					</tbody>
    </table>

   <!-- 페이지네이션 버튼 -->
	<div class="pagination">
	  <!-- << 이전 페이지 -->
	  <a href="${pageContext.request.contextPath}/admin/list?page=${currentPage - 1}#inquiry-list"
	     <c:if test="${currentPage == 1}">class="disabled"</c:if>>&laquo;</a>
	
	  <!-- 페이지 번호 -->
	  <c:forEach var="i" begin="1" end="${totalPages}">
	    <a href="${pageContext.request.contextPath}/admin/list?page=${i}#inquiry-list"
	       <c:if test="${i == currentPage}">class="active"</c:if>>${i}</a>
	  </c:forEach>
	
	  <!-- >> 다음 페이지 -->
	  <a href="${pageContext.request.contextPath}/admin/list?page=${currentPage + 1}#inquiry-list"
	     <c:if test="${currentPage == totalPages}">class="disabled"</c:if>>&raquo;</a>
	
	 </div>
	</div>
</main>



<%-- 4. 하단 푸터를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>