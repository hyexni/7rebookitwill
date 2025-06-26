<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 1. 페이지 기본 골격과 CSS/폰트 링크를 불러옵니다. --%>
<%@include file="/WEB-INF/views/include/layout_head.jsp" %> 

<%-- ... (header, sidebar, alert include는 그대로 유지) ... --%>
<%@include file="/WEB-INF/views/include/header.jsp" %> 
<%@include file="/WEB-INF/views/include/sidebar.jsp" %>
<%@ include file="/WEB-INF/views/include/alert.jsp" %>

<!-- Swiper CSS & JS CDN -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper/swiper-bundle.min.css" />
<script src="https://cdn.jsdelivr.net/npm/swiper/swiper-bundle.min.js"></script>

<section>

  <div class="box box-primary">
    <div class="box-header with-border">
          
          <div style="display: flex; flex-wrap: wrap; gap: 20px;">
          <div class="swiper ratingSwiper">
	      <div class="swiper-wrapper">
            <c:forEach var="book" items="${bookList}" varStatus="status">
             <c:if test="${status.index < 20}">
              <a href="${pageContext.request.contextPath}/book/view?book_id=${book.book_id}"
                 style="text-decoration: none; color: inherit;">
                <div style="border: 1px solid #ccc; padding: 10px; width: 250px; cursor: pointer;">
                  
                  <!-- 이미지 -->
                  <img src="${pageContext.request.contextPath}/resources/img/product-img/${book.cover_image}" 
                       alt="${book.book_title}" 
                       style="width: 100%; height: 250px; object-fit: fill; border-radius: 5px;" />

                  <!-- 제목 -->
                  <div style="font-weight: bold; margin-top: 10px;">${book.book_title}</div>

                </div>
              </a>
              </c:if>
            </c:forEach>
            </div>
	      <div class="swiper-pagination"></div>
	    </div>
          </div>
   


    </div>
  </div>
</section>

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


<%@ include file="/WEB-INF/views/include/footer.jsp" %>