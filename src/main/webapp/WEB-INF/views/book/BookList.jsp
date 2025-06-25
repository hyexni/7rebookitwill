<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/book-list.css" />

<%-- 1. 페이지 기본 골격과 공통 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>

<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/header.jsp" %>

<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>




<div class="book-page-container">

  <!-- 📂 카테고리 영역 -->
  <aside class="category-sidebar">
    <h3>카테고리</h3>
    <a href="${pageContext.request.contextPath}/book/list?search=${param.search}&sort=${param.sort}"
       class="${empty param.category_id ? 'active' : ''}">전체</a>
    <c:forEach var="cate" items="${categoryList}">
      <a href="${pageContext.request.contextPath}/book/list?category_id=${cate.category_id}&search=${param.search}&sort=${param.sort}"
         class="${param.category_id == cate.category_id.toString() ? 'active' : ''}">
        ${cate.category_name_ko}
      </a>
    </c:forEach>
  </aside>

  <!-- 📘 오른쪽 도서 콘텐츠 -->
  <main class="book-content">

    <!-- 제목 -->
    <div class="page-title">📚 책 목록 페이지</div>

    <!-- 정렬 -->
<div class="book-toolbar">
  <form action="${pageContext.request.contextPath}/book/list" method="get" class="sort-form">
    <input type="hidden" name="category_id" value="${param.category_id}" />
    <select name="sort" onchange="this.form.submit()">
      <option value="sales" ${param.sort == 'sales' ? 'selected' : ''}>📦 인기순</option>
      <option value="recent" ${param.sort == 'recent' ? 'selected' : ''}>🕓 최신순</option>
      <option value="review" ${param.sort == 'review' ? 'selected' : ''}>📝 리뷰 많은 순</option>
      <option value="rating" ${param.sort == 'rating' ? 'selected' : ''}>⭐ 평점 높은 순</option>
    </select>
  </form>
</div>

    <!-- 도서 목록 -->
    <div class="book-grid">
      <c:if test="${empty bookList}">
        <p class="no-books">🔍 해당 조건에 맞는 도서가 없습니다.</p>
      </c:if>
     <c:forEach var="book" items="${bookList}">
  <div class="book-card">

  <!-- ✅ 도서 이미지: 기본 이미지 분기 처리 -->
<c:choose>
  <c:when test="${empty book.cover_image}">
    <img class="book-cover"
         src="${pageContext.request.contextPath}/resources/img/product-img/placeholder.png"
         alt="기본 이미지" />
  </c:when>
  <c:otherwise>
    <img class="book-cover"
         src="${pageContext.request.contextPath}/resources/img/product-img/${book.cover_image}"
         alt="${book.book_title}" />
  </c:otherwise>
</c:choose>

    <!-- 도서 정보 -->
    <p class="book-title">${book.book_title}</p>
    <p class="book-author">${book.author_name}</p>
    <p class="book-price">${book.book_price}원</p>

    <!-- 상세보기 버튼 -->
    <a href="${pageContext.request.contextPath}/book/view?book_id=${book.book_id}" class="btn-detail">
      상세보기
    </a>

  </div>
</c:forEach>
     
    </div>

   <!-- ⏩ 페이징 -->
<div class="pagination">
  <c:if test="${pageDTO.prev}">
    <a href="?page=${pageDTO.startPage - 1}&search=${param.search}&category_id=${param.category_id}&sort=${param.sort}">&laquo;</a>
  </c:if>

  <c:forEach begin="${pageDTO.startPage}" end="${pageDTO.endPage}" var="p">
    <a href="?page=${p}&search=${param.search}&category_id=${param.category_id}&sort=${param.sort}"
       class="${pageDTO.criteria.page == p ? 'active' : ''}">${p}</a>
  </c:forEach>

  <c:if test="${pageDTO.next}">
    <a href="?page=${pageDTO.endPage + 1}&search=${param.search}&category_id=${param.category_id}&sort=${param.sort}">&raquo;</a>
  </c:if>
</div>

    <!-- 푸터 여백 확보 -->
    <div style="height: 120px;"></div>
  </main>
</div>

<%-- 4. 하단 푸터를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
