<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="include/layout_head.jsp" %>
<%@ include file="include/header.jsp" %>
<%@ include file="include/sidebar.jsp" %>

<%@ include file="/WEB-INF/views/include/alert.jsp" %>

<main class="main-content">
  <h2>📚 관리자 도서 목록</h2>
  
  <div class="book-add-wrapper">
  <a href="${pageContext.request.contextPath}/admin/book_add" class="btn-book-add">
    + 도서 등록
  </a>
  </div>


<!-- 🔍 검색 / 필터 / 정렬 통합 폼 -->
<form method="get" action="${pageContext.request.contextPath}/admin/book_list" style="margin-bottom: 20px; display: flex; gap: 10px; align-items: center; flex-wrap: wrap;">
  <!-- 정렬 -->
  <label for="sort">정렬: </label>
  <select name="sort" id="sort">
    <option value="default" ${empty cri.sort ? 'selected' : ''}>등록순 (기본)</option>
    <option value="recent" ${cri.sort == 'recent' ? 'selected' : ''}>최신순</option>
    <option value="sales" ${cri.sort == 'sales' ? 'selected' : ''}>판매순</option>
    <option value="review" ${cri.sort == 'review' ? 'selected' : ''}>리뷰 많은 순</option>
    <option value="rating" ${cri.sort == 'rating' ? 'selected' : ''}>평점 높은 순</option>
  </select>

  <!-- 카테고리 -->
  <label for="category_id">카테고리: </label>
  <select name="category_id" id="category_id">
    <option value="">전체</option>
    <c:forEach var="category" items="${categoryList}">
      <option value="${category.category_id}" ${cri.category_id eq category.category_id ? 'selected' : ''}>
        ${category.category_id}. ${category.category_name_ko}
      </option>
    </c:forEach>
  </select>

  <!-- 재고 상태 -->
  <label for="stock_status">재고 상태: </label>
  <select name="stock_status" id="stock_status">
    <option value="">전체</option>
    <option value="판매중" ${cri.stock_status eq '판매중' ? 'selected' : ''}>판매중</option>
    <option value="품절" ${cri.stock_status eq '품절' ? 'selected' : ''}>품절</option>
    <option value="절판" ${cri.stock_status eq '절판' ? 'selected' : ''}>절판</option>
    <option value="예약판매" ${cri.stock_status eq '예약판매' ? 'selected' : ''}>예약판매</option>
  </select>

  <!-- 검색 -->
  <label for="search">검색: </label>
  <input type="text" name="search" id="search" value="${cri.search}" placeholder="제목, 저자 등 검색" />

  <button type="submit">검색</button>
</form>


  <!-- 도서 목록 테이블 -->
  <table class="book-table">
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
        <th>관리</th>
      </tr>
    </thead>
    <tbody>
      <c:choose>
        <c:when test="${empty bookList}">
          <tr><td colspan="10">등록된 도서가 없습니다.</td></tr>
        </c:when>
        <c:otherwise>
          <c:forEach var="book" items="${bookList}" varStatus="status">
            <tr>
              <td>${book.book_id}</td>
              <td>
			 	<img src="/upload/books/${book.cover_image}"
				     onerror="this.src='/resources/img/product-img/placeholder.png'"
				     width="50" />
			  </td>      
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
				  <div class="book-actions">
				    
				    <!-- ✏ 수정 버튼 -->
				    <a href="${pageContext.request.contextPath}/admin/book_edit?book_id=${book.book_id}" 
				       class="btn-edit">
				      수정
				    </a>
				
				    <!-- ❌ 삭제 버튼 -->
				    <form method="post"
				          action="${pageContext.request.contextPath}/admin/book_delete"
				          onsubmit="return confirm('정말 삭제하시겠습니까?');">
				      <input type="hidden" name="book_id" value="${book.book_id}" />
				      <button type="submit" class="btn-delete">삭제</button>
				    </form>
				
				  </div>
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

<%@ include file="/WEB-INF/views/include/footer.jsp" %>

<style>

/* 📌 메인 영역 */
.main-content {
  padding: 30px 40px 150px;
  background-color: #f5f7fa;
  font-family: 'Pretendard', sans-serif;
}

/* 📘 페이지 제목 */
.main-content h2 {
  font-size: 24px;
  font-weight: 700;
  color: #333;
  margin-bottom: 25px;
}

/* ✅ 도서 등록 버튼 */
.book-add-wrapper {
  text-align: right;
  margin-bottom: 15px;
}
.btn-book-add {
  display: inline-block;
  padding: 8px 16px;
  background-color: #007bff;
  color: white;
  font-size: 14px;
  border-radius: 5px;
  text-decoration: none;
}
.btn-book-add:hover {
  background-color: #0056b3;
}

/* 🔍 검색 / 필터 폼 */
.main-content form {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 10px;
  margin-bottom: 20px;
}
.main-content form label {
  font-size: 14px;
  color: #333;
}
.main-content form select,
.main-content form input[type="text"] {
  padding: 6px 10px;
  font-size: 14px;
  border: 1px solid #ccc;
  border-radius: 3px;
}
.main-content form button[type="submit"] {
  padding: 6px 12px;
  background-color: #28a745;
  color: white;
  font-size: 14px;
  border: none;
  border-radius: 3px;
  cursor: pointer;
}
.main-content form button[type="submit"]:hover {
  background-color: #218838;
}

/* 📚 도서 목록 테이블 */
.book-table {
  width: 100%;
  border-collapse: collapse;
  background-color: white;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
}
.book-table th, .book-table td {
  padding: 10px;
  border: 1px solid #dee2e6;
  font-size: 14px;
  text-align: center;
}
.book-table th {
  background-color: #f1f3f5;
  font-weight: 600;
  color: #444;
}
.book-table tr:nth-child(even) {
  background-color: #f9fbfc;
}
.book-table img {
  width: 50px;
  border-radius: 4px;
  box-shadow: 0 0 3px rgba(0,0,0,0.1);
}

/* 📦 드롭다운 + 버튼 (상태/카테고리 변경용) */
.book-table select {
  padding: 5px;
  font-size: 13px;
  border-radius: 3px;
  border: 1px solid #ccc;
}
.book-table form button {
  margin-left: 5px;
  padding: 5px 8px;
  font-size: 13px;
  border: none;
  border-radius: 3px;
  background-color: #6c757d;
  color: white;
  cursor: pointer;
}
.book-table form button:hover {
  background-color: #5a6268;
}

/* ✏ 수정 / 삭제 버튼 컨테이너 */
.book-actions {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 6px;
  width: 100%;
}

/* ✏ 수정 버튼 */
.book-actions .btn-edit {
  width: 100%;
  text-align: center;
  padding: 6px 10px;
  background-color: #ffc107;
  color: #222;
  font-size: 13px;
  border: none;
  border-radius: 4px;
  text-decoration: none;
  box-sizing: border-box;
}
.book-actions .btn-edit:hover {
  background-color: #e0a800;
  color: white;
}

/* ❌ 삭제 버튼 */
.book-actions form {
  width: 100%;
  margin: 0;
}
.book-actions .btn-delete {
  width: 100%;
  padding: 6px 10px;
  background-color: #dc3545 !important;
  color: white;
  font-size: 13px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  box-sizing: border-box;
}
.book-actions .btn-delete:hover {
  background-color: #c82333 !important;
}

/* 📄 페이징 */
.pagination {
  margin-top: 30px;
  text-align: center;
}
.pagination a {
  display: inline-block;
  padding: 6px 12px;
  margin: 0 3px;
  background-color: #fff;
  border: 1px solid #ccc;
  color: #007bff;
  text-decoration: none;
  border-radius: 3px;
  font-size: 14px;
}
.pagination a.active {
  background-color: #007bff;
  color: white;
  font-weight: bold;
}
.pagination a:hover {
  background-color: #e9ecef;
}


</style>
