<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="include/layout_head.jsp" %>
<%@ include file="include/header.jsp" %> 
<%@ include file="include/sidebar.jsp" %>

<h2>📦 관리자 주문 목록</h2>

<!-- ✅ 필터 영역 -->
<form method="get" action="${pageContext.request.contextPath}/admin/orders/list">
  <input type="text" name="member_id" placeholder="회원 ID" value="${cri.member_id}" />
  <select name="payment_status">
    <option value="">결제 상태</option>
    <option value="결제완료" ${cri.payment_status == '결제완료' ? 'selected' : ''}>결제완료</option>
    <option value="결제대기" ${cri.payment_status == '결제대기' ? 'selected' : ''}>결제대기</option>
  </select>
  <select name="delivery_status">
    <option value="">배송 상태</option>
    <option value="배송중" ${cri.delivery_status == '배송중' ? 'selected' : ''}>배송중</option>
    <option value="배송완료" ${cri.delivery_status == '배송완료' ? 'selected' : ''}>배송완료</option>
  </select>
  <button type="submit">검색</button>
</form>

<!-- ✅ 주문 목록 테이블 -->
<table class="detail-table">
  <thead>
    <tr>
      <th>주문번호</th>
      <th>회원 ID</th>
      <th>회원명</th>
      <th>책 제목</th>
      <th>수량</th>
      <th>총 금액</th>
      <th>결제 상태</th>
      <th>주문일</th>
      <th>상세보기</th>
    </tr>
  </thead>
  <tbody>
    <c:forEach var="order" items="${orderList}">
      <tr>
        <td>${order.order_id}</td>
        <td>${order.member_id}</td>
        <td>${order.member_name}</td>
        <td>${order.book_title}</td>
        <td>${order.book_count}</td>
        <td><fmt:formatNumber value="${order.total_price}" type="currency" /></td>
        <td>${order.status}</td>
        <td>${order.order_date}</td>
        <td>
          <a href="${pageContext.request.contextPath}/admin/orders/detail?order_id=${order.order_id}">보기</a>
        </td>
      </tr>
    </c:forEach>
  </tbody>
</table>

<!-- ✅ 페이징 바 -->
<div class="pagination">
  <c:if test="${cri.prev}">
    <a href="?page=${cri.startPage - 1}&member_id=${cri.member_id}&payment_status=${cri.payment_status}&delivery_status=${cri.delivery_status}">«</a>
  </c:if>
  <c:forEach var="i" begin="${cri.startPage}" end="${cri.endPage}">
    <a href="?page=${i}&member_id=${cri.member_id}&payment_status=${cri.payment_status}&delivery_status=${cri.delivery_status}"
       class="${cri.page == i ? 'active' : ''}">${i}</a>
  </c:forEach>
  <c:if test="${cri.next}">
    <a href="?page=${cri.endPage + 1}&member_id=${cri.member_id}&payment_status=${cri.payment_status}&delivery_status=${cri.delivery_status}">»</a>
  </c:if>
</div>

<%-- 4. 하단 푸터를 불러옵니다. --%>
<%@ include file="include/footer.jsp" %> 

<style>
/* ✅ 페이징 바 스타일 */
.pagination {
  display: flex;
  justify-content: center;
  margin-top: 24px;
  gap: 6px;
  font-family: 'Noto Sans KR', sans-serif;
}

.pagination a {
  display: inline-block;
  padding: 6px 12px;
  color: #333;
  border: 1px solid #ccc;
  border-radius: 4px;
  text-decoration: none;
  font-size: 14px;
}

.pagination a.active {
  background-color: #007bff;
  color: white;
  border-color: #007bff;
  font-weight: bold;
}

.pagination a:hover {
  background-color: #e9f5ff;
}
</style>
