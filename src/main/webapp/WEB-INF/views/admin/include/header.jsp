<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
   
<html lang="en"><head>
    <meta charset="UTF-8">
    <meta name="description" content="">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <!-- Font Awesome CDN -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
   
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin.css">
		
	<!-- jQuery 2.1.4 -->
    <script src="${pageContext.request.contextPath }/resources/plugins/jQuery/jQuery-2.1.4.min.js"></script>
    
    <!-- The above 4 meta tags *must* come first in the head; any other head content must come *after* these tags -->

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
<section class="main-visual-area">
    
    <%-- 1. 왼쪽: 로고와 소개 문구 --%>
    <div class="intro-img">
        <a href="/">
            <img src="${pageContext.request.contextPath}/resources/img/core-img/logo2.png" alt="ReBook 로고">
        </a>
        
        </div>
        
        <div class = "intro-text">
        <h2>도서판매 전문점 <span>ReBook</span></h2>
        <p>관리자 페이지</p>
    </div>

    <%-- 2. 오른쪽: 검색창과 버튼들 --%>
    <div class="search-auth-area">
        <div class="search-container">
            <input type="search" name="search" placeholder="도서, 저자, 출판사 검색">
            <button type="submit" class="search-btn">
                <i class="fa fa-search"></i>검색
            </button>
        </div>
         </div>
        <div class="auth-buttons">
            <a href="#" class="btn-login">로그인</a>
            <a href="#" class="btn-signup">회원가입</a>
        </div>
   

</section>

    
              