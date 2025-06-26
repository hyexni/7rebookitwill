<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>
<%@ include file="/WEB-INF/views/include/header.jsp" %>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/order.css" />

<div class="order-detail-container">
  <h2>🧾 관리자 주문 상세 정보</h2>

  <!-- 🧍 회원 정보 -->
  <div class="order-member-info">
    <p><strong>회원 번호:</strong> ${order.member_idx}</p>
  </div>

  <!-- 📘 책 정보 -->
  <div class="order-book-info">
    <img src="${pageContext.request.contextPath}/resources/img/product-img/${order.book_cover}" alt="책 표지" class="book-cover" />
    <div class="book-meta">
      <p><strong>제목:</strong> ${order.book_title}</p>
      <p><strong>수량:</strong> ${order.book_count}권</p>
    </div>
  </div>

  <!-- 💳 결제 정보 -->
  <div class="order-payment-info">
    <h3>💰 결제 정보</h3>
    <p><strong>총 결제 금액:</strong> <fmt:formatNumber value="${order.total_price}" type="currency" currencySymbol="₩" /></p>
    <p><strong>결제 수단:</strong> ${order.payment_method}</p>
    <p><strong>사용 포인트:</strong> ${order.used_point} P</p>
    <p><strong>적립 포인트:</strong> ${order.earned_point} P</p>
  </div>

  <!-- 🚚 배송 정보 -->
  <div class="order-delivery-info">
    <h3>📦 배송 정보</h3>
    <p><strong>수령인:</strong> ${order.receiver_name}</p>
    <p><strong>연락처:</strong> ${order.receiver_phone}</p>
    <p><strong>주소:</strong> [${order.zipcode}] ${order.delivery_address} ${order.address_detail}</p>
    <p><strong>배송 메모:</strong> ${order.memo}</p>
    <p><strong>배송 상태 코드:</strong> ${order.status_code}</p>
  </div>

  <!-- 기타 주문 정보 -->
  <div class="order-etc">
    <p><strong>주문 번호:</strong> ${order.order_id}</p>
    <p><strong>주문일:</strong> <fmt:formatDate value="${order.order_date}" pattern="yyyy-MM-dd HH:mm:ss" /></p>
    <p><strong>주문 상태:</strong> ${order.status}</p>
  </div>
</div>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>

<style>

.order-detail-container {
  max-width: 800px;
  margin: 40px auto;
  padding: 30px;
  border: 1px solid #ddd;
  background-color: #fefefe;
  border-radius: 10px;
}

.order-book-info {
  display: flex;
  gap: 20px;
  margin-bottom: 20px;
}
.order-book-info img {
  width: 120px;
  border-radius: 4px;
}
.order-payment-info, .order-delivery-info, .order-etc {
  margin-bottom: 20px;
}


</style>
