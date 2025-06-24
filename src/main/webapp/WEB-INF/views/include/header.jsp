<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html lang="en"><head>
    <meta charset="UTF-8">
    <meta name="description" content="">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <body>
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
                <i class="fa fa-search"></i>검색
            </button>
        </div>
        </div>
        <div class="auth-buttons">
            <%-- 로그인 되어 있지 않은 경우 --%>
            <c:if test="${empty loginUser}">
                <a href="/member/login" class="btn-login">로그인</a>
                <a href="/member/join" class="btn-signup">회원가입</a>
            </c:if>

            <%-- 로그인 되어 있는 경우 --%>
            <c:if test="${not empty loginUser}">
                 <a href="/member/logout" class="btn-login">로그아웃</a>
                <a href="/member/main" class="btn-signup">마이페이지</a>
            </c:if>
        </div>

</section>