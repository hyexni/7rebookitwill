<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>    

	<div class="box box-primary">
		<div class="box-header with-border">
			
<%-- 			<c:choose>
				<c:when test="${empty recommendList}">
					<p>😢 추천 도서가 없습니다.</p>
				</c:when>
				<c:otherwise>
					<div style="display: flex; flex-wrap: wrap; gap: 20px;">
					  <c:forEach var="book" items="${recommendList}">
					    <div style="border: 1px solid #ccc; padding: 10px; width: 250px;">
					      <img src="${pageContext.request.contextPath}/resources/img/product-img/${book.cover_image}"
					      			 alt="${book.book_title}" style="width: 100%; height: auto;" /> <br>
         				  <strong>${book.book_title}</strong><br>
         				  저자: ${book.author_name}<br>
         				  출판사: ${book.publisher}<br>
           				  가격: <fmt:formatNumber value="${book.book_price}" type="currency" currencySymbol="₩"/><br>
         				  <p style="font-size: 13px; color: #555;">
           				    요약: ${book.book_summary}
        				  </p>
      				    </div>
     				  </c:forEach>
					</div>
				</c:otherwise>
			</c:choose> --%>
			

<!-- 새로 추가.. 테스트  -->			
<!-- 확인해야 할 것 : when에서 empty부분!!!
	recommendList 일 때는 도서 리스트가 안 뜨고
	purchaseList 일 때는 뜸-->

<c:choose>
  <c:when test="${empty purchaseList}">
    <p>😢 구매 도서 없음</p>
  </c:when>
  <c:otherwise>
    <div style="display: flex; flex-wrap: wrap; gap: 20px;">
      <c:forEach var="book" items="${purchaseList}">
        <div style="border: 1px solid #ccc; padding: 10px; width: 250px;">
          
          <!-- 이미지 (조금 낮은 높이로 조정) -->
          <img src="${pageContext.request.contextPath}/resources/img/product-img/${book.cover_image}" 
               alt="${book.book_title}" 
               style="width: 100%; height: 300px; object-fit: cover; border-radius: 5px;" />

          <!-- 제목 -->
          <div style="font-weight: bold; margin-top: 10px;">${book.book_title}</div>

          <!-- 저자 -->
          <div style="color: #555;">${book.author_name}</div>

          <!-- 가격 -->
          <div style="font-size: 16px; font-weight: bold; margin: 8px 0;">
            <fmt:formatNumber value="${book.book_price}" type="number"/>원
          </div>
          
          <!-- **추가하기 별점 평균  -->
          

  <%--         <!-- 별점 평균 -->
          <div style="font-size: 14px;">
            <c:forEach var="i" begin="1" end="5">
              <c:choose>
                <c:when test="${i <= book.avg_rating}">
                  ⭐
                </c:when>
                <c:otherwise>
                  ☆
                </c:otherwise>
              </c:choose>
            </c:forEach>
          </div> --%>

        </div>
      </c:forEach>
    </div>
  </c:otherwise>
</c:choose>
			
	 
		</div>
	</div>	