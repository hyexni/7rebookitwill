<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main.css">

<%@ include file="/WEB-INF/views/include/header.jsp" %>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>

<!-- ✅ 사이드바 오른쪽 영역 정렬 -->
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
      <span id="nickResult"></span>

	  <label for="member_name">이름</label>
	  <input type="text" id="member_name" name="member_name" value="${memberVO.member_name}" readonly>

      <label for="member_email">이메일</label>
      <input type="email" id="member_email" name="member_email" value="${memberVO.member_email}">
      <span id="emailResult"></span>

      <label for="member_phone">휴대폰 번호</label>
      <input type="text" id="member_phone" name="member_phone" value="${memberVO.member_phone}" required>
      <span id="phoneResult"></span>

      <label>관심 카테고리 <span style="color:red;">*</span></label>
      <div class="category-group">
        <c:forEach var="category" items="${categoryList}">
          <label class="checkbox-inline">
            <input type="checkbox" name="category_ids" value="${category.category_id}"
              <c:if test="${fn:contains(selectedCategoryIds, category.category_id)}">checked="checked"</c:if> />
            ${category.category_name_ko}
          </label>
        </c:forEach>
      </div>

      <button type="submit">정보 수정</button>
    </form>
  </div>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<c:if test="${not empty msg}">
  <script>
    window.onload = function() {
      Swal.fire({
        icon: 'info',
        title: '알림',
        text: '${msg}'
      });
    };
  </script>
</c:if>

<script>
  // 닉네임 중복 확인
  document.getElementById("member_nick").addEventListener("input", function () {
    const nick = this.value;
    if (nick.length < 2) {
      document.getElementById("nickResult").innerText = "";
      return;
    }
    fetch("/member/checkNickname", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: "nickname=" + encodeURIComponent(nick)
    })
    .then(res => res.text())
    .then(data => {
      document.getElementById("nickResult").innerText = (data === "OK") ? "사용 가능" : "이미 사용 중";
      document.getElementById("nickResult").style.color = (data === "OK") ? "green" : "red";
    });
  });

  // 이메일 중복 확인
  document.getElementById("member_email").addEventListener("input", function () {
    const email = this.value;
    if (!email.includes("@")) return;
    fetch("/member/checkEmail", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: "member_email=" + encodeURIComponent(email)
    })
    .then(res => res.text())
    .then(data => {
      document.getElementById("emailResult").innerText = (data === "OK") ? "사용 가능" : "이미 사용 중";
      document.getElementById("emailResult").style.color = (data === "OK") ? "green" : "red";
    });
  });

  // 핸드폰 중복 확인
  document.getElementById("member_phone").addEventListener("input", function () {
    const phone = this.value;
    if (phone.length < 8) return;
    fetch("/member/checkPhone", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: "phone=" + encodeURIComponent(phone)
    })
    .then(res => res.text())
    .then(data => {
      document.getElementById("phoneResult").innerText = (data === "OK") ? "사용 가능" : "이미 사용 중";
      document.getElementById("phoneResult").style.color = (data === "OK") ? "green" : "red";
    });
  });

  // 유효성 검사
  function validateUpdateForm() {
    const nickMsg = document.getElementById("nickResult").innerText;
    const emailMsg = document.getElementById("emailResult").innerText;
    const phoneMsg = document.getElementById("phoneResult").innerText;

    const checkedCategories = document.querySelectorAll('input[name="category_ids"]:checked');
    if (checkedCategories.length < 2) {
      alert("관심 카테고리는 최소 2개 이상 선택해야 합니다.");
      return false;
    }

    if (nickMsg === "이미 사용 중" || emailMsg === "이미 사용 중" || phoneMsg === "이미 사용 중") {
      alert("중복된 항목이 있습니다.");
      return false;
    }

    return true;
  }
</script>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>
