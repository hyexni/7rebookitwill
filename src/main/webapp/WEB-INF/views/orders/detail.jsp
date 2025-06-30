<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>
<%@ include file="/WEB-INF/views/include/header.jsp" %>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>

<div class="order-detail-wrapper">
  <div class="order-detail-header">
  <h2 class="order-title">🧾 주문 상세 정보</h2>
  <a href="${pageContext.request.contextPath}/orders/list" class="back-btn">← 주문 목록으로 돌아가기</a>
</div>

	<!-- 책 정보 -->
	<div class="section">
	  <div class="book-info">
	    <!-- 📌 책 이미지 클릭 시 상세 페이지로 이동 -->
	    <a href="${pageContext.request.contextPath}/book/view?book_id=${order.book_id}">
	    <img 
		  src="${pageContext.request.contextPath}/resources/img/product-img/${order.book_cover}" 
		  onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/resources/img/product-img/placeholder.png'" 
		  alt="${order.book_title}" 
		  class="book-cover-clickable" />
	    </a>
	
	    <div class="book-text-info">
	      <p class="book-title"><strong>제목:</strong> ${order.book_title}</p>
	      <p class="book-count"><strong>수량:</strong> ${order.book_count}권</p>
	
	      <p class="order-status">📄 주문 상태: <strong>${order.status}</strong></p>
	      <p class="delivery-status">🚚 배송 상태: <strong>${order.delivery.status_code}</strong></p>
	    	<c:if test="${not empty order.delivery.status_code}">
			  <div class="shipping-info">
			    <p><strong>택배사:</strong> ${order.delivery.shipper_name}</p>
			    <p><strong>송장번호:</strong> ${order.delivery.tracking_number}</p>
			  </div>
			</c:if>
	    	</div>
	  </div>
	</div>

  <!-- 기타 -->
  <div class="section">
    <h3>📅 주문 정보</h3>
    <p><strong>주문 번호:</strong> ${order.order_id}</p>
    <p><strong>주문일:</strong> <fmt:formatDate value="${order.order_date}" pattern="yyyy-MM-dd HH:mm:ss" /></p>
  </div>

  <!-- 결제 정보 -->
  <div class="section">
    <h3>💳 결제 정보</h3>
    <p><strong>총 결제 금액:</strong> <fmt:formatNumber value="${order.total_price}" type="currency" currencySymbol="₩" /></p>
    <p><strong>결제 수단:</strong> ${order.payment_method}</p>
    <p><strong>사용 포인트:</strong> ${order.used_point} P</p>
    <p><strong>적립 포인트:</strong> ${order.earned_point} P</p>
  </div>

  <!-- 배송 정보 -->
  <div class="section">
    <h3>🚚 배송 정보</h3>
    <p><strong>수령인:</strong> ${order.delivery.receiver_name}</p>
    <p><strong>연락처:</strong> ${order.delivery.receiver_phone}</p>
    <p><strong>우편번호:</strong>
      <c:if test="${not empty order.delivery.zipcode}">
        [${order.delivery.zipcode}]
      </c:if>
    </p>
    <p><strong>주소:</strong> ${order.delivery.delivery_address} ${order.delivery.address_detail}</p>
    <p><strong>배송 메모:</strong> ${order.delivery.memo}</p>
  </div>


</div>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>

<style>

<style>
.order-detail-wrapper {
  max-width: 750px;
  margin: 50px auto;
  padding: 35px;
  background-color: #ffffff;
  border-radius: 12px;
  box-shadow: 0 5px 20px rgba(0, 0, 0, 0.05);
  font-size: 15px;
  color: #333;
}

.order-title {
  font-size: 24px;
  margin-bottom: 30px;
  color: #222;
  font-weight: bold;
}

.section {
  margin-bottom: 30px;
  border-bottom: 1px solid #eee;
  padding-bottom: 20px;
}

.section h3 {
  font-size: 18px;
  margin-bottom: 12px;
  color: #444;
  border-left: 4px solid #ffd700;
  padding-left: 10px;
}

/* ✅ 책 정보 전체 박스 */
.book-info {
  display: flex;
  align-items: flex-start;
  gap: 24px;
}

/* ✅ 이미지 클릭 가능하게 */
.book-info a img {
  width: 120px;
  height: auto;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
  transition: transform 0.2s ease;
  cursor: pointer;
}
.book-info a img:hover {
  transform: scale(1.05);
}

/* ✅ 텍스트 부분 */
.book-info-text {
  display: flex;
  flex-direction: column;
  gap: 6px;
}
.book-info-text p {
  margin: 4px 0;
  font-size: 1.1rem;
  font-weight: 500;
}
.book-info-text .book-title {
  font-size: 1.3rem;
  font-weight: bold;
  color: #111;
}
.book-info-text .book-count {
  font-size: 1.1rem;
  color: #444;
}

.order-status, .delivery-status {
  font-size: 1.1rem;
  font-weight: bold;
  color: #222;
  margin-top: 8px;
}

.order-detail-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
}

.back-btn {
  font-size: 14px;
  padding: 6px 12px;
  background-color: #fff3cd;
  border: 1px solid #ffeeba;
  border-radius: 6px;
  color: #856404;
  font-weight: bold;
  text-decoration: none;
  transition: all 0.2s ease-in-out;
}
.back-btn:hover {
  background-color: #ffe8a1;
  
}
.shipping-info {
  margin-top: 8px;
  padding: 10px 14px;
  border-radius: 8px;
  border: 1px solid #ddd;
  background-color: #f9f9f9;
}
.shipping-info p {
  margin: 4px 0;
  font-size: 14px;
  color: #333;
}

</style>

