<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="include/layout_head.jsp" %>
<%@ include file="include/header.jsp" %>
<%@ include file="include/sidebar.jsp" %>

<%@ include file="/WEB-INF/views/include/alert.jsp" %>

<main class="main-content">
  <h2>📚 관리자 도서 목록</h2>

  <!-- 정렬 조건 선택 -->
  <form method="get" action="${pageContext.request.contextPath}/admin/book" style="margin-bottom: 20px;">
    <label>정렬 기준: </label>
   <select name="sort" onchange="this.form.submit()">
  <option value="default" ${empty cri.sort ? 'selected' : ''}>등록순 (기본)</option>
  <option value="recent" ${cri.sort == 'recent' ? 'selected' : ''}>최신순</option>
  <option value="sales" ${cri.sort == 'sales' ? 'selected' : ''}>판매순</option>
  <option value="review" ${cri.sort == 'review' ? 'selected' : ''}>리뷰 많은 순</option>
  <option value="rating" ${cri.sort == 'rating' ? 'selected' : ''}>평점 높은 순</option>
</select>
  </form>
  
  <!--  필터링 기능  -->
  <form method="get" action="${pageContext.request.contextPath}/admin/book_list">
  <select name="category_id">
    <option value="">전체 카테고리</option>
    <c:forEach var="category" items="${categoryList}">
      <option value="${category.category_id}" ${cri.category_id eq category.category_id ? 'selected' : ''}>
  ${category.category_id}. ${category.category_name_ko}  
</option>
    </c:forEach>
  </select>

  <select name="stock_status">
    <option value="">전체 재고 상태</option>
    <option value="판매중" ${cri.stock_status eq '판매중' ? 'selected' : ''}>판매중</option>
    <option value="품절" ${cri.stock_status eq '품절' ? 'selected' : ''}>품절</option>
    <option value="절판" ${cri.stock_status eq '절판' ? 'selected' : ''}>절판</option>
    <option value="예약판매" ${cri.stock_status eq '예약판매' ? 'selected' : ''}>예약판매</option>
  </select>

  <button type="submit">검색</button>
</form>

  <!-- 도서 목록 테이블 -->
  <table border="1" cellpadding="10" cellspacing="0">
    <thead>
      <tr>
        <th>번호</th>
        <th>표지</th>
        <th>제목</th>
        <th>저자</th>
        <th>출판사</th>
        <th>가격</th>
        <th>재고</th>
        <th>재고 상태</th>
        <th>카테고리</th>
        <th>수정</th>
        <th>삭제</th>
      </tr>
    </thead>
    <tbody>
      <c:choose>
        <c:when test="${empty bookList}">
          <tr><td colspan="11">등록된 도서가 없습니다.</td></tr>
        </c:when>
        <c:otherwise>
          <c:forEach var="book" items="${bookList}" varStatus="status">
            <tr>
              <td>${book.book_id}</td>
              <td><img src="${pageContext.request.contextPath}/resources/img/book/${book.cover_image}" width="50" /></td>
              <td>${book.book_title}</td>
              <td>${book.author_name}</td>
              <td>${book.publisher}</td>
              <td><fmt:formatNumber value="${book.book_price}" type="number"/>원</td>
              <td>${book.book_stock}</td>

              <!-- 재고 상태 드롭다운 -->
              <td>
                <form action="${pageContext.request.contextPath}/admin/book_update_status" method="post">
                  <input type="hidden" name="book_id" value="${book.book_id}" />
                  <select name="stock_status">
				  <option value="판매중" ${book.stock_status == '판매중' ? 'selected' : ''}>판매중</option>
				  <option value="품절" ${book.stock_status == '품절' ? 'selected' : ''}>품절</option>
				  <option value="절판" ${book.stock_status == '절판' ? 'selected' : ''}>절판</option>
				  <option value="예약판매" ${book.stock_status == '예약판매' ? 'selected' : ''}>예약판매</option>
				</select>
                  <button type="submit">변경</button>
                </form>
              </td>

              <!-- 카테고리 드롭다운 -->
              <td>
                <form action="${pageContext.request.contextPath}/admin/book_update_category" method="post">
                  <input type="hidden" name="book_id" value="${book.book_id}" />
                  <select name="category_id">
                    <c:forEach var="cat" items="${categoryList}">
                      <option value="${cat.category_id}" ${book.category_id == cat.category_id ? 'selected' : ''}>
					  ${cat.category_id}. ${cat.category_name_ko}
					</option>
                    </c:forEach>
                  </select>
                  <button type="submit">변경</button>
                </form>
              </td>

              <td>
                <a href="${pageContext.request.contextPath}/admin/book_edit?book_id=${book.book_id}">
                  <button>수정</button>
                </a>
              </td>
              <td>
                <form method="post" action="${pageContext.request.contextPath}/admin/book_delete">
                  <input type="hidden" name="book_id" value="${book.book_id}" />
                  <button type="submit" onclick="return confirm('정말 삭제할까요?')">삭제</button>
                </form>
              </td>
            </tr>
          </c:forEach>
        </c:otherwise>
      </c:choose>
    </tbody>
  </table>

  <!-- 페이징 바 -->
  <div class="pagination">
    <c:if test="${cri.prev}">
      <a href="?page=${cri.startPage - 1}&sort=${cri.sort}">이전</a>
    </c:if>

    <c:forEach begin="${cri.startPage}" end="${cri.endPage}" var="p">
      <a href="?page=${p}&sort=${cri.sort}" class="${cri.page == p ? 'active' : ''}">${p}</a>
    </c:forEach>

    <c:if test="${cri.next}">
      <a href="?page=${cri.endPage + 1}&sort=${cri.sort}">다음</a>
    </c:if>
  </div>
</main>