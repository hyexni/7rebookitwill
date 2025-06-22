<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>
<%@ include file="/WEB-INF/views/include/header.jsp" %>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>

<div class="container" style="max-width: 500px; margin: 50px auto;">
  <h2>🔐 비밀번호 찾기</h2>

 <form action="${pageContext.request.contextPath}/member/findPw" method="post">
    <div class="form-group">
      <label for="member_id">아이디</label>
      <input type="text" id="member_id" name="member_id" class="form-control" required>
    </div>

    <div class="form-group">
      <label for="member_name">이름</label>
      <input type="text" id="member_name" name="member_name" class="form-control" required>
    </div>

    <div class="form-group">
      <label for="member_phone">휴대폰 번호</label>
      <input type="text" id="member_phone" name="member_phone" class="form-control"
             placeholder="010-1234-5678" maxlength="13" oninput="formatPhoneNumber(this)" required>
    </div>

    <button type="submit" class="btn btn-warning" style="margin-top: 20px;">비밀번호 찾기</button>
  </form>

  <c:if test="${not empty msg}">
    <p style="color: red; margin-top: 20px;">${msg}</p>
  </c:if>
</div>

<script>
  function formatPhoneNumber(input) {
    let value = input.value.replace(/[^0-9]/g, "");
    if (value.length <= 3) {
      input.value = value;
    } else if (value.length <= 7) {
      input.value = value.slice(0, 3) + '-' + value.slice(3);
    } else {
      input.value = value.slice(0, 3) + '-' + value.slice(3, 7) + '-' + value.slice(7, 11);
    }
  }
</script>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>
