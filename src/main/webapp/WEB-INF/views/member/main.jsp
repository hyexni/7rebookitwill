<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main.css">

<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>
<%@ include file="/WEB-INF/views/include/header.jsp" %>
  <%-- 알림창  --%>
<%@ include file="/WEB-INF/views/include/alert.jsp" %> 

<!-- ✅ 전체 flex wrapper 시작 -->
<div class="main-wrapper">

  <%@ include file="/WEB-INF/views/include/sidebar.jsp" %>
  

  <!-- ✅ 오른쪽 마이페이지 콘텐츠 -->
  <div class="mypage-container">

    <div class="mypage-header">
      <!-- 👤 이름 환영 박스 -->
      
    <c:choose>
     <c:when test="${not empty adminLogin}">
       <div class="welcome-box">
         <div class="welcome-name">${adminLogin.ad_nick} 관리자님</div>
         <div class="welcome-msg">환영합니다 👑</div>
       </div>
     </c:when>
     <c:when test="${not empty loginUser}">
       <div class="welcome-box">
         <div class="welcome-name">${loginUser.member_nick}님</div>
         <div class="welcome-msg">환영합니다 😊</div>
       </div>
     </c:when>
   </c:choose>

  <!-- 💰 포인트 박스 -->
  <div class="point-box">
    <img src="${pageContext.request.contextPath}/resources/img/icon/coin.png" alt="포인트" class="point-icon">
    <span class="point-label">보유 포인트</span>
    <a href="/point/history" class="point-value" style="text-decoration: none; color: inherit;">
      <c:choose>
        <c:when test="${empty totalPoint}">0P</c:when>
        <c:otherwise>${totalPoint}P</c:otherwise>
      </c:choose>
    </a>
  </div>
</div>

    <!-- ✅ 마이페이지 항목 리스트 -->
    <div class="mypage-boxes">
      <div class="mypage-box">
        <h4 class="box-title">1. 회원 기본정보</h4>
        <p class="box-desc">이름, 아이디, 이메일, 관심 카테고리를 확인할 수 있어요.</p>
        <a href="/member/info" class="mypage-btn">조회하기</a>
      </div>

      <div class="mypage-box">
        <h4 class="box-title">2. 회원 정보 수정</h4>
        <p class="box-desc">비밀번호나 연락처를 변경하고 프로필을 수정할 수 있어요.</p>
        <a href="/member/update" class="mypage-btn">수정하기</a>
      </div>

      <div class="mypage-box">
        <h4 class="box-title">3. 주문/배송 조회</h4>
        <p class="box-desc">내 주문 내역과 배송 상태를 확인해요.</p>
        <a href="/order/list" class="mypage-btn">주문 확인</a>
      </div>

      <div class="mypage-box">
        <h4 class="box-title">4. 찜 목록</h4>
        <p class="box-desc">찜한 도서 목록을 한눈에 볼 수 있어요.</p>
        <a href="/wishlist/list" class="mypage-btn">바로가기</a>
      </div>

      <div class="mypage-box">
        <h4 class="box-title">5. 작성한 리뷰</h4>
        <p class="box-desc">작성한 리뷰를 확인하고 수정·삭제할 수 있어요.</p>
        <a href="/review/my" class="mypage-btn">리뷰 보기</a>
      </div>
    </div>
  </div> <%-- ✅ mypage-container 닫기 --%>

</div> <%-- ✅ main-wrapper 닫기 --%>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>
