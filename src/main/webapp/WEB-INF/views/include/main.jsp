<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 1. 페이지 기본 골격과 CSS/폰트 링크를 불러옵니다. --%>
<%@include file="/WEB-INF/views/include/layout_head.jsp" %> 

<%-- ... (header, sidebar, alert include는 그대로 유지) ... --%>
<%@include file="/WEB-INF/views/include/header.jsp" %> 
<%@include file="/WEB-INF/views/include/sidebar.jsp" %>
<%@ include file="/WEB-INF/views/include/alert.jsp" %>

<style>
    .book-section {
        margin-bottom: 50px;
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
        flex-wrap: wrap;
        gap: 25px 2%;
    }

    .book-card {
        flex: 0 0 18.4%;
        border: 1px solid #e0e0e0;
        border-radius: 8px;
        overflow: hidden;
        transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
        /* [수정 1] 카드 자체를 flex 컨테이너로 만들어 내부 요소 정렬 */
        display: flex;
        flex-direction: column;
    }
    
    .book-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    }

    .book-card a {
        text-decoration: none;
        color: inherit;
        display: flex; /* a 태그도 flex 컨테이너로 */
        flex-direction: column; /* 자식 요소들을 세로로 쌓음 */
        flex-grow: 1; /* 카드의 남은 공간을 모두 채우도록 함 */
    }

    /* [수정 2] 불필요해진 .book-cover-container 스타일 삭제 */
    /* .book-cover-container { ... } */

    /* [수정 3] 이미지 스타일 직접 지정 */
    .book-cover {
        width: 100%;
        height: auto; /* 너비에 맞춰 높이 자동 조절 */
        /* 이미지 비율을 일정하게 유지하여 카드 높이를 맞춤 */
        aspect-ratio: 4 / 5; 
        object-fit: cover; /* 비율이 다른 이미지는 잘라서 채움 */
    }
    
    .book-info {
        padding: 15px;
        /* [수정 4] 텍스트 영역이 남은 공간을 채우도록 함 */
        flex-grow: 1;
        display: flex;
        flex-direction: column;
    }

    .book-title {
        font-weight: bold;
        font-size: 16px;
        white-space: normal;
        overflow: hidden;
        text-overflow: ellipsis;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        line-height: 1.3em;
        height: 2.6em; 
    }

    .book-author {
        font-size: 14px;
        color: #666;
        margin-top: 5px;
    }
    
    /* 가격 정보는 필요 시 주석 해제하여 사용 */
    .book-price {
        font-size: 15px;
        font-weight: bold;
        color: #c0392b;
        margin-top: auto; /* 가격을 항상 맨 아래에 위치시킴 */
        padding-top: 10px;
        text-align: right;
    }
</style>

<section>

    <%-- ====================================================== --%>
    <%--                ✨ 신간 도서 섹션                       --%>
    <%-- ====================================================== --%>
    <div class="box box-primary book-section">
        <div class="box-header with-border">
            <h3>✨ 신간 도서</h3>
        </div>
        <div class="box-body">
            <div class="book-grid">
                <%-- Controller에서 "newBookList" 라는 이름으로 넘겨준 리스트를 사용합니다. --%>
                <c:forEach var="book" items="${newBookList}">
                    <div class="book-card">
                        <a href="${pageContext.request.contextPath}/book/view?book_id=${book.book_id}">
                                    <img src="${pageContext.request.contextPath}/resources/img/product-img/${book.cover_image}" 
                                     alt="${book.book_title}" class="book-cover" />
                            
                            <div class="book-info">
                                <div class="book-title">${book.book_title}</div>
                                <div class="book-author">${book.author_name}</div> <%-- 저자 정보 추가 (DTO에 author 필드 필요) --%>
<!--                                 <div class="book-price"> -->
<%--                                     <fmt:formatNumber value="${book.book_price}" pattern="#,###" />원 가격 정보 추가 (DTO에 price 필드 필요) --%>
<!--                                 </div> -->
                            </div>
                        </a>
                    </div>
                </c:forEach>
                 <%-- 만약 신간 도서가 없다면 메시지를 표시합니다. --%>
                <c:if test="${empty newBookList}">
                    <p>등록된 신간 도서가 없습니다.</p>
                </c:if>
            </div>
        </div>
    </div>
    
    <%-- ====================================================== --%>
    <%--                🏆 베스트셀러 섹션                      --%>
    <%-- ====================================================== --%>
    <div class="box box-primary book-section">
        <div class="box-header with-border">
            <h3>🏆 베스트셀러</h3>
        </div>
        <div class="box-body">
            <div class="book-grid">
                <%-- Controller에서 "bestSellerList" 라는 이름으로 넘겨준 리스트를 사용합니다. --%>
                <c:forEach var="book" items="${bestSellerList}">
                    <div class="book-card">
                        <a href="${pageContext.request.contextPath}/book/view?book_id=${book.book_id}">
                             <div class="book-cover-container">
                                <img src="${pageContext.request.contextPath}/resources/img/product-img/${book.cover_image}" 
                                     alt="${book.book_title}" class="book-cover" />
                            </div>
                            <div class="book-info">
                                <div class="book-title">${book.book_title}</div>
                                <div class="book-author">${book.author_name}</div>
<!--                                 <div class="book-price"> -->
<%--                                     <fmt:formatNumber value="${book.book_price}" pattern="#,###" />원 --%>
<!--                                 </div> -->
                            </div>
                        </a>
                    </div>
                </c:forEach>
                <%-- 만약 베스트셀러가 없다면 메시지를 표시합니다. --%>
                <c:if test="${empty bestSellerList}">
                    <p>등록된 베스트셀러가 없습니다.</p>
                </c:if>
            </div>
        </div>
    </div>
    
    <%-- 여기에 다른 장르 섹션(예: 소설, IT)을 위와 같은 형태로 추가할 수 있습니다. --%>

</section>



<%@ include file="/WEB-INF/views/include/footer.jsp" %>