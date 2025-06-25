<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="description" content="">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <!-- The above 4 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    
    <style>
    /* 환영 메시지와 버튼들을 가로로 나란히 정렬하기 위한 부모 컨테이너 스타일 */
    .auth-buttons {
        display: flex; /* Flexbox 레이아웃 사용 */
        align-items: center; /* 세로 중앙 정렬 */
        justify-content: flex-end; /* 오른쪽 끝으로 정렬 */
    }

    /* 환영 메시지 스타일 */
    .welcome-message {
        color: #CCCCCC; /* 글자색 */
        font-size: 16px; /* 글자 크기 */
        margin: 0 15px 0 0; /* 오른쪽 여백을 줘서 버튼과 간격 만들기 */
        white-space: nowrap; /* 문장이 길어져도 줄바꿈 방지 */
    }

    /* 환영 메시지 안의 이름(strong 태그) 강조 스타일 */
    .welcome-message strong {
        color: #fca94a; /* 테마 색상으로 강조 */
        font-weight: bold;
    }

    /* 기존 버튼 스타일 (참고) */
    .btn-login, .btn-signup {
        /* 기존 스타일 유지 */
    }
</style>
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
                            <button type="submit">
                                <img src="${pageContext.request.contextPath }/resources/img/core-img/search.png" alt="">
                            </button>
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

        <div class="intro-text">
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

            <div class="auth-buttons">
                <%-- 로그인 되어 있지 않은 경우 --%>
                <c:if test="${empty loginUser}">
                    <a href="/member/login" class="btn-login">로그인</a>
                    <a href="/member/join" class="btn-signup">회원가입</a>
                </c:if>

                <%-- 로그인 되어 있는 경우 --%>
                <c:if test="${not empty loginUser}">
                <%-- ✨ [추가] 환영 메시지 --%>
        <p class="welcome-message">
            <strong>${loginUser.member_nick}</strong>님, 안녕하세요!
        </p>
                    <a href="/member/logout" class="btn-login">로그아웃</a>
                    <a href="/member/main" class="btn-signup">마이페이지</a>
                </c:if>
            </div>
        </div>
    </section>
</body>
</html>