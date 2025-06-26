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
  <div class="box box-primary">
    <div class="box-header with-border">

		<c:choose>
		  <c:when test="${empty purchaseList}">
		    <c:choose>
		      <c:when test="${hasPurchaseHistory}">
		        <div style="text-align: center; color: #444; padding: 30px;">
		          		📦 구매하신 책이 해당 장르의 유일한 도서라<br/>지금은 추천드릴 책이 없어요.
						다른 장르도 한 번 구경해보세요 😊
		        </div>
		      </c:when>
		      <c:otherwise>
		        <div style="text-align: center; color: #444; padding: 30px;">
		             아직 구매하신 도서가 없어요!<br/>
		             마음에 드는 책을 찾아보세요 😊
		        </div>
		      </c:otherwise>
		    </c:choose>
		  </c:when>
		  <c:otherwise>
          <div style="display: flex; flex-wrap: wrap; gap: 20px;">
            <c:forEach var="book" items="${purchaseList}">
              <a href="${pageContext.request.contextPath}/book/view?book_id=${book.bookId}"
                 style="text-decoration: none; color: inherit;">
                <div style="border: 1px solid #ccc; padding: 10px; width: 250px; cursor: pointer;">
                  
	                  <!-- 이미지 -->
	                  <img src="${pageContext.request.contextPath}/resources/img/product-img/${book.coverImage}" 
	                       alt="${book.bookTitle}" 
	                       style="width: 100%; height: 250px; object-fit: fill; border-radius: 5px;" />
	
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
			            <p>
			              <c:set var="rating" value="${book.avgRating}"/>
			              <c:forEach var="i" begin="1" end="5">
			                <c:choose>
			                  <c:when test="${i <= rating}">⭐</c:when>
			                  <c:otherwise>☆</c:otherwise>
			                </c:choose>
			              </c:forEach>
			              (<fmt:formatNumber value="${book.avgRating}" pattern="#0.0"/>)
			            </p>
			          </div>

                </div>
              </a>
            </c:forEach>
          </div>
        </c:otherwise>
      </c:choose>

    </div>
  </div>
</c:if>

