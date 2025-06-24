<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>
<%@ include file="/WEB-INF/views/include/header.jsp" %>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>

<!-- ✅ SweetAlert 메시지 출력용 -->
<%@ include file="/WEB-INF/views/include/alert.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main.css">

<div class="join-container">
  <h2>회원 탈퇴</h2>
  <form id="deleteForm" action="${pageContext.request.contextPath}/member/delete" method="post">
    <label for="member_pw">비밀번호 확인:</label>
    <input type="password" id="member_pw" name="member_pw" required>

    <div class="btn-area">
      <button type="button" id="deleteBtn" class="btn btn-gray">회원 탈퇴</button>
      <a href="${pageContext.request.contextPath}/member/info" class="btn btn-yellow">취소</a>
    </div>
  </form>
</div>

<!-- SweetAlert2 CDN -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<script>
  document.getElementById('deleteBtn').addEventListener('click', function() {
    Swal.fire({
      title: '정말 탈퇴하시겠습니까?😢',
      icon: 'warning',
      showCancelButton: true,
      confirmButtonColor: '#d33',
      cancelButtonColor: '#3085d6',
      confirmButtonText: '확인',
      cancelButtonText: '취소'
    }).then((result) => {
      if (result.isConfirmed) {
        document.getElementById('deleteForm').submit();
      }
    });
  });
</script>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>
