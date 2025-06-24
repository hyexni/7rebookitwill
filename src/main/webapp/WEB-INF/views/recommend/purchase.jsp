<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>    

<c:if test="${empty sessionScope.member_idx}">
  <div style="padding: 30px; text-align: center;">
    <h3>⚠ 로그인한 사용자만 이용할 수 있는 기능입니다.</h3>
    <a href="${pageContext.request.contextPath}/member/login">[ 로그인 하러가기 ]</a>
  </div>
</c:if>

<c:if test="${not empty sessionScope.member_idx}">
  <%-- 여기부터 구매 도서 추천 목록 출력 코드 --%>



	<div class="box box-primary">
		<div class="box-header with-border">

		<c:choose>
		  <c:when test="${empty purchaseList}">
		    <p>😢 구매 도서 없음</p>
		  </c:when>
		  <c:otherwise>
		    <div style="display: flex; flex-wrap: wrap; gap: 20px;">
		      <c:forEach var="book" items="${purchaseList}">
		        <div style="border: 1px solid #ccc; padding: 10px; width: 250px;">
		          
		          <!-- 이미지 (조금 낮은 높이로 조정) -->
		          <img src="${pageContext.request.contextPath}/resources/img/product-img/${book.coverImage}" 
		               alt="${book.bookTitle}" 
		               style="width: 100%; height: 300px; object-fit: cover; border-radius: 5px;" />
		
		          <!-- 제목 -->
		          <div style="font-weight: bold; margin-top: 10px;">${book.bookTitle}</div>
		
		          <!-- 저자 -->
		          <div style="color: #555;">${book.authorName}</div>
		
		          <!-- 가격 -->
		          <div style="font-size: 16px; font-weight: bold; margin: 8px 0;">
		            <fmt:formatNumber value="${book.bookPrice}" type="number"/>원
		          </div>
		          
		          <!-- **추가하기 별점 평균  -->
		          
		
		  			<!-- 별점 평균 -->
		          <div style="font-size: 14px;">
		            <c:forEach var="i" begin="1" end="5">
		              <c:choose>
		                <c:when test="${i <= book.avgRating}">
		                  ⭐
		                </c:when>
		                <c:otherwise>
		                  ☆
		                </c:otherwise>
		              </c:choose>
		            </c:forEach>
		          </div>
		
		        </div>
		      </c:forEach>
		    </div>
		  </c:otherwise>
		</c:choose>
	 
		</div>
	</div>	
</c:if>				