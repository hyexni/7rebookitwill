<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="include/layout_head.jsp" %>
<%@ include file="include/header.jsp" %> 
<%@ include file="include/sidebar.jsp" %>  

<%@ include file="/WEB-INF/views/include/alert.jsp" %>

<!-- 1) 공통 CSS/JS (한 번만) -->
<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<!-- Swiper -->
<script src="https://cdn.jsdelivr.net/npm/swiper/swiper-bundle.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin_style_pro.css">
 <!-- header-dropdown js -->
   <script src="${pageContext.request.contextPath}/resources/js/header-dropdown.js"></script>
    

<main class="main-content">
<!-- stats.jsp 본문 -->
<div style="padding: 40px; background: #fff; width: 100%; max-width: 1280px; margin: 0 auto;" class="admin-container">

	<!-- 2) 차트 그리드 -->
	
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
	
	
	<!-- 회원 차트 -->
	<%@ include file="/WEB-INF/views/admin/stats_chart.jsp" %> 
	
	<!-- 도서 카드 -->
	<%@ include file="/WEB-INF/views/admin/stats_bookCard.jsp" %> 
</main>	
	

</div>	

<%-- 4. 하단 푸터를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>