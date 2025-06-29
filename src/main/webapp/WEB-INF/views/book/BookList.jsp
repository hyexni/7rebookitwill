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

 <!-- 📂 상단 카테고리 필터 -->
<div class="category-bar">
  <a href="${pageContext.request.contextPath}/book/list?search=${param.search}&sort=${param.sort}"
     class="category-btn ${empty param.category_id ? 'active' : ''}">전체</a>
  <c:forEach var="cate" items="${categoryList}">
    <a href="${pageContext.request.contextPath}/book/list?category_id=${cate.category_id}&search=${param.search}&sort=${param.sort}"
       class="category-btn ${param.category_id == cate.category_id.toString() ? 'active' : ''}">
      ${cate.category_name_ko}
    </a>
  </c:forEach>
</div>

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
    <div class="book-list">
      <c:if test="${empty bookList}">
        <p class="no-books">🔍 해당 조건에 맞는 도서가 없습니다.</p>
      </c:if>
    
    <c:forEach var="book" items="${bookList}">
  <div class="book-item">

    <!-- 책 이미지 -->
    <div class="book-cover-wrapper">
      <c:choose>
        <c:when test="${empty book.cover_image}">
          <img src="${pageContext.request.contextPath}/resources/img/product-img/placeholder.png" alt="기본 이미지" />
        </c:when>
        <c:otherwise>
          <img src="${pageContext.request.contextPath}/resources/img/product-img/${book.cover_image}" alt="${book.book_title}" />
        </c:otherwise>
      </c:choose>
    </div>

    <!-- 책 정보 -->
    <div class="book-info">
      <h4>${book.book_title}</h4>
      <p>${book.author_name}</p>
      <p>${book.book_price}원</p>
    </div>

    <!-- 상세보기 버튼 -->
    <div class="book-actions">
      <a href="${pageContext.request.contextPath}/book/view?book_id=${book.book_id}" class="btn-detail">상세보기</a>
    </div>

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

  </main>
</div>

<%-- 4. 하단 푸터를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
