<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> <%-- JSTL functions 라이브러리 추가 --%>

<%-- 1. 페이지 기본 골격과 공통 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>

<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/header.jsp" %>

<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/jw.css">

<!-- 로그인 안 된 경우 -->
<c:if test="${needLogin}">
  <div style="padding: 30px; text-align: center;">
    <h3>⚠ 로그인한 사용자만 이용할 수 있는 기능입니다.</h3>
    <a href="${pageContext.request.contextPath}/member/login">[ 로그인 하러가기 ]</a>
  </div>
</c:if>


<!-- ✅ 로그인 된 경우 -->
<c:if test="${not empty sessionScope.member_idx}">
  
	<main class="main-content" id="recommend">
	  <div class="jw-container">
	
		    <h1>📚 나만을 위한 도서 추천</h1>
		    
		    <script>
		  		console.log("▶ session member_idx:", "${sessionScope.member_idx}");
			</script>
		    
		    <!-- 드롭다운 (정렬 기능) -->
		    <%@ include file="sort.jsp" %>
		
			<!-- 🛒 구매 기반 추천 include -->
		    <h1 style="text-align: left; font-size: 20px">🛒 구매 도서 기반 추천</h1>
		    <%@ include file="purchase.jsp" %>
		
		    <hr style="margin: 30px 0;">
		
		    <!-- 💖 찜 기반 추천 include -->
		    <h1 style="text-align: left; font-size: 20px">💖 찜한 도서 기반 추천</h1>
		    <%@ include file="wishlist.jsp" %>
	
		</div>
	</main>  
	
</c:if>


<%-- 4. 하단 푸터를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>