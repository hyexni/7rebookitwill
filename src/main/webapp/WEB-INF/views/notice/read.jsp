<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> <%-- JSTL functions 라이브러리 추가 --%>

<%-- 1. 페이지 기본 골격과 공통 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>

<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/header.jsp" %>

<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>

<div class="notice-detail-wrapper">
  <div class="notice-detail-header">
    <h2 class="notice-title">
      <c:if test="${notice.fixed}">
        <span style="color: red; font-weight: bold;">[공지]</span>
      </c:if>
      ${notice.notice_title}
    </h2>
    <p class="notice-date">
      작성일: <fmt:formatDate value="${notice.notice_date}" pattern="yyyy-MM-dd" />
    </p>
  </div>

  <div class="notice-content">
    ${notice.notice_content}
  </div>
</div>



<%-- 4. 하단 푸터를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
