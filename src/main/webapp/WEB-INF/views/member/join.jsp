<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main.css">

<div class="wrapper">
  <%@ include file="/WEB-INF/views/include/layout_head.jsp" %>
  <%@ include file="/WEB-INF/views/include/header.jsp" %>
  <%@ include file="/WEB-INF/views/include/sidebar.jsp" %>
  <%@ include file="/WEB-INF/views/include/alert.jsp" %>

  <div class="content">
    <div class="join-container">
      <h2>회원가입</h2>
      <form action="/member/join" method="post" onsubmit="return validateForm();">

        <label for="member_id">아이디:</label>
        <div class="inline-field" style="display:flex; align-items:center; gap:10px;">
          <input type="text" id="member_id" name="member_id" required style="flex:1;">
          <button type="button" id="checkIdBtn">중복확인</button>
          <span id="idResult"></span>
        </div>
        <input type="hidden" id="idChecked" value="false">

        <label for="member_pw">비밀번호:</label>
        <input type="password" id="member_pw" name="member_pw" required>
        <div id="pwFormatResult" class="msg"></div>

        <label for="member_pwConfirm">비밀번호 확인:</label>
        <input type="password" id="member_pwConfirm" required>
        <div id="pwMatchResult" class="msg"></div>

        <label for="member_nick">닉네임:</label>
        <input type="text" id="member_nick" name="member_nick" required>
        <div id="nicknameResult" class="msg"></div>

        <label for="member_name">이름:</label>
        <input type="text" id="member_name" name="member_name" required>

        <label for="member_phone">통신사 / 휴대폰번호:</label>
		<div class="inline-field">
		  <select id="tel_carrier" name="tel_carrier" required>
		    <option value="">선택</option>
		    <option value="SKT">SKT</option>
		    <option value="KT">KT</option>
		    <option value="LGU+">LG U+</option>
		    <option value="알뜰폰">알뜰폰</option>
		  </select>
		  <input type="text" id="member_phone" name="member_phone" required maxlength="13">
		</div>
		<span id="phoneResult" class="msg"></span>

        <label>이메일 (선택사항):</label>
        <input type="text" id="email_front" placeholder="example"> @
        <input type="text" id="email_select_input" value="naver.com">
        <select id="email_select" onchange="changeDomain();">
          <option value="">선택</option>
          <option value="naver.com">naver.com</option>
          <option value="daum.net">daum.net</option>
          <option value="gmail.com">gmail.com</option>
          <option value="nate.com">nate.com</option>
          <option value="direct">직접입력</option>
        </select>
        <input type="hidden" id="member_email" name="member_email">
        <span id="emailResult"></span>

        <label>성별:</label>
        <div class="inline-radio">
          <label><input type="radio" name="gender" value="남자"> 남자</label>
          <label><input type="radio" name="gender" value="여자"> 여자</label>
        </div>

        <label>내/외국인:</label>
        <div class="inline-radio">
          <label><input type="radio" name="nationality" value="내국인"> 내국인</label>
          <label><input type="radio" name="nationality" value="외국인"> 외국인</label>
        </div>

        <label for="member_address">주소:</label>
        <div class="address-field">
          <input type="text" id="member_address" name="member_address" required readonly>
          <button type="button" onclick="execDaumPostcode();">주소 검색</button>
        </div>

        <label for="member_address_detail">상세주소:</label>
        <input type="text" id="member_address_detail" name="member_address_detail" required>

        <label>관심 카테고리 (2개 이상 필수 선택):</label>
        <div class="category-group">
          <c:forEach var="cate" items="${categoryList}">
            <label class="checkbox-inline">
              <input type="checkbox" name="category_ids" value="${cate.category_id}">
              ${cate.category_name_ko}
            </label>
          </c:forEach>
        </div>

        <button type="submit">가입하기</button>
      </form>
    </div>
  </div>
</div>

<!-- ✅ 자바스크립트 -->
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
  
//아이디 중복확인 버튼 눌렀을 때 검사
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

// 비밀번호 유효성 검사 및 일치 확인
const pw = document.getElementById("member_pw");
const pwConfirm = document.getElementById("member_pwConfirm");

pw.addEventListener("input", function () {
  const rule = /^(?=.*[A-Za-z])(?=.*[0-9!@#$%^&*])[A-Za-z0-9!@#$%^&*]{8,}$/;
  const result = document.getElementById("pwFormatResult");

  if (pw.value === "") {
    result.innerText = "";
  } else if (!rule.test(pw.value)) {
    result.innerText = "❌ 형식 부적합 (8자 이상, 영문+숫자/특수문자)";
    result.style.color = "red";
  } else {
    result.innerText = "✅ 형식 적합";
    result.style.color = "green";
  }
});

pwConfirm.addEventListener("input", function () {
  const result = document.getElementById("pwMatchResult");

  if (pwConfirm.value === "") {
    result.innerText = "";
  } else if (pw.value !== pwConfirm.value) {
    result.innerText = "❌ 비밀번호 불일치!";
    result.style.color = "red";
  } else {
    result.innerText = "✅ 비밀번호 일치!";
    result.style.color = "green";
  }
});

// 닉네임 중복확인
const nicknameInput = document.getElementById("member_nick");
const nicknameResult = document.getElementById("nicknameResult");
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
      const response = data.trim().toUpperCase();
      nicknameResult.innerText = response === "DUPLICATE" ? "❌ 이미 사용 중" : "✅ 사용 가능!";
      nicknameResult.style.color = response === "DUPLICATE" ? "red" : "green";
    });
}

nicknameInput.addEventListener("input", function () {
  clearTimeout(nicknameTimer);
  nicknameTimer = setTimeout(() => {
    checkNicknameDuplication();
  }, 500);
});

// 이메일 중복 확인 및 도메인 선택
function validateForm() {
  const front = document.getElementById("email_front").value.trim();
  const domain = document.getElementById("email_select_input").value.trim();

  if (front && domain) {
    const fullEmail = front + "@" + domain;
    document.getElementById("member_email").value = fullEmail;

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
    document.getElementById("member_email").value = "";
    document.getElementById("emailResult").textContent = "";
  }

  return true;
}

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

// 휴대폰 자동 하이픈 + 중복 확인
const phone = document.getElementById("member_phone");
const phoneResult = document.getElementById("phoneResult");

phone.addEventListener("input", function () {
  phone.value = phone.value
    .replace(/[^0-9]/g, "")
    .replace(/^(\d{3})(\d{0,4})(\d{0,4})$/, function (_, p1, p2, p3) {
      let result = p1;
      if (p2) result += "-" + p2;
      if (p3) result += "-" + p3;
      return result;
    });

  const value = phone.value;
  const phoneRegex = /^010-\d{4}-\d{4}$/;

  if (!phoneRegex.test(value)) {
    phoneResult.innerText = "❌ 형식이 잘못됐습니다 (010-1234-5678)";
    phoneResult.style.color = "red";
    return;
  }

  fetch("/member/checkPhone", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: "phone=" + encodeURIComponent(value)
  })
    .then(res => res.text())
    .then(data => {
      phoneResult.innerText = data === "DUPLICATE" ? "❌ 이미 사용 중" : "✅ 사용 가능!";
      phoneResult.style.color = data === "DUPLICATE" ? "red" : "green";
    });
});

// 다음 주소 API
function execDaumPostcode() {
  new daum.Postcode({
    oncomplete: function (data) {
      let addr = "";
      let extraAddr = "";

      if (data.userSelectedType === "R") {
        addr = data.roadAddress;
      } else {
        addr = data.jibunAddress;
      }

      if (data.userSelectedType === "R") {
        if (data.bname !== "") {
          extraAddr += data.bname;
        }
        if (data.buildingName !== "") {
          extraAddr += extraAddr !== "" ? ", " + data.buildingName : data.buildingName;
        }
        if (extraAddr !== "") {
          addr += " (" + extraAddr + ")";
        }
      }

      document.getElementById("member_address").value = addr;
      document.getElementById("member_address_detail").value = "";
      document.getElementById("member_address_detail").focus();
    },
  }).open();
}

// 전체 유효성 검사
function validateForm() {
  // 아이디 중복확인 했는지 체크
  const idChecked = document.getElementById("idChecked").value;
  if (idChecked !== "true") {
    alert("아이디 중복확인을 해주세요!");
    return false;
  }

  // 성별 선택 확인
  if (!document.querySelector('input[name="gender"]:checked')) {
    alert("성별을 선택해주세요.");
    return false;
  }

  // 내/외국인 선택 확인
  if (!document.querySelector('input[name="nationality"]:checked')) {
    alert("내/외국인 여부를 선택해주세요.");
    return false;
  }

  // 관심 카테고리 최소 2개 이상 체크 확인
  const cate = document.querySelectorAll('input[name="category_ids"]:checked');
  if (cate.length < 2) {
    alert("관심 카테고리를 2개 이상 선택해주세요.");
    return false;
  }

  // 전화번호 유효성 검사
  const phoneRegex = /^010-\d{4}-\d{4}$/;
  const phoneValue = document.getElementById("member_phone").value.trim();
  if (!phoneRegex.test(phoneValue)) {
    alert("휴대폰 번호 형식이 올바르지 않습니다. (예: 010-1234-5678)");
    return false;
  }

  // 휴대폰 번호 중복 검사 결과 확인
  const phoneResult = document.getElementById("phoneResult").innerText.trim();
  if (phoneResult === "❌ 이미 사용 중") {
    alert("중복된 휴대폰 번호입니다. 다른 번호를 입력해주세요.");
    return false;
  }

  return true; // 모든 조건 통과
}

  
</script>

