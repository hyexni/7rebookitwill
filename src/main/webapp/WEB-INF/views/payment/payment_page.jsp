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

<div class="payment-container">
	<h2>결제 금액 확인 및 결제 방법 선택</h2>
	
	<!-- 1. 도서 정보 -->
	<p><strong>${book.book_title}</strong> - ${book.book_price}원</p>
	<img src="${pageContext.request.contextPath}/resources/img/product-img/${book.cover_image}" 
     alt="${book.book_title}" style="width:150px;"><br>
	
	<!-- 2. 수량 선택 -->
	<div class="qty-box">
	  <button type="button" class="qty-btn" onclick="changeQty(-1)">−</button>
	  <input type="number" id="quantity" name="quantity" value="1" min="1" class="qty-input">
	  <button type="button" class="qty-btn" onclick="changeQty(1)">＋</button>
	</div>
	<div class="total-price">
	  총 금액: <span id="totalPrice">${book.book_price}</span>원
	</div>	
	
	<!-- 3. 배송 정보 -->
	<div class="delivery-box">
		<h3>📦 배송 정보 입력</h3>
		<div class="form-group">
			<label>받는 사람</label>
			<input type="text" name="receiver_name" value="${member.member_name}" required><br>
		</div>
		<div class="form-group">
			<label>휴대폰 번호</label>
			<input type="text" name="receiver_phone"  value="${member.member_phone}" required><br>
		</div>
		<!-- 주소 검색 버튼 -->
		<div class="form-group">
			<input type="text" id="postcode" placeholder="우편번호" name="zipcode" readonly required>
			<button type="button" class="btn-sm" onclick="execDaumPostcode()">우편번호 검색</button><br>
		</div>
		<div class="form-group">
			<input type="text" id="address" placeholder="주소" name="address" value="${member.member_address}" readonly required><br>
			<input type="text" id="address_detail" placeholder="상세주소" name="address_detail" value="${member.member_address_detail}" required><br>
		</div>
		<div class="form-group">
			<label>배송 메모</label>
			<input type="text" name="delivery_memo" placeholder="예: 문 앞에 놔주세요"><br>
		</div>
	</div>
	
	<div class="form-group checkbox-group">
	  <label>
	    <input type="checkbox" name="saveDelivery" />
	    다음에도 이 배송지 정보를 사용하겠습니다.
	  </label>
	</div>
	
    <div class="form-group checkbox-group">
	  <label>
	    <input type="checkbox" name="agreeTerms" required />
	    결제 진행 시 <a href="/terms/payment" target="_blank" class="terms-link">결제 약관</a>에 동의합니다.
	  </label>
	</div>
	
	
	<!-- 4. 포인트 입력 -->
	<form action="${pageContext.request.contextPath}/payment/process" method="post" onsubmit="return validateForm()">
	  <input type="hidden" name="book_id" value="${book.book_id}">
	  <input type="hidden" name="unit_price" value="${book.book_price}">
	  <input type="hidden" name="quantity" value="1">
	  
	 <div class="point-section">
		  보유 포인트: <strong>${point_total}P</strong><br>
		  사용할 포인트: 
		  <input type="number" id="usedPoints" name="used_points" value="0">
		  <button type="button" class="btn-sm" onclick="useAllPoints()">전액 사용</button>
	 </div>

	
	  <!-- 5. 결제 금액 -->
	  실 결제 금액: <span id="payAmount">${book.book_price}</span>원
	  <input type="hidden" name="pay_amount" id="payAmountInput" value="${book.book_price}">
	
	  <!-- 6. 결제 수단 -->
	  <div class="payment-method">
		  결제 수단:
		  <label><input type="radio" name="pay_method" value="카드결제" checked> 카드결제</label>
		  <label><input type="radio" name="pay_method" value="카카오페이"> 카카오페이</label>
	  </div>

	  <!-- 7. 결제 버튼 -->
	  <div class="btn-wrap">
		  <button type="submit" class="btn btn-primary">결제하기</button>
		  <button type="button" class="btn btn-secondary" onclick="history.back()">취소</button>
	</form>
</div>	



	<!-- 수량 관련 -->
	<script>
	  const unitPrice = ${book.book_price}; // 도서 가격
	
	  function changeQty(delta) {
	    let qtyInput = document.getElementById('quantity');
	    let qty = parseInt(qtyInput.value || 1);
	    qty += delta;
	    if (qty < 1) qty = 1;
	    qtyInput.value = qty;
	
	    updateTotal();
	  }
	
	  function updateTotal() {
	    const qty = parseInt(document.getElementById("quantity").value);
	    const usedPoints = parseInt(document.getElementById("usedPoints").value || 0);
	    const total = unitPrice * qty;
	    document.getElementById("totalPrice").innerText = total;
	    document.getElementById("payAmount").innerText = total - usedPoints;
	    document.getElementById("payAmountInput").value = total - usedPoints;
	  }
	
	  // 수동 포인트 입력 시에도 반영
	  document.getElementById("usedPoints").addEventListener("input", updateTotal);
	  document.getElementById("quantity").addEventListener("input", updateTotal);
	</script>
	

	
	<!-- 주소 검색 -->
	<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script>
	  function execDaumPostcode() {
	    new daum.Postcode({
	      oncomplete: function(data) {
	        // 사용자가 선택한 주소를 입력창에 자동으로 설정
	        document.getElementById("postcode").value = data.zonecode;
	        document.getElementById("address").value = data.roadAddress;
	        document.getElementById("address_detail").focus();
	      }
	    }).open();
	  }
	</script>
	
	
	<!-- 보유 포인트 초과 -->
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

	<!-- 포인트 전액 사용 -->
	<script> // 포인트 전액 사용
	  function useAllPoints() {
	    const total = ${point_total};
	    document.getElementById("usedPoints").value = total;
	    
	 	// 👉 실 결제 금액도 즉시 반영되도록 추가
	    const result = bookPrice - total;
	    document.getElementById("payAmount").innerText = result;
	    document.getElementById("payAmountInput").value = result;
	  }
	</script>
	
	<script> // 사용자가 결제 금액보다 많은 포인트 입력했을 때 차단
	function validateForm() {
		  const used = parseInt(document.getElementById("usedPoints").value);
		  const total = ${point_total};
		  const price = ${book.book_price}; // 책 가격

		  if (used > total) {
		    alert("보유 포인트를 초과해서 사용할 수 없습니다.");
		    return false;
		  }
		  if (used > price) {
		    alert("결제 금액을 초과해서 포인트를 사용할 수 없습니다.");
		    return false;
		  }
		  return true;
		}
	</script>
		






</body>
</html>



