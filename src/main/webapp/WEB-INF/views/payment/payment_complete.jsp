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



<div class="container" style="text-align:center; padding: 50px; font-family: 'Noto Sans KR', sans-serif;">
    
    <h1 style="font-size: 32px;">주문이 완료되었습니다 🎉</h1>
    <p style="margin-bottom: 30px;">소중한 주문 감사합니다!</p>
    
    <c:if test="${not empty errorMsg}">
	  <div style="color:red; font-weight:bold; margin-bottom:20px;">⚠️ ${errorMsg}</div>
	</c:if>

    <table style="margin: 0 auto; border-collapse: collapse; font-size: 16px;">
        <tr>
        	<td style="border: 1px solid #ddd; padding: 8px;">주문 번호</td>
   		    <td style="border: 1px solid #ddd; padding: 8px;">${orders.order_id}</td>
   		</tr>
        <tr>
        	<td style="border: 1px solid #ddd; padding: 8px;">결제 금액</td>
        	<td style="border: 1px solid #ddd; padding: 8px;"><fmt:formatNumber value="${orders.total_price}" type="currency" currencySymbol="₩"/></td>
       	</tr>
        <tr>
        	<td style="border: 1px solid #ddd; padding: 8px;">결제 수단</td>
        	<td style="border: 1px solid #ddd; padding: 8px;">
			  <c:choose>
			    <c:when test="${payment.pay_method eq '카카오페이'}"> ${payment.pay_method}</c:when>
			    <c:otherwise>${payment.pay_method}</c:otherwise>
			  </c:choose>
			</td>
       	</tr>
        <tr>
        	<td style="border: 1px solid #ddd; padding: 8px;">사용 포인트</td>
        	<td style="border: 1px solid #ddd; padding: 8px;">${payment.used_points}P</td>
       	</tr>
        <tr>
       		<td style="border: 1px solid #ddd; padding: 8px;">적립 포인트</td>
       		<td style="border: 1px solid #ddd; padding: 8px;">${payment.saved_points}P</td>
     	</tr>
        <tr>
        	<td style="border: 1px solid #ddd; padding: 8px;">결제 일시</td>
        	<td style="border: 1px solid #ddd; padding: 8px;"><fmt:formatDate value="${payment.paid_at}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
       	</tr>
    </table>

    <br>


    <p style="margin-top: 30px; font-weight:bold;">
	  🎁 이번 주문으로 <span style="color:#007bff;">${payment.saved_points}P</span>가 적립되었습니다!<br>
	  다음 구매 시 사용 가능합니다 😊
	</p>
	
	<h3 style="margin-top: 50px; font-size: 20px;">📦 배송 정보</h3>

	<table style="margin: 0 auto; border-collapse: collapse; font-size: 16px; min-width: 400px;">
	  <tr>
	    <th style="background-color: #f5f5f5; border: 1px solid #ccc; padding: 10px;">수령인</th>
	    <td style="border: 1px solid #ccc; padding: 10px;">${delivery.receiver_name}</td>
	  </tr>
	  <tr>
	    <th style="background-color: #f5f5f5; border: 1px solid #ccc; padding: 10px;">연락처</th>
	    <td style="border: 1px solid #ccc; padding: 10px;">${delivery.receiver_phone}</td>
	  </tr>
	  <tr>
	    <th style="background-color: #f5f5f5; border: 1px solid #ccc; padding: 10px;">주소</th>
	    <td style="border: 1px solid #ccc; padding: 10px;">
	      (${delivery.zipcode}) ${delivery.delivery_address} ${delivery.address_detail}
	    </td>
	  </tr>
	  <tr>
		 <th style="background-color: #f5f5f5; border: 1px solid #ccc; padding: 10px;">배송 메모</th>
		  <td style="border: 1px solid #ccc; padding: 10px;">
		    <c:choose>
		      <c:when test="${empty delivery.memo}">
		        없음
		      </c:when>
		      <c:otherwise>
		        ${delivery.memo}
		      </c:otherwise>
		    </c:choose>
		  </td>
		</tr>
	</table>
	
    <div style="margin-top: 40px;">
        <a href="/" style="margin-right: 20px; text-decoration: none; color: #333;">🏠 홈으로 가기</a>
        <a href="/mypage/orders" style="text-decoration: none; color: #0066cc;">📦 주문 상세 보기</a>
    </div>
    
    <div style="margin-top: 20px;">
	  <a href="/mypage/payments" style="text-decoration: none; color: #0055cc; font-weight: bold;">💳 결제 내역 바로가기</a>
	</div>
    
</div>





<%-- 4. 하단 푸터를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>