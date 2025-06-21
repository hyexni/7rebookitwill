<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>
<%@ include file="/WEB-INF/views/include/header.jsp" %>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main.css">

<div class="join-container">
  <h2>회원가입</h2>
  <form action="/member/join" method="post" onsubmit="return validateForm()">

    <label for="member_id">아이디:</label>
	<input type="text" id="member_id" name="member_id" required>
	<button type="button" id="checkIdBtn">중복확인</button>
	<span id="idResult" style="margin-left: 10px;"></span>
	<input type="hidden" id="idChecked" value="false">
	
	<script>
	  // ✅ 아이디 입력하면 상태 초기화
	  document.getElementById("member_id").addEventListener("input", function () {
	    document.getElementById("idChecked").value = "false";
	    document.getElementById("idResult").innerText = ""; // 메시지도 초기화
	  });
	</script>
		

    <label for="member_pw">비밀번호:</label>
    <input type="password" id="member_pw" name="member_pw" required>
    <span id="pwFormatResult"></span>

    <label for="member_pwConfirm">비밀번호 확인:</label>
    <input type="password" id="member_pwConfirm" required>
    <span id="pwMatchResult"></span>

    <label for="member_nick">닉네임:</label>
	<input type="text" id="member_nick" name="member_nick" required>
	<span id="nicknameResult"></span>
    
    <label for="member_name">이름:</label>
    <input type="text" id="member_name" name="member_name" required>

    <label>통신사:</label>
    <select id="tel_carrier" name="tel_carrier">
      <option value="">선택</option>
      <option value="SKT">SKT</option>
      <option value="KT">KT</option>
      <option value="LGU+">LG U+</option>
      <option value="알뜰폰">알뜰폰</option>
    </select>

    <label for="member_phone">휴대폰번호:</label>
    <input type="text" id="member_phone" name="member_phone" required>
    <span id="phoneResult"></span>

   <!-- 이메일 입력 (선택사항) -->
<label for="email_front">이메일 (선택사항):</label>
<input type="text" id="email_front" placeholder="example" /> @
<input type="text" id="email_select_input" value="naver.com" />
<select id="email_select" onchange="changeDomain()">
  <option value="">선택</option>
  <option value="naver.com">naver.com</option>
  <option value="daum.net">daum.net</option>
  <option value="gmail.com">gmail.com</option>
  <option value="nate.com">nate.com</option>
  <option value="direct">직접입력</option>
</select>
<span id="emailResult" style="margin-left: 10px; font-weight: bold;"></span>

    <label>성별:</label>
    <input type="radio" name="gender" value="남자"> 남자
    <input type="radio" name="gender" value="여자"> 여자
    <span id="genderResult" class="error"></span>

    <label>내/외국인:</label>
    <input type="radio" name="nationality" value="내국인"> 내국인
    <input type="radio" name="nationality" value="외국인"> 외국인
    <span id="nationalityResult" class="error"></span>

    <label for="member_address">주소:</label>
    <input type="text" id="member_address" name="member_address" required readonly>
    <button type="button" onclick="execDaumPostcode()">주소 검색</button>

    <label for="member_address_detail">상세주소:</label>
    <input type="text" id="member_address_detail" name="member_address_detail" required>

    <!-- 관심 카테고리 (2개 이상 선택 필수) -->
    <div class="form-group">
      <label>관심 카테고리 (2개 이상 필수 선택)</label><br>
      <c:forEach var="cate" items="${categoryList}">
        <label class="checkbox-inline">
          <input type="checkbox" name="category_ids" value="${cate.category_id}"> ${cate.category_name_ko}
        </label><br>
      </c:forEach>
    </div>

    <button type="submit">가입하기</button>
  </form>
</div>

<!-- ✅ 자바스크립트 -->
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
  
  // ✅ 아이디 중복확인 버튼 눌렀을 때만 검사
	document.getElementById("checkIdBtn").addEventListener("click", function () {
	  const id = document.getElementById("member_id").value.trim();
	  const result = document.getElementById("idResult");
	  const idChecked = document.getElementById("idChecked");
	
	  if (id.length < 4) {
	    result.innerText = "⚠ 4글자 이상 입력하세요.";
	    result.style.color = "gray";
	    idChecked.value = "false";
	    return;
	  }
	
	  fetch("/member/checkId", {
	    method: "POST",
	    headers: { "Content-Type": "application/x-www-form-urlencoded" },
	    body: "member_id=" + encodeURIComponent(id)
	  })
	    .then(res => res.text())
	    .then(data => {
	      if (data === "DUPLICATE") {
	        result.innerText = "❌ 이미 사용 중";
	        result.style.color = "red";
	        idChecked.value = "false";
	      } else {
	        result.innerText = "✅ 사용 가능!";
	        result.style.color = "green";
	        idChecked.value = "true";
	      }
	    });
	});


  // ✅ 비밀번호 유효성
  const pw = document.getElementById("member_pw");
  const pwConfirm = document.getElementById("member_pwConfirm");
  pw.addEventListener("input", function () {
    const rule = /^(?=.*[A-Za-z])(?=.*[0-9!@#$%^&*])[A-Za-z0-9!@#$%^&*]{8,}$/;
    const result = document.getElementById("pwFormatResult");
    if (pw.value === "") result.innerText = "";
    else if (!rule.test(pw.value)) {
      result.innerText = "❌ 형식 부적합 (8자 이상, 영문+숫자/특수문자)";
      result.style.color = "red";
    } else {
      result.innerText = "✅ 형식 적합";
      result.style.color = "green";
    }
  });

  pwConfirm.addEventListener("input", function () {
    const result = document.getElementById("pwMatchResult");
    if (pwConfirm.value === "") result.innerText = "";
    else if (pw.value !== pwConfirm.value) {
      result.innerText = "❌ 비밀번호 불일치!";
      result.style.color = "red";
    } else {
      result.innerText = "✅ 비밀번호 일치!";
      result.style.color = "green";
    }
  });

  // 닉네임 중복확인 
  const nicknameInput = document.getElementById("member_nick");
  const nicknameResult = document.getElementById("nicknameResult"); // ✅ nickResult가 아니라 nicknameResult야!
  let nicknameTimer;

  function checkNicknameDuplication() {
    const nickname = nicknameInput.value.trim();
    const nicknameRegex = /^[가-힣a-zA-Z0-9]{2,8}$/;

    if (!nicknameRegex.test(nickname)) {
      nicknameResult.innerText = "⚠ 2~8자, 한글/영어/숫자만 사용 가능해요!";
      nicknameResult.style.color = "gray";
      return;
    }

    fetch("/member/checkNickname", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: "nickname=" + encodeURIComponent(nickname)
    })
      .then(res => res.text())
      .then(data => {
        nicknameResult.innerText = data === "DUPLICATE" ? "❌ 이미 사용 중!" : "✅ 사용 가능!";
        nicknameResult.style.color = data === "DUPLICATE" ? "red" : "green";
      });
  }

  nicknameInput.addEventListener("input", function () {
    clearTimeout(nicknameTimer);
    nicknameTimer = setTimeout(() => {
      checkNicknameDuplication();
    }, 500);
  });


  // 이메일
  function validateForm() {
  const front = document.getElementById("email_front").value.trim();
  const domain = document.getElementById("email_select_input").value.trim();

	  // 이메일 입력 여부 확인
	  if (front && domain) {
	    const fullEmail = front + "@" + domain;
	    document.getElementById("member_email").value = fullEmail; // 숨겨진 input에 넣기
	
	    // 중복 확인
	    fetch("/member/checkEmail", {
	      method: "POST",
	      headers: { "Content-Type": "application/x-www-form-urlencoded" },
	      body: "member_email=" + encodeURIComponent(fullEmail)
	    })
	    .then(res => res.text())
	    .then(data => {
	      const result = document.getElementById("emailResult");
	      if (data === "OK") {
	        result.textContent = "✅ 사용 가능";
	        result.style.color = "green";
	      } else {
	        result.textContent = "❌ 이미 사용 중";
	        result.style.color = "red";
	      }
	    });
	  } else {
	    // 이메일 미입력 시 hidden도 비우기
	    document.getElementById("member_email").value = "";
	    document.getElementById("emailResult").textContent = ""; 
	  }
	
	  return true; // 서버로 전송은 허용
	}

	// ✨ 도메인 선택
	function changeDomain() {
	  const select = document.getElementById("email_select").value;
	  const domainInput = document.getElementById("email_select_input");
	
	  if (select === "direct") {
	    domainInput.value = "";
	    domainInput.readOnly = false;
	    domainInput.placeholder = "직접 입력";
	    domainInput.focus();
	  } else {
	    domainInput.value = select;
	    domainInput.readOnly = true;
	    domainInput.placeholder = "";
	  }
	}



  // ✅ 휴대폰 중복확인 + 자동 하이픈
  const phone = document.getElementById("member_phone");
  const phoneResult = document.getElementById("phoneResult");
  phone.addEventListener("input", function () {
    phone.value = phone.value.replace(/[^0-9]/g, '').replace(/(\d{3})(\d{3,4})(\d{4})/, "$1-$2-$3");
    if (phone.value.length < 13) return phoneResult.innerText = "";

    fetch("/member/checkPhone", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: "phone=" + encodeURIComponent(phone.value)
    })
    .then(res => res.text())
    .then(data => {
      phoneResult.innerText = data === "DUPLICATE" ? "❌ 이미 사용 중" : "✅ 사용 가능!";
      phoneResult.style.color = data === "DUPLICATE" ? "red" : "green";
    });
  });

  // ✅ 다음 주소 API
  function execDaumPostcode() {
    new daum.Postcode({
      oncomplete: function (data) {
        document.getElementById("member_address").value = data.address;
        document.getElementById("member_address_detail").focus();
      }
    }).open();
  }

  	// 전체 유효성 검사 
 	 function validateForm() {
	  // ✅ 아이디 중복확인 했는지 체크
	  const idChecked = document.getElementById("idChecked").value;
	  if (idChecked !== "true") {
	    alert("아이디 중복확인을 해주세요!");
	    return false;
	  }

	  // ✅ 성별 선택 확인
	  if (!document.querySelector('input[name="gender"]:checked')) {
	    alert("성별을 선택해주세요.");
	    return false;
	  }

	  // ✅ 내/외국인 선택 확인
	  if (!document.querySelector('input[name="nationality"]:checked')) {
	    alert("내/외국인 여부를 선택해주세요.");
	    return false;
	  }

	  // ✅ 관심 카테고리 최소 2개 이상 체크 확인
	  const cate = document.querySelectorAll('input[name="category_ids"]:checked');
	  if (cate.length < 2) {
	    alert("관심 카테고리를 2개 이상 선택해주세요.");
	    return false;
	  }

	  return true; // 모든 조건 통과!
	}
</script>
