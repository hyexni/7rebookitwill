<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>
<%@ include file="/WEB-INF/views/include/header.jsp" %>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<form id="paymentForm" action="${pageContext.request.contextPath}/payment/process" 
		method="post" class="payment-wrapper" onsubmit="return validateForm()">

	<!-- ✅ 이 줄 추가 -->
  <input type="hidden" name="book_id" value="${book.book_id}">
  <input type="hidden" name="pay_method" value="카드결제">
  <input type="hidden" name="unit_price" value="${book.book_price}">

  <!-- 도서 정보 -->
  <div class="payment-left">
    <h3>${book.book_title} - <fmt:formatNumber value="${book.book_price}" type="number"/>원</h3>
    <img src="${pageContext.request.contextPath}/resources/img/product-img/${book.cover_image}" alt="도서 이미지" class="book-img">

    <div class="qty-box">
      <button type="button" onclick="changeQty(-1)">−</button>
      <input type="number" id="quantity" name="quantity" value="1" min="1">
      <button type="button" onclick="changeQty(1)">＋</button>
    </div>

    <p><strong>총 금액:</strong> <span id="totalPrice"><fmt:formatNumber value="${book.book_price}" type="number"/></span>원</p>
  </div>

  <!-- 배송 / 결제 정보 -->
  <div class="payment-right">
    <h3><i class="fa fa-truck"></i> 배송 정보 입력</h3>

    <label for="receiver_name">수령인</label>
    <input type="text" name="receiver_name" id="receiver_name" value="<c:out value='${member.member_name}' default='회원' />" required>

    <label for="receiver_phone">연락처</label>
    <input type="text" name="receiver_phone" id="receiver_phone" value="${member.member_phone}" required>

    <label for="zipcode">우편번호</label>
    <div class="zipcode-wrap">
      <input type="text" name="zipcode" id="zipcode" readonly required>
      <button type="button" onclick="execDaumPostcode()">우편번호 검색</button>
    </div>

    <label for="delivery_address">주소</label>
    <input type="text" id="delivery_address" name="delivery_address" value="${member.member_address}" required>

    <label for="address_detail">상세 주소</label>
    <input type="text" id="address_detail" name="address_detail" value="${member.member_address_detail}" required>

    <label for="memo">배송 메모</label>
    <input type="text" name="memo" id="memo" placeholder="배송 메모">

    <label for="usedPoints">보유 포인트: <strong>${point_total}P</strong></label>
    <div class="point-box">
      <input type="number" id="usedPoints" name="used_points" value="0">
      <button type="button" onclick="useAllPoints()">전액 사용</button>
    </div>

    <p><strong>실 결제 금액:</strong> <span id="payAmount">${book.book_price}</span>원</p>
    <input type="hidden" name="pay_amount" id="payAmountInput" value="${book.book_price}">
    <!-- 아래 코드 추가 (총 결제 금액 계산용 hidden input) -->
	<input type="hidden" id="quantityHidden" name="quantityHidden" value="1">
    

    <div class="btn-wrap">
      <button type="submit" class="btn-primary">카드결제</button>
      <button type="button" class="btn-yellow" id="kakaoPayBtn">간편결제 (카카오페이, 토스페이 등)</button>
    </div>
  </div>
</form>


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

   document.addEventListener("DOMContentLoaded", function () {	
	  document.getElementById("usedPoints").addEventListener("input", updateFinalPayment);
	  document.getElementById("quantity").addEventListener("input", function () {
	    document.getElementById('quantityHidden').value = this.value;
	    updateFinalPayment();
	  });
	  
	  document.getElementById("kakaoPayBtn").addEventListener("click", function () {
		    if (!validateForm()) return;
		  	  const receiverName = document.querySelector("input[name='receiver_name']").value.trim();
		   	  const orderName = receiverName ? receiverName + " 님의 도서 결제" : "회원 님의 도서 결제";
			  const receiverPhone = document.querySelector("input[name='receiver_phone']").value.trim();
			  const zipcode = document.querySelector("input[name='zipcode']").value.trim();
			  const address = document.querySelector("input[name='delivery_address']").value.trim();
			  const addressDetail = document.querySelector("input[name='address_detail']").value.trim();
		      const deliveryMemo = document.querySelector("input[name='memo']").value;

			  // ✅ 필수 입력값 누락 시 경고
			  if (!receiverName) {
			    alert("수령인을 입력해주세요.");
			    return;
			  }
			  if (!receiverPhone) {
			    alert("연락처를 입력해주세요.");
			    return;
			  }
			  if (!zipcode) {
			    alert("우편번호를 입력해주세요.");
			    return;
			  }
			  if (!address) {
			    alert("주소를 입력해주세요.");
			    return;
			  }
			  if (!addressDetail) {
			    alert("상세 주소를 입력해주세요.");
			    return;
			  }
			
			
			
		    const tossPayments = TossPayments("test_ck_QbgMGZzorzbnn21e2EpNrl5E1em4");
		    const bookId = ${book.book_id};
		    const quantity = parseInt(document.getElementById("quantity").value || "1");
		    const usedPoints = parseInt(document.getElementById("usedPoints").value || "0");
		    const realAmount = unitPrice * quantity - usedPoints;


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
		      + '&delivery_address=' + encodeURIComponent(address)
		      + '&address_detail=' + encodeURIComponent(addressDetail)
		      + '&memo=' + encodeURIComponent(deliveryMemo)
		      + '&pay_amount=' + realAmount
		      + '&pay_method=' + encodeURIComponent('간편결제'); // ✅ 이거 추가

		    tossPayments.requestPayment('카카오페이', {
		      amount: realAmount,
		      orderId: 'order-' + new Date().getTime(),
		      orderName,
		      customerName: receiverName,
		      successUrl: successUrl,
		      failUrl: 'http://localhost:8088/payment/fail'
		    });
		  });  
  	 });
</script>

<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
  function execDaumPostcode() {
    new daum.Postcode({
      oncomplete: function(data) {
        document.getElementById("zipcode").value = data.zonecode;
        document.getElementById("delivery_address").value = data.roadAddress;
        document.getElementById("address_detail").focus();
      }
    }).open();
  }
</script>

<script src="https://js.tosspayments.com/v1/payment"></script>


	<!-- 유효성 검사 -->
	<script>
	  function validateForm() {
	    const requiredFields = [
	      { id: 'receiver_name', label: '수령인' },
	      { id: 'receiver_phone', label: '연락처' },
	      { id: 'zipcode', label: '우편번호' },
	      { id: 'delivery_address', label: '주소' },
	      { id: 'address_detail', label: '상세 주소' }
	    ];
	
	    for (const field of requiredFields) {
	    	  const el = document.getElementById(field.id);
	    	  
	    	  if (!el) {
	    	    alert(`[${field.id}] 요소를 찾을 수 없습니다.`);
	    	    return false;
	    	  }
	
	    	  if (!el.value.trim()) {
	    	    alert(`${field.label}을(를) 입력해주세요.`);
	    	    el.focus();
	    	    return false;
	   	 	 }
	   	}
	
	    
	    // ✅ 전화번호 형식 검사 (숫자만, 10~11자리)
	    const phoneValue = document.getElementById("receiver_phone").value.replace(/[^0-9]/g, "");
	    if (phoneValue.length < 10 || phoneValue.length > 11) {
	      alert("연락처는 10~11자리 숫자로 입력해주세요.");
	      document.getElementById("receiver_phone").focus();
	      return false;
	    }
	
	    return true;
	  }
	</script>








<%@ include file="/WEB-INF/views/include/footer.jsp" %>