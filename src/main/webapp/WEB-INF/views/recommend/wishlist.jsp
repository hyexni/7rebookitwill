<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<div class="box box-primary">
		<div class="box-header with-border">
		
<!-- 새로 추가.. 테스트  -->			
<!-- 확인해야 할 것 : when에서 empty부분!!! -->



	<c:choose>
	  <c:when test="${empty wishList}">
	    <p>😢 찜한 도서 없음</p>
	  </c:when>
	  
	  <c:otherwise>
	    <div style="display: flex; flex-wrap: wrap; gap: 20px;">
	      <c:forEach var="book" items="${wishList}">
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
	