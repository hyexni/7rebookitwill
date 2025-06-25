<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 소수점 자르기 format 태그 -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!-- Swiper CSS & JS CDN -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper/swiper-bundle.min.css" />
<script src="https://cdn.jsdelivr.net/npm/swiper/swiper-bundle.min.js"></script>

<!-- ────────────────────────────────────── -->
	<!-- 4) 슬라이더 레이아웃 -->
	<h2 style="margin-top: 50px;">📊 인기 도서 순위</h2>
	  <div style="
	    display: grid;
	    grid-template-columns: repeat(auto-fit, minmax(320px,1fr));
	    gap: 30px;
	    margin-top: 30px;
	  ">
	  <!-- 판매량 -->
	  <div style="flex:1; width:500px;">
	    <h3>📘 판매량 상위 도서</h3>
	    <div class="swiper salesSwiper">
	      <div class="swiper-wrapper">
	        <c:forEach var="book" items="${topSellingBooks}" varStatus="status">
		          <div class="swiper-slide" style="display: flex; flex-direction: column; align-items: center;">
		            <img
		              src="${pageContext.request.contextPath}/resources/img/product-img/${book.coverImage}"
		              alt="${book.bookTitle}"
		              style="width:100%;height:300px;object-fit:fill;border-radius:6px;margin-bottom:10px;"
		            />
		            <h4>${status.index+1}위 - ${book.bookTitle}</h4>
		            <p>📚 장르: ${book.categoryName}</p>
		            <p>📦 판매 수량: ${book.totalSales}권</p>
		          </div>
	        </c:forEach>
	      </div>
	      <div class="swiper-pagination"></div>
	    </div>
	  </div>
	  
	  
	  <!-- 별점 -->
	  <div style="flex:1; min-width:300px; max-width:500px;">
	    <h3>⭐ 별점 평균 상위 도서</h3>
	    <div class="swiper ratingSwiper">
	      <div class="swiper-wrapper">
	        <c:forEach var="book" items="${topRatedBooks}" varStatus="status">
	          <div class="swiper-slide" style="display: flex; flex-direction: column; align-items: center;">
	            <img
	              src="${pageContext.request.contextPath}/resources/img/product-img/${book.coverImage}"
	              alt="${book.bookTitle}"
	              style="width:90%;height:300px;object-fit:fill;border-radius:6px;margin-bottom:10px;"
	            />
	            <h4>${status.index+1}위 - ${book.bookTitle}</h4>
	            <p>📚 장르: ${book.categoryName}</p>
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
	        </c:forEach>
	      </div>
	      <div class="swiper-pagination"></div>
	    </div>
	  </div>
	</div>
	
	<!-- ──────────────────────────────────────── -->
	<!-- 5) 슬라이더 초기화 (autoplay: false + setInterval 동기화) -->
	<style>
	  /* 카드 사이즈만 한 번! */
	  .swiper-slide {
	    border:1px solid #ddd;
	    border-radius:10px;
	    padding:15px;
	    background:#fff;
	    box-sizing:border-box;
	    width:800px;
	    min-height:350px;
	    display:flex;
	    flex-direction:column;
	  }
	</style>
	
	<script>
	  const salesSwiper = new Swiper(".salesSwiper", {
	    loop: true,
	    pagination: { el: ".salesSwiper .swiper-pagination", clickable: true },
	    autoplay: false,
	    slidesPerView: 1,
	    spaceBetween: 20,
	  });
	  const ratingSwiper = new Swiper(".ratingSwiper", {
	    loop: true,
	    pagination: { el: ".ratingSwiper .swiper-pagination", clickable: true },
	    autoplay: false,
	    slidesPerView: 1,
	    spaceBetween: 20,
	  });
	
	  // 4초마다 **동시에** 넘기기
	  setInterval(() => {
	    salesSwiper.slideNext();
	    ratingSwiper.slideNext();
	  }, 4000);
	</script>