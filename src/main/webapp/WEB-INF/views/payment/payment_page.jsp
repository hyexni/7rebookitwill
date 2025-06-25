<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>
<%@ include file="/WEB-INF/views/include/header.jsp" %>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>

<div class="payment-container">
  <h2>결제 금액 확인 및 결제 방법 선택</h2>
	
	<form id="paymentForm" action="${pageContext.request.contextPath}/payment/process" method="post">
	    <input type="hidden" name="book_id" value="${book.book_id}">
	    <input type="hidden" name="unit_price" value="${book.book_price}">
	    <input type="hidden" name="quantity" id="quantityHidden" value="1">
	
	<p><strong>${book.book_title}</strong> - ${book.book_price}원</p>
	    <img src="${pageContext.request.contextPath}/resources/img/product-img/${book.cover_image}" style="width:150px;"><br>
	
	    <div class="qty-box">
	      <button type="button" onclick="changeQty(-1)">−</button>
	      <input type="number" id="quantity" name="quantity" value="1" min="1">
	      <button type="button" onclick="changeQty(1)">＋</button>
	    </div>
	
	    <div>
	      총 금액: <span id="totalPrice">${book.book_price}</span>원
	    </div>
	
	    <h3>📦 배송 정보 입력</h3>
	    <input type="text" name="receiver_name" value="${member.member_name}" required><br>
	    <input type="text" name="receiver_phone" value="${member.member_phone}" required><br>
	    <input type="text" id="postcode" name="zipcode" readonly required>
	    <button type="button" onclick="execDaumPostcode()">우편번호 검색</button><br>
	    <input type="text" id="address" name="delivery_address" value="${member.member_address}" readonly required><br>
	    <input type="text" id="address_detail" name="address_detail" value="${member.member_address_detail}" required><br>
	    <input type="text" name="memo" placeholder="배송 메모"><br>
	
	    <div>
	      보유 포인트: <strong>${point_total}P</strong><br>
	      사용할 포인트: <input type="number" id="usedPoints" name="used_points" value="0">
	      <button type="button" onclick="useAllPoints()">전액 사용</button>
	    </div>
	
	    <div>
	      실 결제 금액: <span id="payAmount">${book.book_price}</span>원
	      <input type="hidden" name="pay_amount" id="payAmountInput" value="${book.book_price}">
	    </div>
	
	    <div>
	      결제 수단:
	      <label><input type="radio" name="pay_method" value="카드결제" checked> 카드결제</label>
	      <label><input type="radio" name="pay_method" value="카카오페이">카카오페이</label>
	    </div>
	
	    <div class="btn-wrap">
	      <button type="submit" class="btn btn-primary">카드결제</button>
	      <button type="button" class="btn btn-yellow" id="kakaoPayBtn">카카오페이 결제</button>
	    </div>
	  </form>
</div>
	
	

	<script>
	  const unitPrice = ${book.book_price};
	  const pointMax = ${point_total};
	
	  function changeQty(delta) {
	    let qtyInput = document.getElementById('quantity');
	    let qty = parseInt(qtyInput.value || 1);
	    qty += delta;
	    if (qty < 1) qty = 1;
	    qtyInput.value = qty;
	    document.getElementById('quantityHidden').value = qty;
	    updateFinalPayment();
	  }
	
	  function updateFinalPayment() {
	    const qty = parseInt(document.getElementById("quantity").value || 1);
	    let usedPoints = parseInt(document.getElementById("usedPoints").value || 0);
	    const total = unitPrice * qty;
	
	    if (usedPoints < 0) usedPoints = 0;
	    if (usedPoints > pointMax) usedPoints = pointMax;
	    if (usedPoints > total) usedPoints = total;
	
	    document.getElementById("usedPoints").value = usedPoints;
	    document.getElementById("totalPrice").innerText = total;
	    const result = total - usedPoints;
	    document.getElementById("payAmount").innerText = result;
	    document.getElementById("payAmountInput").value = result;
	  }
	
	  function useAllPoints() {
	    document.getElementById("usedPoints").value = pointMax;
	    updateFinalPayment();
	  }
	
	  document.getElementById("usedPoints").addEventListener("input", updateFinalPayment);
	  document.getElementById("quantity").addEventListener("input", function () {
	    document.getElementById('quantityHidden').value = this.value;
	    updateFinalPayment();
	  });
	</script>
	
	<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script>
	  function execDaumPostcode() {
	    new daum.Postcode({
	      oncomplete: function(data) {
	        document.getElementById("postcode").value = data.zonecode;
	        document.getElementById("address").value = data.roadAddress;
	        document.getElementById("address_detail").focus();
	      }
	    }).open();
	  }
	</script>
	
	<script src="https://js.tosspayments.com/v1/payment"></script>
	<script>
	document.getElementById("kakaoPayBtn").addEventListener("click", function () {
		  const tossPayments = TossPayments("test_ck_QbgMGZzorzbnn21e2EpNrl5E1em4");

		  const bookId = ${book.book_id};
		  const quantity = parseInt(document.getElementById("quantity").value || "1");
		  const usedPoints = parseInt(document.getElementById("usedPoints").value || "0");
		  const realAmount = unitPrice * quantity - usedPoints;

		  const receiverName = document.querySelector("input[name='receiver_name']").value;
		  const receiverPhone = document.querySelector("input[name='receiver_phone']").value;
		  const zipcode = document.querySelector("input[name='zipcode']").value;
		  const address = document.querySelector("input[name='delivery_address']").value;
		  const addressDetail = document.querySelector("input[name='address_detail']").value;
		  const deliveryMemo = document.querySelector("input[name='memo']").value;

		  if (realAmount <= 0) {
		    alert("실 결제 금액은 0원 이상이어야 합니다.");
		    return;
		  }

		  const successUrl = 'http://localhost:8088/payment/success'
		    + '?book_id=' + bookId
		    + '&unit_price=' + unitPrice
		    + '&quantity=' + quantity
		    + '&used_points=' + usedPoints
		    + '&receiver_name=' + encodeURIComponent(receiverName)
		    + '&receiver_phone=' + encodeURIComponent(receiverPhone)
		    + '&zipcode=' + encodeURIComponent(zipcode)
		    + '&address=' + encodeURIComponent(address)
		    + '&address_detail=' + encodeURIComponent(addressDetail)
		    + '&memo=' + encodeURIComponent(deliveryMemo);

		  tossPayments.requestPayment('카카오페이', {
		    amount: realAmount,
		    orderId: 'order-' + new Date().getTime(),
		    orderName: `${receiverName} 님의 도서 결제`,
		    customerName: receiverName,
		    successUrl: successUrl,
		    failUrl: 'http://localhost:8088/payment/fail'
		  });
		});
	</script>























<%@ include file="/WEB-INF/views/include/footer.jsp" %>
