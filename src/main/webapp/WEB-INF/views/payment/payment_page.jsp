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
	<input type="tel" name="receiver_phone" id="receiver_phone"
       value="${member.member_phone}"
       placeholder="예: 010-1234-5678"
       pattern="^01[016789]-\d{3,4}-\d{4}$"
       required>
	       
    <label for="zipcode">우편번호</label>
    <div class="zipcode-wrap">
      <input type="text" name="zipcode" id="zipcode" readonly>
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
      <input type="number" id="usedPoints" name="used_points" value="0" min="0"
       max="${point_total}">
      <button type="button" onclick="useAllPoints()">전액 사용</button>
    </div>

    <p style="margin-top: 16px;">
    	<strong>실 결제 금액:</strong> 
    	<span id="payAmount" class="pay-final-price">
    	  <fmt:formatNumber value="${book.book_price}" type="number"/>
    	</span>원
   	</p>
   	
    <input type="hidden" name="pay_amount" id="payAmountInput" value="${book.book_price}">
    <!-- 아래 코드 추가 (총 결제 금액 계산용 hidden input) -->
	<input type="hidden" id="quantityHidden" name="quantityHidden" value="1">
    

    <div class="btn-wrap">
      <button type="submit" class="btn-primary">카드결제</button>
      <button type="button" class="btn-yellow" id="kakaoPayBtn">간편결제 (카카오페이, 토스페이 등)</button>
    </div>
  </div>
</form>

<style>
.pay-final-price {
  font-size: 22px;
  font-weight: 700;
  color: #343a40; /* 진한 그레이, 명도 대비 좋음 */
  margin-left: 4px;
}
</style>


<script src="https://js.tosspayments.com/v1/payment"></script>

	<script>
	  const unitPrice = ${book.book_price};
	  const pointMax = ${point_total};
	  
		  // validateForm 유효성 검사
		 function validateForm() {
		  // ① 모든 입력 칸 border 초기화
		  const inputs = document.querySelectorAll(
		    '#receiver_name, #receiver_phone, #zipcode, #delivery_address, #address_detail'
		  );
		  inputs.forEach(i => i.style.borderColor = '#ccc');
		
		  // ② 필수 항목 정의
		  const requiredFields = [
		    { id: 'receiver_name',  label: '수령인' },
		    { id: 'receiver_phone', label: '연락처' },
		    { id: 'zipcode',        label: '우편번호' },
		    { id: 'delivery_address', label: '주소' },
		    { id: 'address_detail',   label: '상세 주소' }
		  ];
		
		  // ③ 누락·오류 항목 수집
		  const missing = [];
		  requiredFields.forEach(f => {
		    const el = document.getElementById(f.id);
		    if (!el || !el.value.trim()) {
		      missing.push(f.label);
		      if (el) el.style.borderColor = '#ff6b6b'; // 빨간 테두리
		    }
		  });
		
		  // ④ 누락 있으면 한꺼번에 alert
		  if (missing.length) {
			alert("다음 항목을 입력해주세요:\n- " + missing.join("\n- "));
		    // 첫 번째 누락 필드로 포커스 이동
		    const first = requiredFields.find(f => missing.includes(f.label));
		    document.getElementById(first.id).focus();
		    return false;
		  }
		
		  // ⑤ 연락처 형식(숫자 10~11자리) 재확인
		  const phone = document.getElementById('receiver_phone').value.trim();
			if (!/^01[016789]-\d{3,4}-\d{4}$/.test(phone)) {
			  alert('연락처 형식이 올바르지 않습니다.\n예: 010-1234-5678');
			  document.getElementById('receiver_phone').style.borderColor = '#ff6b6b';
			  document.getElementById('receiver_phone').focus();
			  return false;
			}
		
		  return true; // 통과!
		}
		  
		// 폰 번호 자동 하이픈 (함수 추출 예시)
		 function autoHyphen(e) {
		   let v = e.target.value.replace(/[^0-9]/g, '');
		   if (v.length < 4) return (e.target.value = v);
		   if (v.length < 8) return (e.target.value = v.slice(0, 3) + '-' + v.slice(3));
		   e.target.value = v.slice(0, 3) + '-' + v.slice(3, 7) + '-' + v.slice(7, 11);
		 }

		 document.getElementById('receiver_phone').addEventListener('input', autoHyphen);
  

  
	  // DomContentLoaded 안에 나머지 로직
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
	  
		  function updateFinalPayment() {
			    const qty = parseInt(document.getElementById("quantity").value || 1);
			    let usedPoints = parseInt(document.getElementById("usedPoints").value || 0);
			    const total = unitPrice * qty;
		
			    if (usedPoints < 0) usedPoints = 0;
			    if (usedPoints > pointMax) usedPoints = pointMax;
			    if (usedPoints > total) usedPoints = total;
		
			    document.getElementById("usedPoints").value = usedPoints;
			    document.getElementById("totalPrice").innerText = total.toLocaleString();
			    const result = total - usedPoints;
			    document.getElementById("payAmount").innerText = result.toLocaleString();
			    document.getElementById("payAmountInput").value = result;
			  }
		
			  function useAllPoints() {
			    document.getElementById("usedPoints").value = pointMax;
			    updateFinalPayment();
			  }
	
	
		  function changeQty(delta) {
		    let qtyInput = document.getElementById('quantity');
		    let qty = parseInt(qtyInput.value || 1);
		    qty += delta;
		    if (qty < 1) qty = 1;
		    qtyInput.value = qty;
		    document.getElementById('quantityHidden').value = qty;
		    updateFinalPayment();
		  }
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










<%@ include file="/WEB-INF/views/include/footer.jsp" %>