<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="include/layout_head.jsp" %>
<%@ include file="include/header.jsp" %> 
<%@ include file="include/sidebar.jsp" %>

<h2>📄 관리자 주문 상세 정보</h2>

<!-- ✅ 주문 기본 정보 -->
<table class="detail-table">
  <tr><th>주문번호</th><td>${order.order_id}</td></tr>
  <tr><th>회원 ID</th><td>${order.member_id}</td></tr>
  <tr><th>회원명</th><td>${order.member_name}</td></tr>
  <tr><th>주문일</th><td>${order.order_date}</td></tr>
  <tr><th>총 결제금액</th><td><fmt:formatNumber value="${order.total_price}" type="currency"/></td></tr>
  <tr><th>결제방법</th><td>${order.payment_method}</td></tr>
  <tr><th>사용포인트</th><td>${order.used_point}</td></tr>
  <tr><th>적립포인트</th><td>${order.earned_point}</td></tr>
</table>

<!-- ✅ 배송 정보 -->
<h3>🚚 배송 정보</h3>
<table class="detail-table">
  <tr><th>수령인</th><td>${order.delivery.receiver_name}</td></tr>
  <tr><th>연락처</th><td>${order.delivery.receiver_phone}</td></tr>
  <tr><th>주소</th><td>${order.delivery.delivery_address} ${order.delivery.address_detail}</td></tr>
  <tr><th>우편번호</th><td>${order.delivery.zipcode}</td></tr>
  <tr><th>배송메모</th><td>${order.delivery.memo}</td></tr>
  <tr><th>배송상태</th><td>${order.delivery.status_code}</td></tr>
  <tr><th>운송장번호</th><td>${order.delivery.tracking_number}</td></tr>
</table>

<p>
  <a href="${pageContext.request.contextPath}/admin/orders_list">← 목록으로</a>
</p>

<!-- ✅ 스타일 -->
<style>
.detail-table {
  width: 100%;
  border-collapse: collapse;
  margin-bottom: 30px;
  font-family: 'Noto Sans KR', sans-serif;
}
.detail-table th,
.detail-table td {
  border: 1px solid #ccc;
  padding: 10px;
  text-align: left;
}
.detail-table th {
  background-color: #f5f5f5;
  width: 150px;
  white-space: nowrap;
}
</style>


<%-- 4. 하단 푸터를 불러옵니다. --%>
<%@ include file="include/footer.jsp" %> 