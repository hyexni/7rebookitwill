<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="../include/layout_head.jsp" %>
<%@ include file="../include/header.jsp" %>
<%@ include file="../include/sidebar.jsp" %>
<%@ include file="/WEB-INF/views/include/alert.jsp" %>

<main class="main-content">
  <h2>📘 도서 수정</h2>

  <form method="post" action="${pageContext.request.contextPath}/admin/book_edit"
        enctype="multipart/form-data">
    <input type="hidden" name="book_id" value="${book.book_id}" />

    <table class="form-table">
      <tr><th>제목</th><td><input type="text" name="book_title" value="${book.book_title}" required /></td></tr>
      <tr><th>저자</th><td><input type="text" name="author_name" value="${book.author_name}" required /></td></tr>
      <tr><th>출판사</th><td><input type="text" name="publisher" value="${book.publisher}" required /></td></tr>
      <tr><th>출판일</th><td><input type="date" name="publish_date" value="${book.publish_date}" required /></td></tr>
      <tr><th>가격</th><td><input type="number" name="book_price" value="${book.book_price}" required /></td></tr>
      <tr><th>재고 수량</th><td><input type="number" name="book_stock" value="${book.book_stock}" required /></td></tr>
      <tr>
        <th>재고 상태</th>
        <td>
          <select name="stock_status">
            <option value="판매중" ${book.stock_status eq '판매중' ? 'selected' : ''}>판매중</option>
            <option value="품절" ${book.stock_status eq '품절' ? 'selected' : ''}>품절</option>
            <option value="절판" ${book.stock_status eq '절판' ? 'selected' : ''}>절판</option>
            <option value="예약판매" ${book.stock_status eq '예약판매' ? 'selected' : ''}>예약판매</option>
          </select>
        </td>
      </tr>
      <tr>
        <th>카테고리</th>
        <td>
          <select name="category_id">
            <c:forEach var="cat" items="${categoryList}">
              <option value="${cat.category_id}" ${cat.category_id eq book.category_id ? 'selected' : ''}>
                ${cat.category_id}. ${cat.category_name_ko}
              </option>
            </c:forEach>
          </select>
        </td>
      </tr>
      <tr><th>ISBN</th><td><input type="text" name="isbn" value="${book.isbn}" /></td></tr>
      <tr><th>도서 요약</th><td><textarea name="book_summary" rows="5">${book.book_summary}</textarea></td></tr>
      <tr>
        <th>기존 표지</th>
        <td>
          <img src="/upload/books/${book.cover_image}"
		     onerror="this.src='/resources/img/product-img/placeholder.png'"
		     width="100" />
        </td>
      </tr>
      <tr>
        <th>새 표지 업로드</th>
        <td><input type="file" name="upload" accept="image/*" /></td>
      </tr>
    </table>

    <div style="margin-top: 20px;">
      <button type="submit">수정 완료</button>
      <a href="${pageContext.request.contextPath}/admin/book_list">
        <button type="button">목록으로</button>
      </a>
    </div>
  </form>
</main>

<%@ include file="../include/footer.jsp" %>

<style>
/* 📚 도서 등록 메인 영역 */
.main-content {
  padding: 40px 60px 150px;
  background-color: #f9f9fb;
  font-family: 'Pretendard', sans-serif;
}

/* 📘 제목 */
.main-content h2 {
  font-size: 26px;
  font-weight: bold;
  margin-bottom: 30px;
  color: #222;
}

/* 📋 테이블 스타일 */
.form-table {
  width: 100%;
  border-collapse: collapse;
  background-color: white;
  box-shadow: 0 0 8px rgba(0,0,0,0.05);
  border: 1px solid #dee2e6;
  margin-bottom: 30px;
}

.form-table th {
  background-color: #f1f3f5;
  text-align: left;
  padding: 12px;
  width: 180px;
  font-weight: 600;
  color: #333;
  border-bottom: 1px solid #dee2e6;
}

.form-table td {
  padding: 12px;
  border-bottom: 1px solid #dee2e6;
}

.form-table input[type="text"],
.form-table input[type="number"],
.form-table input[type="date"],
.form-table input[type="file"],
.form-table select,
.form-table textarea {
  width: 100%;
  padding: 8px 10px;
  font-size: 14px;
  border: 1px solid #ccc;
  border-radius: 4px;
  box-sizing: border-box;
}

.form-table textarea {
  resize: vertical;
}

/* ✅ 버튼 스타일 */
.main-content button {
  padding: 10px 20px;
  background-color: #007bff;
  color: white;
  border: none;
  font-size: 14px;
  border-radius: 5px;
  cursor: pointer;
  margin-right: 10px;
}

.main-content button:hover {
  background-color: #0056b3;
}

.main-content a button {
  background-color: #6c757d;
}

.main-content a button:hover {
  background-color: #495057;
}
</style>

