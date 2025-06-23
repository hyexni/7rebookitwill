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


	<h2>주문이 완료되었습니다 🎉</h2>
	<p>주문해 주셔서 감사합니다!</p>
	
	<table border="1" cellpadding="10">
	  <tr>
	    <th>주문 번호</th>
	    <td>${summary.order_id}</td>
	  </tr>
	  <tr>
	    <th>결제 금액</th>
	    <td>${summary.pay_amount}원</td>
	  </tr>
	  <tr>
	    <th>결제 수단</th>
	    <td>${summary.pay_method}</td>
	  </tr>
	  <tr>
	    <th>사용 포인트</th>
	    <td>${summary.used_points}P</td>
	  </tr>
	  <tr>
	    <th>적립 포인트</th>
	    <td><c:out value="${summary.pay_amount * 0.1}" />P</td>
	  </tr>
	</table>
	
	<br>
	<p>적립된 포인트는 다음 구매 시 사용하실 수 있습니다.</p>
	<a href="${pageContext.request.contextPath}/">홈으로 가기</a>


















<%-- 4. 하단 푸터를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>s