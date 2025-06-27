<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 1. 페이지 기본 골격과 CSS/폰트 링크를 불러옵니다. --%>
<%@include file="/WEB-INF/views/include/layout_head.jsp" %> 

<%-- ... (header, sidebar, alert include는 그대로 유지) ... --%>
<%@include file="/WEB-INF/views/include/header.jsp" %> 
<%@include file="/WEB-INF/views/include/sidebar.jsp" %>
<%@ include file="/WEB-INF/views/include/alert.jsp" %>
<%-- <%-- [추가 1] Swiper.js 라이브러리 CSS 링크 추가 --%>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" /> 

<style>
/* 전체 카드 레이아웃 (수정) */
.book-cards {
    display: flex;
    flex-direction: column; /* 내부 요소를 세로로 배치 */
    
    /* 고정된 크기 지정 - 이 값을 조절하여 원하는 카드 크기를 만드세요 */
    width: 200px;  /* 예시 너비 */
    height: 420px; /* 예시 높이 */
    text-align:end;

    border: 1px solid #e0e0e0;
    border-radius: 10px;
    box-shadow: 1px 2px 6px #f0f0f0;
    background-color: #fff;
    overflow: hidden; /* 내용이 넘칠 경우를 대비해 숨김 처리 */

    transition: all 0.3s ease;
    cursor: pointer;
}

.book-cards:hover {
    transform: translateY(-8px);
    box-shadow: 2px 8px 15px rgba(0,0,0,0.15);
    border-color: #3498db;
}

/* 1. 이미지 영역의 크기를 고정 (핵심) */
.books-card-image {
    width: 200px;
    height: 350px; /* 이미지 영역의 높이를 고정 */
    
    /* 이미지가 없을 때를 대비한 배경색 (자리 차지) */
    background-color: #f5f5f5; 
    
    display: flex;
    align-items: center;
    justify-content: center;
}

/* 2. 실제 이미지가 부모(틀)에 맞춰지도록 설정 */
/* .card-image {border:solid red;
    width: 200px;
    height:300px;}
     */
.card-image img {

    width:100%;
    height:300px;
    /* 이미지가 비율을 유지하며 틀을 꽉 채우도록 설정 (잘리는 부분 발생 가능) */
    /*object-fit: cover; 
     만약 이미지가 잘리지 않고 안에 다 보이게 하려면 'contain' 사용 */
    /* object-fit: contain; */
}

/* 3. 텍스트 콘텐츠 영역 스타일 */
.book-card-content {
    flex-grow: 1; /* 남은 공간을 모두 차지하도록 설정 */
    padding: 15px;
    display: flex;
    flex-direction: column;
}

.book-card-content h3 {
    font-size: 1rem;
    font-weight: bold;
    margin-bottom: 5px;

    /* 제목이 길 경우 ...으로 표시 (여러 줄) */
    overflow: hidden;
    text-overflow: ellipsis;
    display: -webkit-box;
    -webkit-line-clamp: 2; /* 2줄까지 표시 */
    -webkit-box-orient: vertical;
}

.book-card-content p {
    font-size: 0.85rem;
    color: #777;
}

.section-divider {
    height: 2px;               /* 선의 두께 */
    width: 95%;                /* 선의 너비 */
    background-color: #e0e0e0; /* 선의 색상 (기존 border 색과 유사) */
    margin: 50px auto;         /* 위아래 여백 50px, 좌우는 자동으로 가운데 정렬 */
    
    
.sea-bar-contar {
        padding: 20px 0 30px 0; /* 검색창 위아래 여백 */
        text-align: center;
    }
    
    
    .2search-bar-container{
    	paiing: 20px 0 30px 0;
    	text-align : center;
    }

    .2search-box {
        display: flex;
        align-items: center;
        max-width: 550px;
        margin: 0 auto; /* 가운데 정렬 */
        background-color: #f8f9fa;
        border: 2px solid #e9ecef;
        border-radius: 50px; /* 타원형 모양 */
        padding: 8px 15px;
        transition: border-color 0.3s, box-shadow 0.3s;
    }

    /* 검색창에 포커스(클릭)되었을 때 스타일 */
    .2search-box:focus-within {
        border-color: #007bff; /* 파란색 테두리 */
        box-shadow: 0 0 8px rgba(0, 123, 255, 0.25);
    }

    .2search-input {
        flex-grow: 1; /* 입력창이 남는 공간을 모두 차지 */
        border: none;
        outline: none;
        background: transparent;
        font-size: 16px;
        color: #333;
        padding-left: 10px;
    }

    .2search-btn {
        border: none;
        background: none;
        cursor: pointer;
        padding: 5px 10px;
        color: #6c757d; /* 아이콘 기본 색상 */
        font-size: 18px;
        transition: color 0.3s;
    }

    .2search-btn:hover {
        color: #007bff; /* 마우스 올리면 아이콘 색상 변경 */
    }
</style>  
    



<!-- ================================================================= -->
<!-- 기본 메인 컨텐츠 (신간, 베스트셀러 등) -->
<!-- ================================================================= -->

     <%-- ======================================================= --%>
    <%--   검색창 HTML 코드 삽입 위치 --%>    
        <div class="2search-auth-area" style="padding: 20px 30px; text-align: center;">
        <form action="${pageContext.request.contextPath}/search" method="get" style="display: inline-block; max-width: 600px; width: 100%;">
            <div class="search-container">
                <input type="text" name="keyword"class="search-input" placeholder="찾고 싶은 도서, 저자, 출판사를 검색하세요">
                <button type="submit" class="search-btn">
                    <i class="fa fa-search"></i>검색
                </button>
            </div>
        </form>
    </div>
   
    <%-- ======================================================= --%>

  
<section style="line-height:-200px !important;font-size:2px;">
    <div class="box box-primary book-section" style="line-height: -200px !important;">
        <div class="box-header with-border" style="line-height: -200px !important;">
            <h3>✨ 리북이 추천하는 올여름 신간 도서</h3>
        </div>
        <div class="box-body">
            <div class="swiper book-carousel" id="newBookSwiper">
                <div class="swiper-wrapper book-grid">
                    <c:forEach var="book" items="${newBookList}">
                        <%-- [수정] 불필요한 인라인 스타일 제거 --%>
                        <div class="swiper-slide book-cards card-image" style="border: 1px solid #ccc;padding: 0 15px;border-radius: 10px;box-shadow: 1px 2px 6px #ccc;">
                            <a href="${pageContext.request.contextPath}/book/view?book_id=${book.book_id}">
                                <img src="${pageContext.request.contextPath}/resources/img/product-img/${book.cover_image}" 
                                     alt="${book.book_title}" class="book-cover" />
                                <div class="book-info" style="font-weight:bold;font-size: 1px !important;">
                                    <div class="book-title" style="font-size:18px;border-bottom: 2px solid #666;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;">${book.book_title}</div>
                                    <div class="book-author" style="font-size:14px;color:#333;text-align: right;">${book.author_name}</div>
                                </div>
                            </a>
                        </div>
                    </c:forEach>
                </div>
                <div class="swiper-button-next"></div>
                <div class="swiper-button-prev"></div>
            </div>
            <c:if test="${empty newBookList}">
                <p>등록된 신간 도서가 없습니다.</p>
            </c:if>
        </div>
    </div>

<%-- =================================================== --%>
  <div class="section-divider"></div>
<%-- =================================================== --%>

    <%-- 베스트셀러 섹션도 동일하게 적용 --%>
    <div class="box box-primary book-section">
        <div class="box-header with-border">
            <h3>🏆사랑받는 도서 베스트셀러</h3>
        </div>
        <div class="box-body">
            <div class="swiper book-carousel" id="bestSellerSwiper">
                <div class="swiper-wrapper book-grid">
                    <c:forEach var="book" items="${bestSellerList}">
                        <%-- [수정] 불필요한 인라인 스타일 제거 --%>
                        <div class="swiper-slide book-cards card-image" style="border: 1px solid #ccc;padding: 0 15px;border-radius: 10px;box-shadow: 1px 2px 6px #ccc;">
                            <a href="${pageContext.request.contextPath}/book/view?book_id=${book.book_id}">
                                <img src="${pageContext.request.contextPath}/resources/img/product-img/${book.cover_image}" 
                                     alt="${book.book_title}" class="book-cover" />
                                <div class="book-info" style="font-weight:bold;font-size: 1px !important;">
                                    <div class="book-title" style="font-size:18px;border-bottom: 2px solid #666;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;">${book.book_title}</div>
                                    <div class="book-author" style="font-size:14px;color:#333;text-align: right;">${book.author_name}</div>
                                </div>
                            </a>
                        </div>
                    </c:forEach>
                </div>
                <div class="swiper-button-next"></div>
                <div class="swiper-button-prev"></div>
            </div>
            <c:if test="${empty bestSellerList}">
                <p>등록된 베스트셀러가 없습니다.</p>
            </c:if>
        </div>
    </div>
</section>



<%@ include file="/WEB-INF/views/include/footer.jsp" %>

<script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>

<script>
// 이 부분의 slidesPerView 값을 조절하여 크기를 변경하세요.
document.addEventListener('DOMContentLoaded', function () {
    const swiperOptions = {
        slidesPerView: 7, // 기본으로 보여줄 슬라이드 수
        spaceBetween: 10,
        loop: true,
        navigation: {}, // 각 슬라이더에서 개별 지정
        breakpoints: {
            1400: { slidesPerView: 6, spaceBetween: 18 },
            1200: { slidesPerView: 5, spaceBetween: 20 },
            992: { slidesPerView: 4, spaceBetween: 15 },
            768: { slidesPerView: 3, spaceBetween: 15 },
            576: { slidesPerView: 2, spaceBetween: 10 }
        }
    };

    const newBookSwiper = new Swiper('#newBookSwiper', {
        ...swiperOptions,
        navigation: {
            nextEl: '#newBookSwiper .swiper-button-next',
            prevEl: '#newBookSwiper .swiper-button-prev',
        }
    });

    const bestSellerSwiper = new Swiper('#bestSellerSwiper', {
        ...swiperOptions,
        navigation: {
            nextEl: '#bestSellerSwiper .swiper-button-next',
            prevEl: '#bestSellerSwiper .swiper-button-prev',
        }
    });
});
</script>
