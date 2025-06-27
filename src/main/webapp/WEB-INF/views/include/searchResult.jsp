<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%--
  이 파일은 AJAX를 통해 호출되는 '부분(Partial)' 페이지입니다.
--%>

<div class="box box-primary">
    <div class="box-header with-border">
        <h3>🔎 '${param.keyword}'에 대한 검색 결과</h3>
        <p>찾으시는 도서 목록입니다. 장바구니에 담거나 바로 구매하실 수 있습니다.</p>
    </div>
    <div class="box-body">

        <%-- ================================================================= --%>
        <%-- 1. 검색 결과 목록 (bookList) 표시 --%>
        <%-- ================================================================= --%>

        <%-- [수정] 검색 결과가 없을 때를 위한 처리 추가 --%>
        <c:if test="${empty bookList}">
            <div style="padding: 30px; text-align: center; border: 1px dashed #ccc; margin-top: 20px;">
                <p>😢 아쉽지만, '${param.keyword}'에 대한 검색 결과가 없습니다.</p>
            </div>
        </c:if>

        <c:if test="${not empty bookList}">
            <div style="display: flex; flex-wrap: wrap; gap: 20px;">
                <%-- [수정] Controller에서 받은 'bookList'를 반복합니다. --%>
                <c:forEach var="book" items="${bookList}">
                    <div class="book-card" style="border: 1px solid #ddd; width: 250px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); display: flex; flex-direction: column; justify-content: space-between;">
                        <a href="${pageContext.request.contextPath}/book/view?book_id=${book.book_id}" style="text-decoration: none; color: inherit;">
                            <img src="${pageContext.request.contextPath}/resources/img/product-img/${book.cover_image}" 
                                 alt="${book.book_title}" 
                                 style="width: 100%; height: 300px; object-fit: cover; border-top-left-radius: 8px; border-top-right-radius: 8px;" />
                            
                            <div style="padding: 10px;">
                                <div style="font-weight: bold; margin-top: 5px; height: 40px; overflow: hidden;">${book.book_title}</div>
                                <div style="color: #555; height: 20px; overflow: hidden; font-size: 14px;">${book.author_name}</div>
                                <div style="font-size: 16px; font-weight: bold; margin: 8px 0; color: #d9534f;">
                                    <fmt:formatNumber value="${book.book_price}" type="number"/>원
                                </div>
                                <div style="font-size: 14px; color: #f0ad4e;">
                                    <c:set var="rating" value="${book.avgRating == null ? 0 : book.avgRating}" />
                                    <c:forEach var="i" begin="1" end="5">
                                        <c:choose>
                                            <c:when test="${i <= rating}">⭐</c:when>
                                            <c:otherwise>☆</c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                    <span style="color: #777; margin-left: 5px;">(<fmt:formatNumber value="${rating}" maxFractionDigits="1"/>)</span>
                                </div>
                            </div>
                        </a>
                        
                        <div class="action-buttons" style="padding: 10px; border-top: 1px solid #eee; text-align: center;">
                            <button type="button" class="btn btn-default btn-sm btn-add-cart" data-book-id="${book.book_id}">
                                <i class="fa fa-shopping-cart"></i> 장바구니
                            </button>
                            <button type="button" class="btn btn-danger btn-sm btn-buy-now" data-book-id="${book.book_id}">
                                <i class="fa fa-credit-card"></i> 바로구매
                            </button>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>

        <%-- ================================================================= --%>
        <%-- 2. 추천 도서 목록 (recommendedList) 표시 --%>
        <%-- ================================================================= --%>

        <%-- [추가] 추천 목록이 있을 경우에만 이 영역을 표시합니다. --%>
        <c:if test="${not empty recommendedList}">
            <hr style="margin: 40px 0;">
            <h4 style="font-weight: bold; margin-bottom: 20px;"><i class="fa fa-magic"></i> 이런 책은 어떠세요?</h4>

            <div style="display: flex; flex-wrap: wrap; gap: 20px;">
                <%-- Controller에서 받은 'recommendedList'를 반복합니다. --%>
                <c:forEach var="recBook" items="${recommendedList}">
                    <div class="book-card" style="border: 1px solid #ddd; width: 250px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); display: flex; flex-direction: column; justify-content: space-between;">
                        <a href="${pageContext.request.contextPath}/book/view?book_id=${recBook.book_id}" style="text-decoration: none; color: inherit;">
                            <img src="${pageContext.request.contextPath}/resources/img/product-img/${recBook.cover_image}" 
                                 alt="${recBook.book_title}" 
                                 style="width: 100%; height: 300px; object-fit: cover; border-top-left-radius: 8px; border-top-right-radius: 8px;" />
                            
                            <div style="padding: 10px;">
                                <div style="font-weight: bold; margin-top: 5px; height: 40px; overflow: hidden;">${recBook.book_title}</div>
                                <div style="color: #555; height: 20px; overflow: hidden; font-size: 14px;">${recBook.author_name}</div>
                                <div style="font-size: 16px; font-weight: bold; margin: 8px 0; color: #d9534f;">
                                    <fmt:formatNumber value="${recBook.book_price}" type="number"/>원
                                </div>
                            </div>
                        </a>
                        
                        <div class="action-buttons" style="padding: 10px; border-top: 1px solid #eee; text-align: center;">
                            <button type="button" class="btn btn-default btn-sm btn-add-cart" data-book-id="${recBook.book_id}">
                                <i class="fa fa-shopping-cart"></i> 장바구니
                            </button>
                            <button type="button" class="btn btn-danger btn-sm btn-buy-now" data-book-id="${recBook.book_id}">
                                <i class="fa fa-credit-card"></i> 바로구매
                            </button>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>
    </div>
</div>


<%-- 장바구니/바로구매 버튼 클릭 시 동작할 스크립트 (jQuery 사용) --%>
<script>
// 이벤트 위임(event delegation) 방식으로 동적으로 생성된 버튼에 이벤트 핸들러를 연결합니다.
$('#search-result-area').on('click', '.btn-add-cart', function() {
    var bookId = $(this).data('book-id');
    var memberIdx = "${sessionScope.member_idx}"; // 실제 사용하는 세션 변수명으로 확인 필요

    if (!memberIdx) {
        alert("로그인이 필요한 기능입니다.");
        location.href = "${pageContext.request.contextPath}/member/login";
        return;
    }

    $.ajax({
        type: 'POST',
        url: '${pageContext.request.contextPath}/cart/add',
        data: { book_id: bookId, quantity: 1 },
        success: function(result) {
            if(result === 'success') {
                if(confirm('장바구니에 상품을 담았습니다. 장바구니로 이동하시겠습니까?')) {
                    location.href = '${pageContext.request.contextPath}/cart/list';
                }
            } else {
                alert('장바구니 담기에 실패했습니다.');
            }
        },
        error: function() {
            alert('오류가 발생했습니다.');
        }
    });
});

$('#search-result-area').on('click', '.btn-buy-now', function() {
    var bookId = $(this).data('book-id');
    location.href = "${pageContext.request.contextPath}/order/form?book_id=" + bookId + "&quantity=1";
});
</script>