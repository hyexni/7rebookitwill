<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="include/layout_head.jsp" %>
<%@ include file="include/header.jsp" %>
<%@ include file="include/sidebar.jsp" %>
<%@ include file="/WEB-INF/views/include/alert.jsp" %>


<main class="main-content">
  <h2>📦 주문 상세 페이지</h2>

<div class="back-btn-wrap">
  <a href="${pageContext.request.contextPath}/admin/orders_list" class="back-btn">← 주문 목록으로</a>
</div>

  <!-- ✅ 1. 도서 정보 카드 -->
  <div class="book-info">
    <img 
  src="/upload/books/${order.book_cover}" 
  onerror="this.src='${pageContext.request.contextPath}/resources/img/product-img/placeholder.png'" 
  alt="${order.book_title}" />
    <div class="book-text">
      <h3>${order.book_title}</h3>
      <p>수량: ${order.book_count}권</p>
      <p>가격: <fmt:formatNumber value="${order.total_price}" type="currency" /></p>
    </div>
  </div>

  <!-- ✅ 2. 결제 상태 변경 -->
  <form method="post" action="${pageContext.request.contextPath}/admin/orders/updateStatus">
    <input type="hidden" name="order_id" value="${order.order_id}" />
    
    <label for="status">결제 상태 변경</label>
    <select name="status" id="status">
      <option value="결제완료" ${order.status eq '결제완료' ? 'selected' : ''}>결제완료</option>
      <option value="결제대기" ${order.status eq '결제대기' ? 'selected' : ''}>결제대기</option>
      <option value="결제취소" ${order.status eq '결제취소' ? 'selected' : ''}>결제취소</option>
    </select>
    
    <button type="submit" class="btn-update">변경</button>
  </form>

  <hr/>

  <!-- ✅ 3. 주문 정보 -->
  <section class="order-section">
    <h4>🧾 주문 정보</h4>
    <table class="info-table">
      <tr><th>주문번호</th><td>${order.order_id}</td></tr>
      <tr><th>주문일자</th><td><fmt:formatDate value="${order.order_date}" pattern="yyyy-MM-dd"/></td></tr>
      <tr><th>결제 방법</th><td>${order.payment_method}</td></tr>
      <tr><th>사용 포인트</th><td>${order.used_point} P</td></tr>
      <tr><th>적립 포인트</th><td>${order.earned_point} P</td></tr>
      <tr><th>주문자</th><td>${order.member_name} (${order.member_id})</td></tr>
    </table>
  </section>

  <!-- ✅ 4. 배송 정보 -->
  <section class="order-section">
    <h4>🚚 배송 정보</h4>
    <table class="info-table">
      <tr><th>수령인</th><td>${order.delivery.receiver_name}</td></tr>
      <tr><th>연락처</th><td>${order.delivery.receiver_phone}</td></tr>
      <tr><th>주소</th><td>[${order.delivery.zipcode}] ${order.delivery.delivery_address} ${order.delivery.address_detail}</td></tr>
      <tr><th>배송 요청사항</th><td>${order.delivery.memo}</td></tr>
    </table>
  </section>
</main>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>

<style>

/* 주문 상세 타이틀 */
.main-content > h2 {
  font-size: 2rem;
  margin-bottom: 10px;
  font-weight: bold;
}

/* 돌아가기 버튼 */
.back-btn {
  display: inline-block;
  margin-bottom: 30px;
  background-color: #f4a261;
  color: white;
  padding: 8px 16px;
  border-radius: 6px;
  font-size: 0.95rem;
  text-decoration: none;
  transition: background-color 0.2s ease;
}
.back-btn:hover {
  background-color: #e76f51;
}

/* 도서 정보 카드 */
.book-info {
  display: flex;
  gap: 20px;
  margin-bottom: 30px;
  align-items: center;
  padding: 20px;
  background-color: #fafafa;
  border: 1px solid #ddd;
  border-radius: 10px;
}
.book-info img {
  width: 130px;
  border-radius: 8px;
}
.book-text h3 {
  font-size: 1.5rem;
  margin-bottom: 8px;
}
.book-text p {
  margin: 6px 0;
  font-size: 1.1rem;
  color: #333;
}

/* 결제 상태 변경 폼 */
form {
  margin: 20px 0;
  display: flex;
  align-items: center;
  gap: 10px;
}
form label {
  font-weight: bold;
}
form select {
  padding: 6px 10px;
  border-radius: 5px;
  border: 1px solid #ccc;
}
.btn-update {
  background-color: #264653;
  color: white;
  padding: 7px 16px;
  border: none;
  border-radius: 5px;
  font-weight: bold;
  cursor: pointer;
  transition: background-color 0.2s ease;
}
.btn-update:hover {
  background-color: #1d3557;
}

/* 구분선 */
hr {
  margin: 30px 0;
  border: none;
  border-top: 1px solid #ddd;
}

/* 섹션 헤더 */
.order-section {
  margin-top: 40px;
}
.order-section h4 {
  font-size: 1.3rem;
  margin-bottom: 12px;
  border-left: 5px solid #f4a261;
  padding-left: 10px;
  font-weight: bold;
}

/* 테이블 스타일 */
.info-table {
  width: 100%;
  border-collapse: collapse;
  background-color: #fff;
  border: 1px solid #ddd;
  border-radius: 8px;
  overflow: hidden;
}
.info-table th,
.info-table td {
  text-align: left;
  padding: 12px 16px;
  border-bottom: 1px solid #eee;
}
.info-table th {
  width: 160px;
  background-color: #f9f9f9;
  color: #333;
}
.info-table td {
  color: #444;
  font-size: 1rem;
}

.back-btn-wrap {
  display: flex;
  justify-content: flex-end;
  margin-bottom: 20px;
}


</style>
