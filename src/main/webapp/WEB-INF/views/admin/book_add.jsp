<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="include/layout_head.jsp" %>
<%@ include file="include/header.jsp" %>
<%@ include file="include/sidebar.jsp" %>

<%@ include file="/WEB-INF/views/include/alert.jsp" %>


<main class="main-content">
  <h2>📘 도서 등록</h2>

  <form method="post" action="${pageContext.request.contextPath}/admin/book_add"
        enctype="multipart/form-data">

    <table class="form-table">
      <tr>
        <th>제목</th>
        <td><input type="text" name="book_title" required /></td>
      </tr>
      <tr>
        <th>저자</th>
        <td><input type="text" name="author_name" required /></td>
      </tr>
      <tr>
        <th>출판사</th>
        <td><input type="text" name="publisher" required /></td>
      </tr>
      <tr>
        <th>출판일</th>
        <td><input type="date" name="publish_date" required /></td>
      </tr>
      <tr>
        <th>가격</th>
        <td><input type="number" name="book_price" required /></td>
      </tr>
      <tr>
        <th>재고 수량</th>
        <td><input type="number" name="book_stock" required /></td>
      </tr>
      <tr>
        <th>재고 상태</th>
        <td>
          <select name="stock_status" required>
            <option value="판매중">판매중</option>
            <option value="품절">품절</option>
            <option value="절판">절판</option>
            <option value="예약판매">예약판매</option>
          </select>
        </td>
      </tr>
      <tr>
        <th>카테고리</th>
        <td>
          <select name="category_id" required>
            <c:forEach var="category" items="${categoryList}">
              <option value="${category.category_id}">
                ${category.category_id}. ${category.category_name_ko}
              </option>
            </c:forEach>
          </select>
        </td>
      </tr>
      <tr>
        <th>ISBN</th>
        <td><input type="text" name="isbn" /></td>
      </tr>
      <tr>
        <th>도서 요약</th>
        <td><textarea name="book_summary" rows="5" cols="60"></textarea></td>
      </tr>
      <tr>
		  <th>표지 이미지</th>
		  <td>
		    <input type="text" name="cover_image" placeholder="예: book01.jpg" required />
		    <small style="color: #888;">* /resources/img/product-img/ 안에 있는 파일명을 입력하세요</small>
		  </td>
		</tr>
    </table>

    <div style="margin-top: 20px;">
      <button type="submit">📘 등록하기</button>
        <button type="button" onclick="location.href='${pageContext.request.contextPath}/admin/book_list'">
		    목록으로
		  </button>
    </div>
  </form>
</main>

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

<%@ include file="/WEB-INF/views/include/footer.jsp" %>

