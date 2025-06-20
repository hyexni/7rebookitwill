<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<!-- Swiper CSS & JS CDN -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper/swiper-bundle.min.css" />
<script src="https://cdn.jsdelivr.net/npm/swiper/swiper-bundle.min.js"></script>

<!-- ────────────────────────────────────── -->
<!-- 1) 공통 CSS/JS (한 번만) -->
<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<!-- Swiper -->
<script src="https://cdn.jsdelivr.net/npm/swiper/swiper-bundle.min.js"></script>


<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- 소수점 자르기 format 태그 -->
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 1. 페이지 기본 골격과 공통 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>

<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/admin/include/header.jsp" %>

<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/admin/include/sidebar.jsp" %>

    

<!-- stats.jsp 본문 -->


<div style="padding: 40px; background: #fff; width: 100%; max-width: 900px; margin: 0 auto;">



<!-- ────────────────────────────────────── -->
<!-- 2) 차트 그리드 -->
<h2 style="margin-top: 40px;">📊 관리자 통계 페이지</h2>
<!-- 📌 스타일 정의 -->
<style>

  .stats-container {
    display: grid;
    grid-template-columns: repeat(5, 1fr); /* PC: 5개 정렬 */
    gap: 20px;
    margin-top: 20px;
  }

  .stats-card {
    background: #f8f9fa;
    padding: 20px;
    border-radius: 10px;
    text-align: center;
    box-shadow: 0 2px 5px rgba(0,0,0,0.05);
  }

  /* 태블릿: 2개씩 */
  @media (max-width: 1024px) {
    .stats-container {
      grid-template-columns: repeat(2, 1fr);
    }
  }

  /* 모바일: 1개씩 */
  @media (max-width: 600px) {
    .stats-container {
      grid-template-columns: 1fr;
    }
  }
</style>

<div class="stats-container">
  <div class="stats-card">
    <div style="font-size: 14px; color: #555;">전체 회원 수</div>
    <div style="font-size: 24px; font-weight: bold; margin-top: 5px;">${stats.totalMembers} 명</div>
  </div>

  <div class="stats-card">
    <div style="font-size: 14px; color: #555;">오늘 가입자 수</div>
    <div style="font-size: 24px; font-weight: bold; margin-top: 5px;">${stats.todayNewMembers} 명</div>
  </div>

  <div class="stats-card">
    <div style="font-size: 14px; color: #555;">이번 달 가입자 수</div>
    <div style="font-size: 24px; font-weight: bold; margin-top: 5px;">${stats.monthNewMembers} 명</div>
  </div>

  <div class="stats-card">
    <div style="font-size: 14px; color: #555;">활성 회원 수</div>
    <div style="font-size: 24px; font-weight: bold; margin-top: 5px;">${stats.activeMembers} 명</div>
  </div>

  <div class="stats-card">
    <div style="font-size: 14px; color: #555;">탈퇴 회원 수</div>
    <div style="font-size: 24px; font-weight: bold; margin-top: 5px;">${stats.withdrawnMembers} 명</div>
  </div>
</div>






<div style="
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(320px,1fr));
    gap: 30px;
    margin-top: 30px;
  ">
  <!-- 도넛 차트 -->
  <div style="background:#fff;border:1px solid #ddd;border-radius:10px;padding:20px;
  			display:flex;flex-direction:column;height:280px;">
    <h4 style="text-align:center;margin-bottom:10px;">회원 상태 비율</h4>
    <canvas id="statusChart" style="flex:1;width:100% !important;height:auto !important;"></canvas>
  </div>
  <!-- 막대 차트 -->
  <div style="background:#fff;border:1px solid #ddd;border-radius:10px;padding:20px;
  			display:flex;flex-direction:column;height:280px;">
    <h4 style="text-align:center;margin-bottom:10px;">가입자 수 추이</h4>
    <canvas id="joinChart" style="flex:1;width:100% !important;height:auto !important;"></canvas>
  </div>
</div>

<!-- ────────────────────────────────────── -->
<!-- 3) 차트 초기화 -->
<script>
  // 도넛
  new Chart(
    document.getElementById("statusChart").getContext("2d"),
    {
      type: "doughnut",
      data: {
        labels: ["활성 회원", "탈퇴 회원"],
        datasets: [{
          data: [${stats.activeMembers}, ${stats.withdrawnMembers}],
          backgroundColor: ["#4CAF50", "#F44336"]
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: { legend: { position: "bottom" } },
        layout: { padding: 10 }
      }
    }
  );

  // 막대
  new Chart(
    document.getElementById("joinChart").getContext("2d"),
    {
      type: "bar",
      data: {
        labels: ["오늘", "이번 달", "전체"],
        datasets: [{
          label: "가입자 수",
          data: [${stats.todayNewMembers}, ${stats.monthNewMembers}, ${stats.totalMembers}],
          backgroundColor: ["#2196F3", "#3F51B5", "#9C27B0"]
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        layout: { padding: { top: 10, bottom: 0 } },
        scales: { y: { beginAtZero: true, grace: "5%" } },
        plugins: { legend: { display: false } }
      }
    }
  );
</script>

<!-- ────────────────────────────────────── -->
<!-- 4) 슬라이더 레이아웃 -->
<h2 style="margin-top: 50px;">📊 인기 도서 순위</h2>
<div style="
    display: flex;
    gap: 40px;
    flex-wrap: wrap;
    justify-content: center;
    align-items: stretch;
    margin-top: 20px;
  ">
  <!-- 판매량 -->
  <div style="flex:1; min-width:300px; max-width:500px;">
    <h3>📘 판매량 상위 도서</h3>
    <div class="swiper salesSwiper">
      <div class="swiper-wrapper">
        <c:forEach var="book" items="${topSellingBooks}" varStatus="status">
          <div class="swiper-slide">
            <img
              src="${pageContext.request.contextPath}/resources/img/product-img/${book.coverImage}"
              alt="${book.bookTitle}"
              style="width:100%;height:200px;object-fit:cover;border-radius:6px;margin-bottom:10px;"
              onerror="this.src='${pageContext.request.contextPath}/resources/img/core-img/default.jpg'"
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
          <div class="swiper-slide">
            <img
              src="${pageContext.request.contextPath}/resources/img/product-img/${book.coverImage}"
              alt="${book.bookTitle}"
              style="width:100%;height:200px;object-fit:cover;border-radius:6px;margin-bottom:10px;"
              onerror="this.src='${pageContext.request.contextPath}/resources/img/core-img/default.jpg'"
            />
            <h4>${status.index+1}위 - ${book.bookTitle}</h4>
            <p>📚 장르: ${book.categoryName}</p>
            <p>
              ⭐
              <c:set var="rating" value="${book.avgRating}"/>
              <c:forEach var="i" begin="1" end="5">
                <c:choose>
                  <c:when test="${i <= rating}">★</c:when>
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
    width:100%;
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



 
	
	
	








	
	
	
</div>	
	

<%-- 4. 하단 푸터를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/admin/include/footer.jsp" %>
	
	