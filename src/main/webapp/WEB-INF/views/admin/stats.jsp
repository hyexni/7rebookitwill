<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- 1. 페이지 기본 골격과 공통 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="include/layout_head.jsp" %>

<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@ include file="include/header.jsp" %> 

<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@ include file="include/sidebar.jsp" %>  

		<!-- SweetAlert2 라이브러리 불러오기 -->
		<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
		
			<c:if test="${not empty msg}">
			  <script>
			    window.addEventListener('DOMContentLoaded', () => {
			      Swal.fire({
			        icon: '${icon}',      // success, error 등
			        title: '${msg}'       // ex. 최고관리자님 환영합니다 👑
			      });
			    });
			  </script>
			</c:if>

<!-- 1) 공통 CSS/JS (한 번만) -->
<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<!-- Swiper -->
<script src="https://cdn.jsdelivr.net/npm/swiper/swiper-bundle.min.js"></script>

<!-- stats.jsp 본문 -->
<div style="padding: 40px; background: #fff; width: 100%; max-width: 1280px; margin: 0 auto;">

	<!-- 2) 차트 그리드 -->
	<h2 style="margin-top: 40px;">📊 관리자 페이지</h2>
	
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
	
	

</div>	

<%-- 4. 하단 푸터를 불러옵니다. --%>
<%@ include file="include/footer.jsp" %> 