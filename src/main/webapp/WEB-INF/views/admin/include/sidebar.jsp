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
                <a href="/"><img src="${pageContext.request.contextPath }/resources/img/core-img/logo3.png" alt=""></a>
            </div>
            <!-- Amado Nav -->
            <nav class="amado-nav">
                <ul class="admin-menu">
					  <li><a href="/admin/stats">관리자 홈</a></li>
					  <li><a href="/admin/member_list">회원 관리</a></li>
					  <li><a href="/admin/book_list">도서 관리</a></li>
					  <li><a href="/admin/orders_list">판매 관리</a></li>
					  <li><a href="/admin/pointHistory">포인트 관리</a></li>
					  <li><a href="/admin/review_list">리뷰 관리</a></li>
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
            
            <script>
			  function toggleSubMenu(element) {
			    const submenu = element.nextElementSibling;
			    if (submenu && submenu.classList.contains('submenu')) {
			      if (submenu.style.display === 'none' || submenu.style.display === '') {
			        submenu.style.display = 'block';
			      } else {
			        submenu.style.display = 'none';
			      }
			    }
			  }
			</script>
            
        </header>
   
        
         <!-- Product Catagories Area Start -->
        <div class="products-catagories-area clearfix">
            <div class="amado-pro-catagory clearfix" style="position: relative; height: 1692.03px;">

        