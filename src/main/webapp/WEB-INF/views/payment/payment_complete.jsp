<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> <%-- JSTL functions 라이브러리 추가 --%>

<%-- 1. 페이지 기본 골격과 공통 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>

<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/header.jsp" %>

<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/payment.css">

<!-- ✅ 주문 완료 페이지 내용 -->
<div class="order-complete-container">
    
    <h1>주문이 완료되었습니다 🎉</h1>
    <p>소중한 주문 감사합니다!</p>
    
    <c:if test="${not empty errorMsg}">
	  <div style="color:red; font-weight:bold; margin-bottom:20px;">⚠️ ${errorMsg}</div>
	</c:if>

    <!-- 💳 결제 정보 -->
    <div class="order-box">
      <h3>💳 결제 정보</h3>
      <table>
        <tr><th>주문 번호</th><td>${orders.order_id}</td></tr>
        <tr>
        	<th>결제 금액</th>
        	<td><fmt:formatNumber value="${payment.pay_amount}" type="currency" currencySymbol="₩"/></td>
       	</tr>
        <tr>
        	<th>결제 수단</th>
        	<td>
        		<c:choose>
				    <c:when test="${payment.pay_method eq '카카오페이'}"> ${payment.pay_method}</c:when>
				    <c:otherwise>${payment.pay_method}</c:otherwise>
			    </c:choose>
			</td>
		</tr>
        <tr><th>사용 포인트</th><td>${payment.used_points}P</td></tr>
        <tr><th>적립 포인트</th><td>${payment.saved_points}P</td></tr>
        <tr><th>결제 일시</th><td><fmt:formatDate value="${payment.paid_at}" pattern="yyyy-MM-dd HH:mm:ss"/></td></tr>
      </table>
      
      <p style="margin-top: 20px; font-weight:bold;">
        🎁 이번 주문으로 <span style="color:#007bff;">${payment.saved_points}P</span>가 적립되었습니다!<br>
        다음 구매 시 사용 가능합니다 😊
      </p>
    </div>

    <!-- 📦 배송 정보 -->
    <div class="order-box">
      <h3>📦 배송 정보</h3>
      <table>
        <tr><th>수령인</th><td>${delivery.receiver_name}</td></tr>
        <tr><th>연락처</th><td>${delivery.receiver_phone}</td></tr>
        <tr><th>주소</th><td>(${delivery.zipcode}) ${delivery.delivery_address} ${delivery.address_detail}</td></tr>
        <tr><th>배송 메모</th>
          <td>
            <c:choose>
              <c:when test="${empty delivery.memo}">없음</c:when>
              <c:otherwise>${delivery.memo}</c:otherwise>
            </c:choose>
          </td>
        </tr>
      </table>
    </div>

    <!-- 🔗 링크들 -->
    <div class="order-links">
      <a href="/">🏠 홈으로 가기</a>
      <a href="/mypage/orders">📦 주문 상세 보기</a>
      <a href="/mypage/payments">💳 결제 내역 바로가기</a>
    </div>
</div>





<%-- 4. 하단 푸터를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>