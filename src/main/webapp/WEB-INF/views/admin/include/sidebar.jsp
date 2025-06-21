<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
  
    <!-- ##### Main Content Wrapper Start ##### -->
    <div class="main-content-wrapper d-flex clearfix">

        <!-- Mobile Nav (max width 767px)-->
        <div class="mobile-nav">
            <!-- Navbar Brand -->
            <div class="amado-navbar-brand">
                <a href="/admin/stats">
                	<img src="${pageContext.request.contextPath }/resources/img/core-img/logo3.png" alt="">
                </a>
            </div>
            <!-- Navbar Toggler -->
            <div class="amado-navbar-toggler">
                <span></span><span></span><span></span>
            </div>
        </div>

        <!-- Header Area Start -->
        <header class="header-area clearfix">
            <!-- Close Icon -->
            <div class="nav-close">
                <i class="fa fa-close" aria-hidden="true"></i>
            </div>
            <!-- Logo -->
            <div class="logo">
                <a href="${pageContext.request.contextPath }/admin/stats"><img src="${pageContext.request.contextPath }/resources/img/core-img/logo3.png" alt="관리자 홈 로고"></a>
            </div>
            <!-- Amado Nav -->
            <nav class="amado-nav">
                <ul class="admin-menu">
					  <li><a href="/admin/stats">관리자 홈</a></li>
					  <li><a href="/admin/member">회원 관리</a></li>
					  <li><a href="/admin/book">도서 관리</a></li>
					  <li><a href="/admin/sales">판매 관리</a></li>
					  <li><a href="/admin/pointHistory">포인트 관리</a></li>
					  <li><a href="/admin/review">리뷰 관리</a></li>
					  <li><a href="/admin/receiptList">영수증 관리</a></li>
					
					  <!-- ✅ 아코디언 메뉴 -->
					  <!-- ✅ 더 안전한 구조 -->
					  <li>
					    <span class="menu-icon"></span>
					    <div class="menu-title" onclick="toggleSubMenu(this)">
					  	고객센터 관리 <span class="arrow">▾</span> </div>
					    <ul class="submenu" style="display: none;">
					      <li><a href="/admin/notice_list">공지사항 관리</a></li>
			 	  	      <li><a href="/admin/list">1:1 문의 관리</a></li>
					    </ul>
					  </li> 
				</ul>
             </nav>
            
            
            
            <!-- Button Group -->
            <div class="amado-btn-group mt-30 mb-100">
                <a href="<c:url value='/recommend/wishlist'/>" class="btn amado-btn mb-15">WISHLIST</a>
                <a href="<c:url value='/receipt/upload'/>" class="btn amado-btn active">영수증업로드</a>
            </div>
            <!-- Cart Menu -->
            <div class="cart-fav-search mb-100">
                <a href="cart.html" class="cart-nav"><img src="${pageContext.request.contextPath }/resources/img/core-img/cart.png" alt=""> Cart <span>(0)</span></a>
                <a href="#" class="fav-nav"><img src="${pageContext.request.contextPath }/resources/img/core-img/favorites.png" alt=""> Favourite</a>
                <a href="#" class="search-nav"><img src="${pageContext.request.contextPath }/resources/img/core-img/search.png" alt=""> Search</a>
            </div>
            <!-- Social Button -->
            <div class="social-info d-flex justify-content-between">
                <a href="#"><i class="fa fa-pinterest" aria-hidden="true"></i></a>
                <a href="#"><i class="fa fa-instagram" aria-hidden="true"></i></a>
                <a href="#"><i class="fa fa-facebook" aria-hidden="true"></i>k</a>
                <a href="#"><i class="fa fa-twitter" aria-hidden="true"></i></a>
            </div>
        </header>
   
        
         <!-- Product Catagories Area Start -->
        <div class="products-catagories-area clearfix">
            <div class="amado-pro-catagory clearfix" style="position: relative; height: 1692.03px;">

  
        