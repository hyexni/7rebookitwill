<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
   
<html lang="en"><head>
    <meta charset="UTF-8">
    <meta name="description" content="">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <!-- The above 4 meta tags *must* come first in the head; any other head content must come *after* these tags -->

    <!-- Title  -->
    <title>Rebook - BookStore | Home</title>

    <!-- Favicon  -->
    <link rel="icon" href="${pageContext.request.contextPath }/resources/img/core-img/favicon.ico">

	<!-- Core Style CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/core-style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath }/resources/style.css">
   
   
   <link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/custom.css">
   
</head>

<body>
    <!-- Search Wrapper Area Start -->
    <div class="search-wrapper section-padding-100">
        <div class="search-close">
            <i class="fa fa-close" aria-hidden="true"></i>
        </div>
        <div class="container">
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
    </div>
    <!-- Search Wrapper Area End -->
    
    <%-- ##### 새로운 메인 검색/소개 영역 시작 ##### --%>
<section class="main-visual-area">
    
    <%-- 1. 왼쪽: 로고와 소개 문구 --%>
    <div class="intro-img">
        <a href="/">
            <img src="${pageContext.request.contextPath}/resources/img/core-img/logo2.png" alt="ReBook 로고">
        </a>
        
        </div>
        
        <div class = "intro-text">
        <h2>도서판매 전문점 <span>ReBook</span></h2>
        <p>도서구매, 영수증적립시스템까지 모든 것을 한번에!</p>
    </div>

    <%-- 2. 오른쪽: 검색창과 버튼들 --%>
    <div class="search-auth-area">
        <div class="search-container">
            <input type="search" name="search" placeholder="도서, 저자, 출판사 검색">
            <button type="submit" class="search-btn">
                <i class="fa fa-search"></i>
            </button>
        </div>
         </div>
        <div class="auth-buttons">
            <a href="#" class="btn-login">로그인</a>
            <a href="#" class="btn-signup">회원가입</a>
        </div>
   

</section>
<%-- ##### 새로운 메인 검색/소개 영역 끝 ##### --%>
    

    <!-- ##### Main Content Wrapper Start ##### -->
    <div class="main-content-wrapper d-flex clearfix">

        <!-- Mobile Nav (max width 767px)-->
        <div class="mobile-nav">
            <!-- Navbar Brand -->
            <div class="amado-navbar-brand">
                <a href="index.html"><img src="${pageContext.request.contextPath }/resources/img/core-img/logo.png" alt=""></a>
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
                <a href="index.html"><img src="${pageContext.request.contextPath }/resources/img/core-img/logo.png" alt=""></a>
            </div>
            <!-- Amado Nav -->
            <nav class="amado-nav">
                <ul>
                    <li><a href="<c:url value='/books'/>">도서 목록</a></li>
                    <li><a href="<c:url value='/recommend'/>">추천 도서</a></li>
                    <li><a href="<c:url value='/mypage'/>">마이페이지</a></li>
                    <li><a href="<c:url value='/notices'/>">공지사항</a></li>
                    <li><a href="<c:url value='/point/history'/>">포인트확인</a></li>
                </ul>
            </nav>
            <!-- Button Group -->
            <div class="amado-btn-group mt-30 mb-100">
                <a href="#" class="btn amado-btn mb-15">WISHLIST</a>
                <a href="#" class="btn amado-btn active">영수증업로드</a>
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
                <a href="#"><i class="fa fa-facebook" aria-hidden="true"></i></a>
                <a href="#"><i class="fa fa-twitter" aria-hidden="true"></i></a>
            </div>
        </header>
        <!-- Header Area End -->

        <!-- Product Catagories Area Start -->
        <div class="products-catagories-area clearfix">
            <div class="amado-pro-catagory clearfix" style="position: relative; height: 1692.03px;">

  

    
              