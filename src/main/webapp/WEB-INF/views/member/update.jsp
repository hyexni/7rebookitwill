<%@ page language="java" contentType="text/html; charset=UTF-8"%>
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
      <h2>📝 회원 정보 수정</h2>

      <form action="/member/update" method="post" onsubmit="return validateUpdateForm();">

        <label for="member_id">아이디</label>
        <input type="text" id="member_id" name="member_id" value="${memberVO.member_id}" readonly>

        <label for="current_pw">현재 비밀번호 <span style="color:red;">*</span></label>
        <input type="password" id="current_pw" name="current_pw" required>

        <label for="new_pw">새 비밀번호</label>
        <input type="password" id="new_pw" name="new_pw">

        <label for="member_nick">닉네임</label>
		<input type="text" id="member_nick" name="member_nick" value="${memberVO.member_nick}" required>
		<span id="nickResult" class="msg"></span>

        <label for="member_name">이름</label>
        <input type="text" id="member_name" name="member_name" value="${memberVO.member_name}" readonly>

        <label for="member_email">이메일</label>
		<input type="email" id="member_email" name="member_email" value="${memberVO.member_email}">
		<span id="emailResult" class="msg"></span>

        <label for="member_phone">휴대폰 번호</label>
		<input type="text" id="member_phone" name="member_phone" value="${memberVO.member_phone}" maxlength="13" required>
		<span id="phoneResult" class="msg"></span>

        <label for="member_address">주소</label>
        <div class="address-field">
          <input type="text" id="member_address" name="member_address" value="${memberVO.member_address}" readonly required>
          <button type="button" onclick="execDaumPostcode()">주소 검색</button>
        </div>

        <label for="member_address_detail">상세주소</label>
        <input type="text" id="member_address_detail" name="member_address_detail" value="${memberVO.member_address_detail}" placeholder="상세주소 입력" required>

        <label>관심 카테고리 <span style="color:red;">*</span></label>
        <div class="category-group">
          <c:forEach var="category" items="${categoryList}">
            <label class="checkbox-inline">
              <input type="checkbox" name="category_ids" value="${category.category_id}" <c:if test="${fn:contains(selectedCategoryIds, category.category_id)}">checked="checked"</c:if>>
              ${category.category_name_ko}
            </label>
          </c:forEach>
        </div>

        <button type="submit">정보 수정</button>
      </form>
    </div>
  </div>

  <%@ include file="/WEB-INF/views/include/footer.jsp" %>

</div>

<script>
  // 닉네임 중복 확인
  document.getElementById("member_nick").addEventListener("input", function () {
    const nick = this.value.trim();
    const nickResult = document.getElementById("nickResult");
    if (nick.length < 2) {
      nickResult.innerText = "";
      return;
    }
    fetch("/member/checkNickname", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: "nickname=" + encodeURIComponent(nick)
    })
    .then(res => res.text())
    .then(data => {
	   const isOk = data === "OK";
	   nickResult.innerText = isOk ? "✅ 사용 가능합니다!" : "❌ 이미 사용 중입니다";
	   nickResult.style.color = isOk ? "green" : "red";
	  })
    .catch(() => {
      nickResult.innerText = "서버 오류 발생";
      nickResult.style.color = "orange";
    });
  });

  // 이메일 중복 확인
  document.getElementById("member_email").addEventListener("input", function () {
    const email = this.value.trim();
    const emailResult = document.getElementById("emailResult");
    if (!email.includes("@")) {
      emailResult.innerText = "";
      return;
    }
    fetch("/member/checkEmail", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: "member_email=" + encodeURIComponent(email)
    })
    .then(res => res.text())
    .then(data => {
      const isOk = data === "OK";
      emailResult.innerText = isOk ? "✅ 사용 가능합니다!" : "❌ 이미 사용 중입니다";
      emailResult.style.color = isOk ? "green" : "red";
    })
    .catch(() => {
      emailResult.innerText = "서버 오류 발생";
      emailResult.style.color = "orange";
    });
  });

  // 휴대폰 번호 중복 확인 + 자동 하이픈
  const phoneInput = document.getElementById("member_phone");
  const phoneResult = document.getElementById("phoneResult");

  phoneInput.addEventListener("input", function (e) {
    let value = e.target.value.replace(/[^0-9]/g, ""); // 숫자만 남김

    if (value.length > 11) value = value.substring(0, 11); // 11자리까지만 제한

    // 하이픈 자동 삽입
    if (value.length > 7) {
      value = value.replace(/^(\d{3})(\d{4})(\d{0,4})$/, "$1-$2-$3");
    } else if (value.length > 3) {
      value = value.replace(/^(\d{3})(\d{0,4})$/, "$1-$2");
    }

    e.target.value = value;

    // 휴대폰 번호 정규식 검사 (010-xxxx-xxxx)
    const phoneRegex = /^010-\d{4}-\d{4}$/;
    if (!phoneRegex.test(value)) {
      phoneResult.innerText = "❌ 형식이 잘못됐습니다 (010-1234-5678)";
      phoneResult.style.color = "red";
      return;
    }

    // 중복 검사 서버 요청
    fetch("/member/checkPhone", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: "phone=" + encodeURIComponent(value)
    })
    .then(res => res.text())
    .then(data => {
      const isOk = data === "OK";
      phoneResult.innerText = isOk ? "✅ 사용 가능합니다!" : "❌ 이미 사용 중입니다";
      phoneResult.style.color = isOk ? "green" : "red";
    })
    .catch(() => {
      phoneResult.innerText = "서버 오류 발생";
      phoneResult.style.color = "orange";
    });
  });

  // 유효성 검사 함수 (회원정보 수정폼용)
  function validateUpdateForm() {
    const nickMsg = document.getElementById("nickResult").innerText;
    const emailMsg = document.getElementById("emailResult").innerText;
    const phoneMsg = document.getElementById("phoneResult").innerText;

    if (nickMsg === "❌ 이미 사용 중입니다" || emailMsg === "❌ 이미 사용 중입니다" || phoneMsg === "❌ 이미 사용 중입니다") {
      alert("❌ 중복된 항목이 있습니다.");
      return false;
    }

    const checkedCategories = document.querySelectorAll('input[name="category_ids"]:checked');
    if (checkedCategories.length < 2) {
      alert("관심 카테고리는 최소 2개 이상 선택해야 합니다.");
      return false;
    }

    return true;
  }

  // 다음 주소 검색 API 연동 함수
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
          if (data.bname !== "") extraAddr += data.bname;
          if (data.buildingName !== "") extraAddr += (extraAddr !== "" ? ", " + data.buildingName : data.buildingName);
          if (extraAddr !== "") addr += " (" + extraAddr + ")";
        }

        document.getElementById("member_address").value = addr;
        document.getElementById("member_address_detail").value = "";
        document.getElementById("member_address_detail").focus();
      },
    }).open();
  }
</script>


<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>


