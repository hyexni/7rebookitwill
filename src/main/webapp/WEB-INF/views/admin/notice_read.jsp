<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>



<%-- 1. 페이지 기본 골격과 공통 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="include/layout_head.jsp" %>

<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@ include file="include/header.jsp" %> 

<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@ include file="include/sidebar.jsp" %> 

<div class="notice-form-container">
  <h1><span style="font-size: 22px;">📌</span> 공지 상세보기</h1>

  <div class="notice-detail">
    <p><strong>제목:</strong> ${notice.notice_title}</p>
    <p><strong>내용:</strong><br />${notice.notice_content}</p>
    <p><strong>작성일:</strong> <fmt:formatDate value="${notice.notice_date}" pattern="yyyy-MM-dd HH:mm:ss" /></p>
    <c:if test="${notice.notice_date ne notice.updated_at}">
  		<p><strong>수정일:</strong> <fmt:formatDate value="${notice.updated_at}" pattern="yyyy-MM-dd HH:mm:ss" /></p>
    </c:if>
  </div>

  <div class="btn-wrapper">
    <form action="${pageContext.request.contextPath}/admin/delete" method="post" style="display: inline;">
      <input type="hidden" name="notice_id" value="${notice.notice_id}" />
      <button type="submit" class="btn-outline-danger" onclick="return confirm('삭제하시겠습니까?')">삭제</button>
    </form>

    <a href="${pageContext.request.contextPath}/admin/edit?notice_id=${notice.notice_id}" class="btn-outline-primary">수정</a>
    <a href="${pageContext.request.contextPath}/admin/notice_list" class="btn-outline-primary">목록</a>
  </div>
</div>



<%-- 4. 하단 푸터를 불러옵니다. --%>
<%@ include file="include/footer.jsp" %> 