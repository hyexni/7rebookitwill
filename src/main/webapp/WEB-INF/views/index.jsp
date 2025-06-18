<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- 1. 페이지 기본 골격과 CSS/폰트 링크를 불러옵니다. --%>
<%@include file="/WEB-INF/views/include/layout_head.jsp" %>   

<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@include file="/WEB-INF/views/include/header.jsp" %> 

<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@include file="/WEB-INF/views/include/sidebar.jsp" %>

<style>
 /* 각 도서 섹션 스타일 */
        .book-section {
            margin-bottom: 60px;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .section-header h2 {
            font-size: 24px;
            font-weight: 700;
            margin: 0;
        }

        .section-header .see-more {
            font-size: 16px;
            color: #555;
            text-decoration: none;
        }

        .section-header .ad-badge {
            font-size: 14px;
            color: #999;
            border: 1px solid #ddd;
            padding: 2px 8px;
            border-radius: 4px;
        }

        /* 가로 스크롤 도서 목록 (플렉스박스 이용) */
        .book-list-scroll-wrapper {
            position: relative;
        }

        .book-list.horizontal {
            display: flex;
            overflow-x: auto; /* 가로 스크롤 생성 */
            padding-bottom: 15px; /* 스크롤바 공간 확보 */
            gap: 20px; /* 아이템 사이 간격 */
            scrollbar-width: none; /* Firefox 스크롤바 숨기기 */
        }
        
        .book-list.horizontal::-webkit-scrollbar {
            display: none; /* Chrome, Safari 스크롤바 숨기기 */
        }

        /* 도서 그리드 목록 (그리드 이용) */
        .book-list.grid {
            display: grid;
            /* 최소 140px, 공간이 남으면 1fr씩 차지하는 반응형 그리드 */
            grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));
            gap: 30px 20px; /* 행, 열 간격 */
        }

        /* 개별 도서 카드 스타일 */
        .book-card {
            flex-shrink: 0; /* 가로 스크롤 시 아이템이 찌그러지지 않도록 설정 */
            width: 150px; /* 가로 스크롤 목록의 아이템 너비 고정 */
            text-align: left;
        }
        
        /* 그리드 내 카드 너비는 그리드가 관리하므로 auto로 설정 */
        .book-list.grid .book-card {
            width: auto; 
        }

        .book-card img {
            width: 100%;
            height: auto;
            aspect-ratio: 2 / 3; /* 이미지 비율 유지 */
            object-fit: cover;
            border: 1px solid #eee;
            border-radius: 4px;
            margin-bottom: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        .book-card h3 {
            font-size: 15px;
            font-weight: 500;
            margin: 0 0 5px 0;
            /* 여러 줄 말줄임 처리 */
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 2; /* 2줄까지 표시 */
            -webkit-box-orient: vertical;
        }

        .book-card p {
            font-size: 13px;
            color: #777;
            margin: 0;
        }
        
        /* 스크롤 버튼 (선택 사항) */
        .scroll-btn {
            position: absolute;
            top: 40%;
            transform: translateY(-50%);
            background-color: rgba(255, 255, 255, 0.8);
            border: 1px solid #ddd;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            cursor: pointer;
            z-index: 10;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .scroll-btn.prev { left: -20px; }
        .scroll-btn.next { right: -20px; }



</style>
<%-- 4. 여기서부터 이 페이지만의 고유한 컨텐츠가 시작됩니다. --%>

    <main>
        <section class="book-section">
            <div class="section-header">
                <h2>서울국제도서전에서 꼭 봐야 할 책</h2>
                <a href="#" class="see-more">더보기 +</a>
            </div>
            <div class="book-list-scroll-wrapper">
                <div class="book-list horizontal">
                    <div class="book-card">
                        <a href="<c:url value='/book/detail/1'/>">
                            <img src="${pageContext.request.contextPath }/resources/img/product-img/웅크리는것들은다귀여워.jpg" alt="웅크리는 것들은 다 귀여워">
                            <h3>웅크리는 것들은 다 귀여워</h3>
                        </a>
                    </div>
                    <div class="book-card">
                        <a href="<c:url value='/book/detail/2'/>">
                            <img src="${pageContext.request.contextPath }/resources/img/product-img/바지런한끼니.jpg" alt="바지런한 끼니">
                            <h3>바지런한 끼니</h3>
                        </a>
                    </div>
                    <div class="book-card">
                        <a href="<c:url value='/book/detail/3'/>">
                            <img src="${pageContext.request.contextPath }/resources/img/product-img/모순.jpg" alt="모순">
                            <h3>모순</h3>
                        </a>
                    </div>
                    <div class="book-card">
                        <a href="<c:url value='/book/detail/4'/>">
                            <img src="${pageContext.request.contextPath }/resources/img/product-img/소년이 온다.jpg" alt="소년이 온다">
                            <h3>소년이 온다</h3>
                        </a>
                    </div>
                    <div class="book-card">
                        <a href="<c:url value='/book/detail/5'/>">
                            <img src="${pageContext.request.contextPath }/resources/img/product-img/숲을읽는사람.jpg" alt="숲을 읽는 사람">
                            <h3>숲을 읽는 사람</h3>
                        </a>
                    </div>
                    <div class="book-card">
                        <a href="<c:url value='/book/detail/6'/>">
                            <img src="${pageContext.request.contextPath }/resources/img/product-img/파이썬.jpg" alt="파이썬">
                            <h3>파이썬</h3>
                        </a>
                    </div>
                </div>
            </div>
        </section>

        <section class="book-section">
            <div class="section-header">
                <h2>출판사에서 자신있게 추천해요</h2>
                <span class="ad-badge">AD</span>
            </div>
            <div class="book-list grid">
                 <div class="book-card">
                    <a href="<c:url value='/book/detail/1'/>">
                        <img src="${pageContext.request.contextPath }/resources/img/product-img/영감의공간.jpg" alt="영감의 공간">
                        <h3>영감의공간</h3>
                    </a>
                </div>
                <div class="book-card">
                    <a href="<c:url value='/book/detail/2'/>">
                        <img src="${pageContext.request.contextPath }/resources/img/product-img/유지만.jpg" alt="유지만">
                        <h3>유지만</h3>
                    </a>
                </div>
                <div class="book-card">
                    <a href="<c:url value='/book/detail/3'/>">
                        <img src="${pageContext.request.contextPath }/resources/img/product-img/지구끝의온실.jpg" alt="지구끝의 온실">
                        <h3>지구끝의온실</h3>
                    </a>
                </div>
                <div class="book-card">
                    <a href="<c:url value='/book/detail/4'/>">
                        <img src="${pageContext.request.contextPath }/resources/img/product-img/채식주의자.jpg" alt="채식주의자">
                        <h3>채식주의자</h3>
                    </a>
                </div>
                <div class="book-card">
                    <a href="<c:url value='/book/detail/5'/>">
                        <img src="${pageContext.request.contextPath }/resources/img/product-img/pro-big-1.jpg" alt="숲을 읽는 사람">
                        <h3>숲을 읽는 사람</h3>
                    </a>
                </div>
                <div class="book-card">
                    <a href="<c:url value='/book/detail/6'/>">
                        <img src="${pageContext.request.contextPath }/resources/img/product-img/파이썬.jpg" alt="파이썬">
                        <h3>파이썬</h3>
                    </a>
                </div>
            </div>
        </section>
    </main>
 </div>
</div> <%-- .products-catagories-area 닫는 태그 --%>

<%-- 5. 페이지의 끝을 마무리하는 footer 파일을 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>