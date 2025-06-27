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
    
    <style type="text/css">
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
<style type="text/css">

/* main css */
.book-section {
	margin-bottom: 10px;
	margin-right: 60px;
	margin-left: 30px;
	position: relative;
	 
	 
}

    .book-section h3 {
	font-size: 24px;
	font-weight: bold;
	margin-bottom: 20px;
	padding-bottom: 10px;
	border-bottom: 2px solid #333;
	 
	 
}

    .book-grid {
	display: flex;
	 
	 
}

   .book-card {
	border: solid red;
	/* [일체감-1] 카드에 흰색 배경과 기본 그림자를 추가해 하나의 '박스'처럼 보이게 합니다. */
	background-color: #ffffff;
	border: 1px solid #e0e0e0;
	border-radius: 8px;
	overflow: hidden;
	/* [일체감-2] 그림자 효과에 부드러운 전환 효과를 줍니다. */
	transition: transform 0.3s ease, box-shadow 0.3s ease;
	display: flex;
	flex-direction: column;
	height: auto;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
	 
	 
}

    
    .book-card:hover {        transform:translateY(-5px);
	/* [일체감-3] 호버 시 그림자 효과를 더 강조하여 입체감을 줍니다. */         box-shadow:06px16pxrgba(0,
	0, 0, 0.12);   
	
}

    .book-card a {        text-decoration:none;        color:inherit;   
	    display:flex;        flex-direction:column;        flex-grow:1;   
	
}

    .book-cover {        width:100%;        height:auto;       
	aspect-ratio:4/ 5;          object-fit:cover;   
	
}

    
    .book-info {
	/* [정리] 불필요한 속성 제거 및 패딩 정리 */         padding:15px;        flex-grow:1; 
	      display:flex;        flex-direction:column;   
	
}

    .book-title {        font-weight:bold;
	/* [일체감-4] 제목 폰트를 크고 굵게 하여 잘 보이도록 조정합니다. */         font-size:20px !imporant; 
	      white-space:normal;        overflow:hidden;        text-overflow:ellipsis; 
	      display:-webkit-box;        -webkit-line-clamp:2;       
	-webkit-box-orient:vertical;        line-height:1.4em;        height:2.8em;
	/* 1.4em * 2줄 */
	color: #222; /* 제목 색상을 더 진하게 */
	 
	 
}

    .book-author {
	/* [일체감-5] 저자 폰트는 제목보다 약간 작게, 색상은 부드럽게 하여 위계를 설정합니다. */        
	font-size:16px !imporant;        color:#555;        margin-top:8px;   
	
}

    
    .book-carousel {        overflow:hidden;        padding:10px;
	/* 호버 시 그림자가 잘리지 않도록 여유 공간 확보 */         margin:-10px;
	/* 패딩으로 인한 레이아웃 밀림 방지 */    
	
}

    .swiper-button-next,     .swiper-button-prev {        color:#333;   
	    transform:translateY(-30%);   
	
}
 
 
@media ( max-width : 768px) {
	        .swiper-button-next,         .swiper-button-prev {           
		display:none;       
		
	}
	 
	 
	 
	 
}

body:first-line {
	font-size: 0;
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