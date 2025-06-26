<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>
<%@ include file="/WEB-INF/views/include/header.jsp" %>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/order.css" />

<div class="order-list-container">
  <h2>📦 전체 주문 목록 (관리자)</h2>

  <c:choose>
    <c:when test="${empty orderList}">
      <p>주문 데이터가 없습니다.</p>
    </c:when>
    <c:otherwise>
      <table class="order-table">
        <thead>
          <tr>
            <th>주문번호</th>
            <th>회원번호</th>
            <th>도서 제목</th>
            <th>금액</th>
            <th>상태</th>
            <th>주문일자</th>
            <th>상세보기</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="order" items="${orderList}">
            <tr>
              <td>${order.order_id}</td>
              <td>${order.member_idx}</td>
              <td>${order.book_title}</td>
              <td><fmt:formatNumber value="${order.total_price}" type="currency" currencySymbol="₩"/></td>
              <td>${order.status}</td>
              <td><fmt:formatDate value="${order.order_date}" pattern="yyyy-MM-dd" /></td>
              <td>
                <a href="${pageContext.request.contextPath}/admin/orders/detail?order_id=${order.order_id}">
                  상세보기
                </a>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </c:otherwise>
  </c:choose>
</div>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>

<style>

.order-list-container {
  max-width: 1000px;
  margin: 40px auto;
  padding: 20px;
}
.order-table {
  width: 100%;
  border-collapse: collapse;
}
.order-table th, .order-table td {
  padding: 10px;
  border: 1px solid #ccc;
  text-align: center;
}
.order-table th {
  background-color: #f4f4f4;
}

</style>
