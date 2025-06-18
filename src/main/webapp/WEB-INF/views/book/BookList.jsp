<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/views/include/header.jsp" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/book-list.css" />

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

    <!-- 🔍 검색 + 정렬 -->
    <div class="book-toolbar">
      <form action="${pageContext.request.contextPath}/book/list" method="get" class="search-form">
        <input type="hidden" name="category_id" value="${param.category_id}" />
        <input type="text" name="search" placeholder="도서 검색" value="${param.search}" />
        <button type="submit">검색</button>
      </form>

      <form action="${pageContext.request.contextPath}/book/list" method="get" class="sort-form">
        <input type="hidden" name="search" value="${param.search}" />
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
          <img src="${book.cover_image}" alt="${book.book_title}" />
          <p class="book-title">${book.book_title}</p>
          <p class="book-author">${book.author_name}</p>
          <p class="book-price">${book.book_price}원</p>
          
           <!-- 상세보기 링크로 수정 -->
      <a href="${pageContext.request.contextPath}/book/view?bookId=${book.book_id}" class="btn-detail">
        상세보기
      </a>
        </div>
      </c:forEach>
    </div>

    <!-- ⏩ 페이징 -->
    <div class="pagination">
      <c:if test="${criteria.prev}">
        <a href="?page=${criteria.startPage - 1}&search=${param.search}&category_id=${param.category_id}&sort=${param.sort}">&laquo;</a>
      </c:if>
      <c:forEach begin="${criteria.startPage}" end="${criteria.endPage}" var="p">
        <a href="?page=${p}&search=${param.search}&category_id=${param.category_id}&sort=${param.sort}"
           class="${criteria.page == p ? 'active' : ''}">${p}</a>
      </c:forEach>
      <c:if test="${criteria.next}">
        <a href="?page=${criteria.endPage + 1}&search=${param.search}&category_id=${param.category_id}&sort=${param.sort}">&raquo;</a>
      </c:if>
    </div>

    <!-- 푸터 여백 확보 -->
    <div style="height: 120px;"></div>
  </main>
</div>

<jsp:include page="/WEB-INF/views/include/footer.jsp" />
