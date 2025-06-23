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


	<h2>결제 금액 확인 및 결제 방법 선택</h2>
	
	<!-- 1. 도서 정보 -->
	<p><strong>${book.book_title}</strong> - ${book.book_price}원</p>
	<img src="${pageContext.request.contextPath}/resources/img/product-img/${book.cover_image}" 
     alt="${book.book_title}" style="width:150px;"><br>
	
	<!-- 2. 총 금액 -->
	<p>총 금액: <span id="totalPrice">${book.book_price}</span>원</p>
	
	<!-- 3. 포인트 입력 -->
	<form action="${pageContext.request.contextPath}/payment/process" method="post">
	  <input type="hidden" name="book_id" value="${book.book_id}">
	  <input type="hidden" name="unit_price" value="${book.book_price}">
	  <input type="hidden" name="quantity" value="1">
	  
	  보유 포인트: ${member.point_total} <br>
	  포인트 사용: <input type="number" name="used_points" id="usedPoints" value="0">
	  <br>
	
	  <!-- 4. 결제 금액 -->
	  실 결제 금액: <span id="payAmount">${book.book_price}</span>원
	  <input type="hidden" name="pay_amount" id="payAmountInput" value="${book.book_price}">
	
	  <!-- 5. 결제 수단 -->
	  <br><br>결제 수단:
	  <label><input type="radio" name="pay_method" value="카드결제" checked> 카드결제</label>
	  <label><input type="radio" name="pay_method" value="카카오페이"> 카카오페이</label>
	
	  <br><br>
	  <!-- 6. 결제 버튼 -->
	  <button type="submit">결제하기</button>
	  <button type="button" onclick="history.back()">취소</button>
	</form>
	
	<script>
	  const bookPrice = ${book.book_price};
	  const pointMax = ${point_total};
	
	  document.getElementById("usedPoints").addEventListener("input", function() {
	    let used = parseInt(this.value || 0);
	    if (used > pointMax) {
	      alert("보유 포인트를 초과했습니다.");
	      used = pointMax;
	      this.value = used;
	    }
	    const result = bookPrice - used;
	    document.getElementById("payAmount").innerText = result;
	    document.getElementById("payAmountInput").value = result;
	  });
	</script>












<%-- 4. 하단 푸터를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>