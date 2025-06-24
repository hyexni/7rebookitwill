<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
  <style>
   /* 하위 메뉴(.submenu) 선택자를 .amado-nav ul li 아래로 한정하여
      다른 곳의 .submenu 클래스와 충돌하지 않도록 수정합니다.
    */
    .amado-nav ul li .submenu {
        display: none; /* 기본적으로 하위 메뉴 숨기기 */
        padding-left: 20px; /* 하위 메뉴 들여쓰기 */
        margin-top: 10px; /* 상위 메뉴와의 간격 */
    }
    
    /* 하위 메뉴 안의 링크(a) 스타일 */
    .amado-nav ul li .submenu li a {
        font-size: 14px; /* 글자 크기 살짝 작게 */
        color: #888; /* 글자 색상 연하게 */
        padding: 5px 15px; /* 상하좌우 여백 */
    }
    
    /* '고객센터'와 같이 하위 메뉴를 가진 li의 a 태그 스타일
      .amado-nav ul li를 유지하면서 .has-submenu 클래스로 특정
    */
    .amado-nav ul li.has-submenu > a {
        cursor: pointer; /* 클릭할 수 있는 요소임을 표시 */
        display: flex;
        justify-content: space-between; /* 글자는 왼쪽, 아이콘은 오른쪽 끝으로 분리 */
        align-items: center; /* 세로 중앙 정렬 */
        width: 100%; /* 너비를 꽉 채워 정렬이 올바르게 되도록 함 */
    }
  </style>
  
  
    <!-- ##### Main Content Wrapper Start ##### -->
    <div class="main-content-wrapper d-flex clearfix">

        <!-- Mobile Nav (max width 767px)-->
        <div class="mobile-nav">
            <!-- Navbar Brand -->
            <div class="amado-navbar-brand">
                <a href="index.html"><img src="${pageContext.request.contextPath }/resources/img/core-img/logo3.png" alt=""></a>
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
                <a href="index.html"><img src="${pageContext.request.contextPath }/resources/img/core-img/logo3.png" alt=""></a>
            </div>
            <!-- Amado Nav -->
            <nav class="amado-nav">
                <ul>
                    <li><a href="<c:url value='/book/list'/>">도서 목록</a></li>
                    <li><a href="<c:url value='/recommend/all'/>">추천 도서</a></li>
                    <li><a href="<c:url value='/bookreport/write'/>">독후감</a></li>
                    <li><a href="<c:url value='/point/history'/>">포인트확인</a></li>
                    
                    
           <li class="has-submenu">
                <a href="#">고객센터</a>
                <ul class="submenu">
                    
                    <li><a href="<c:url value='/notice/list'/>">공지사항</a></li>
                    <li><a href="<c:url value='/cs/list'/>">1:1 문의</a></li>
                 </ul>
             </li>
            </ul>
            </nav>
            <!-- Button Group -->
            <div class="amado-btn-group mt-30 mb-100">
                <a href="<c:url value='/wishlist/list'/>" class="btn amado-btn mb-15">WISHLIST</a>
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

  
  
  <!-- /---------- -->

 <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <script>
    $(document).ready(function(){
        // '고객센터' 메뉴(.has-submenu 안의 a태그) 클릭 시 이벤트 처리
        $('.amado-nav .has-submenu > a').on('click', function(e){
            // a 태그의 기본 동작(페이지 이동)을 막습니다.
            e.preventDefault(); 
            
            // 현재 클릭한 메뉴의 부모 li에 'open' 클래스를 붙였다 뗐다 합니다. (화살표 모양 변경용)
            $(this).parent('.has-submenu').toggleClass('open');
            
            // 현재 클릭한 메뉴의 바로 다음에 있는 하위 메뉴(.submenu)를 슬라이드 효과로 열고 닫습니다.
            $(this).siblings('.submenu').slideToggle();
        });
    });
    </script>
  
        