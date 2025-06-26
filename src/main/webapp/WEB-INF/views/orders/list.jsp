<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>
<%@ include file="/WEB-INF/views/include/header.jsp" %>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>


<div class="order-list-container">
  <h2>📦 나의 주문 목록</h2>

  <c:choose>
    <c:when test="${empty orderList}">
      <p>주문한 내역이 없습니다.</p>
    </c:when>
    <c:otherwise>
      <table class="order-table">
        <thead>
          <tr>
            <th>이미지</th>
            <th>주문번호</th>
            <th>주문 일자</th>
            <th>총 결제금액</th>
            <th>주문 내역</th>
            <th>주문 상태</th>
            <th>상세보기</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="order" items="${orderList}">
            <tr>
              <!-- 책 이미지 -->
              <td>
				  <a href="${pageContext.request.contextPath}/book/view?book_id=${order.book_id}">
				    <img src="${pageContext.request.contextPath}/resources/img/product-img/${order.book_cover}" 
				         alt="${order.book_title}" class="order-book-img" />
				  </a>
			  </td>

              <!-- 주문번호 -->
              <td>${order.order_id}</td>

              <!-- 주문일자 -->
              <td>
                <fmt:formatDate value="${order.order_date}" pattern="yyyy-MM-dd HH:mm" />
              </td>

              <!-- 결제금액 -->
              <td>
                <fmt:formatNumber value="${order.total_price}" type="number" />원
              </td>

              <!-- 주문내역 -->
                <td>
                <c:choose>
			    <c:when test="${order.book_count == 1}">
			      ${order.book_title}
			    </c:when>
			    <c:when test="${order.book_count > 1}">
			      <c:set var="remainCount" value="${order.book_count}" />
			      ${order.book_title} 외 <c:out value="${remainCount - 1}" />권
			    </c:when>
			  </c:choose>
			</td>

              <!-- 배송 상태 -->
			<td>
			  <c:choose>
			    <c:when test="${order.delivery.status_code == '배송중'}">
			      <span class="badge badge-blue">🚚  배송중</span>
			    </c:when>
			    <c:when test="${order.delivery.status_code == '배송완료'}">
			      <span class="badge badge-green">✅  배송완료</span>
			    </c:when>
			    <c:otherwise>
			      <span class="badge badge-gray">📦 배송 준비중</span>
			    </c:otherwise>
			  </c:choose>
			</td>

              <!-- 상세보기 버튼 -->
              <td>
                <a href="${pageContext.request.contextPath}/orders/detail?order_id=${order.order_id}" class="detail-btn">상세보기</a>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </c:otherwise>
  </c:choose>
</div>

<!-- ✅ 페이징 바 -->
<div class="pagination">
  <c:if test="${cri.prev}">
    <a href="?page=${cri.startPage - 1}">&laquo;</a>
  </c:if>

  <c:forEach var="i" begin="${cri.startPage}" end="${cri.endPage}">
    <a href="?page=${i}" class="${cri.page == i ? 'active' : ''}">${i}</a>
  </c:forEach>

  <c:if test="${cri.next}">
    <a href="?page=${cri.endPage + 1}">&raquo;</a>
  </c:if>
</div>


<%@ include file="/WEB-INF/views/include/footer.jsp" %>

<style>
/* 전체 컨테이너 중앙 정렬 */
.order-list-container {
  max-width: 1100px;
  margin: 0 auto;
  padding: 40px 20px;
}

/* 테이블 전체 스타일 */
.order-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 15px;
  text-align: center;
}

/* 테이블 헤더 스타일 */
.order-table thead {
  background-color: #f5f5f5;
  border-bottom: 2px solid #ccc;
}

.order-table th,
.order-table td {
  padding: 12px 10px;
  border-bottom: 1px solid #e0e0e0;
}

/* 책 이미지 스타일 */
.order-book-img {
  width: 60px;
  height: auto;
  border-radius: 6px;
  box-shadow: 1px 1px 5px rgba(0, 0, 0, 0.1);
}

/* 주문 상태 배지 스타일 */
.badge-blue {
  background-color: #90caf9;
  color: #0d47a1;
}

.badge-green {
  background-color: #a5d6a7;
  color: #2e7d32;
}

.badge-gray {
  background-color: #eeeeee;
  color: #555;
}

/* 상세보기 버튼 */
.detail-btn {
  display: inline-block;
  padding: 6px 14px;
  background-color: #2196f3;
  color: #fff;
  border-radius: 20px;
  font-weight: 500;
  text-decoration: none;
}

.detail-btn:hover {
  background-color: #1976d2;
}

/* 📄 페이징 바 스타일 */
.pagination {
  display: flex;
  justify-content: center;
  margin-top: 30px;
  gap: 8px;
}

.pagination a {
  padding: 8px 14px;
  text-decoration: none;
  color: #333;
  border: 1px solid #ccc;
  border-radius: 4px;
  font-weight: bold;
  font-size: 14px;
}

.pagination a.active {
  background-color: #2196f3;
  color: white;
  border-color: #2196f3;
}

.pagination a:hover {
  background-color: #e3f2fd;
  border-color: #90caf9;
}
</style>



