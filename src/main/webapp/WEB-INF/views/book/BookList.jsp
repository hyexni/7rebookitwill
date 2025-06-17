<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/include/header.jsp" />

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/book-list.css" />

<div class="book-page-container">



  <!-- 📚 카테고리 사이드바 -->
  	<aside class="sidebar">
	  <h3>카테고리</h3>
	  <a href="${pageContext.request.contextPath}/book/list?tabType=${param.tabType}">전체</a>
	  <c:forEach var="cate" items="${categoryList}">
	    <c:set var="isActive" value="false" />
	    <c:if test="${param.category_id == cate.category_id.toString()}">
	      <c:set var="isActive" value="true" />
	    </c:if>
	    <a href="${pageContext.request.contextPath}/book/list?category_id=${cate.category_id}&tabType=${param.tabType}"
	       class="${isActive ? 'active' : ''}">
	      ${cate.category_name_ko}
	    </a>
	  </c:forEach>
	</aside>

  <!-- 📘 본문 영역 -->
  <main class="book-content">

<!-- 🔥 탭 버튼: 추천 / 베스트셀러 / 신간 -->
<div class="book-tab">
  <a href="${pageContext.request.contextPath}/book/list?tabType=recommend&category_id=${param.category_id}"
     class="${param.tabType == 'recommend' ? 'active' : ''}">추천</a>
  <a href="${pageContext.request.contextPath}/book/list?tabType=bestseller&category_id=${param.category_id}"
     class="${param.tabType == 'bestseller' ? 'active' : ''}">베스트셀러</a>
  <a href="${pageContext.request.contextPath}/book/list?tabType=new&category_id=${param.category_id}"
     class="${param.tabType == 'new' ? 'active' : ''}">신간</a>
</div>

    <!-- 🔍 검색 + 정렬 -->
    <div class="book-toolbar">
      <form action="${pageContext.request.contextPath}/book/list" method="get" class="search-form">
        <input type="text" name="search" placeholder="도서 검색" value="${param.search}" />
        <button type="submit">검색</button>
      </form>

      <form action="${pageContext.request.contextPath}/book/list" method="get" class="sort-form">
        <input type="hidden" name="search" value="${param.search}" />
        <input type="hidden" name="category_id" value="${param.category_id}" />
        <select name="sort" onchange="this.form.submit()">
          <option value="recent" ${param.sort == 'recent' ? 'selected' : ''}>최신순</option>
          <option value="popular" ${param.sort == 'popular' ? 'selected' : ''}>인기순</option>
          <option value="review" ${param.sort == 'review' ? 'selected' : ''}>리뷰 많은순</option>
        </select>
      </form>
    </div>

    <!-- 📖 도서 목록 -->
    <c:set var="totalPages" value="${(totalCount / 12) + (totalCount % 12 == 0 ? 0 : 1)}" />
    <c:set var="currentPage" value="${empty param.page ? 1 : param.page}" />

    <div class="book-grid">
		    <c:if test="${empty bookList}">
		  <p style="margin: 40px 0; text-align: center; font-size: 18px; color: #999;">
		    🔍 해당 조건에 맞는 도서가 없습니다.
		  </p>
		</c:if>	    
      <c:forEach var="book" items="${bookList}">
        <div class="book-card">
          <c:choose>
            <c:when test="${not empty book.cover_image}">
              <img src="${book.cover_image}" alt="${book.book_title}" />
            </c:when>
            <c:otherwise>
              <img src="/resources/img/default-book.jpg" alt="기본 이미지" />
            </c:otherwise>
          </c:choose>
          <div class="book-info">
            <p class="book-title">${book.book_title}</p>
            <p class="book-author">${book.author_name}</p>
            <p class="book-price">${book.book_price}원</p>
            <button class="btn-detail">상세보기</button>
          </div>
        </div>
      </c:forEach>
    </div>

    <!-- ⏩ 페이징 -->
    <div class="pagination">
      <c:forEach begin="1" end="${totalPages}" var="p">
        <a href="${pageContext.request.contextPath}/book/list?page=${p}
                  &search=${param.search}
                  &category_id=${param.category_id}
                  &sort=${param.sort}"
           class="${currentPage == p ? 'active' : ''}">
          ${p}
        </a>
      </c:forEach>
    </div>
  </main>
</div>

<jsp:include page="/WEB-INF/views/include/footer.jsp" />