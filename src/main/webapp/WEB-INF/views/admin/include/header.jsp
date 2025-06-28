<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html>
<body>
    <!-- Search Wrapper Area Start -->
    <div class="search-wrapper section-padding-100">
        <div class="search-close">
            <i class="fa fa-close" aria-hidden="true"></i>
        </div>
            <div class="row">
                <div class="col-12">
                    <div class="search-content">
                        <form action="#" method="get">
                            <input type="search" name="search" id="search" placeholder="Type your keyword...">
                            <button type="submit"><img src="${pageContext.request.contextPath }/resources/img/core-img/search.png" alt=""></button>
                        </form>
                    </div>
                </div>
            </div>
    </div>
    <!-- Search Wrapper Area End -->
    
    <%-- ##### 새로운 메인 검색/소개 영역 시작 ##### --%>
	<section class="main-visual-area admin-header">

	  <!-- 왼쪽: 로고 + 텍스트 -->
	  <!-- 왼쪽 영역 -->
		<div class="header-left" style="margin-left: 200px;">
		  <a href="/admin/stats">
		    <img src="${pageContext.request.contextPath}/resources/img/core-img/logo2.png" alt="ReBook 로고" class="header-logo">
		  </a>
		  <div class="intro-text">
		    <h2>도서판매 전문점 <span>ReBook - 관리자 페이지</span></h2>
		  </div>
		</div>

	
	  <!-- 오른쪽: 사용자 아이콘 -->
	  <div class="header-right" style="margin-right: 150px;">
	    <div class="user-dropdown">
	      <button class="user-icon">
	        <i class="fas fa-user-circle"></i>
	      </button>
	      <div class="dropdown-menu">
	        <a href="/admin/stats">서비스 홈</a>
	        
	        <div class="admin-dropdown-menu">
			  <c:choose>
			    <c:when test="${not empty sessionScope.ad_id}">
			      <a href="${pageContext.request.contextPath}/admin/logout">로그아웃</a>
			    </c:when>
			    <c:otherwise>
			      <a href="${pageContext.request.contextPath}/admin/login">로그인</a>
			    </c:otherwise>
			  </c:choose>
			</div>
	      </div>
	    </div>
	  </div>
	
	</section>

    
              