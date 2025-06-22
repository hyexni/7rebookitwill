<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 1. 페이지 기본 골격과 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>

<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/header.jsp" %> 

<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>

<%-- 4. 여기서부터 '1:1 문의 목록' 페이지만의 고유한 컨텐츠가 시작됩니다. --%>

<section class="mypage-inquiry-list">
  <div class="inquiry-header">
    <h2><i class="fa fa-clipboard-list"></i>📋 나의 1:1 문의 내역</h2>
    <a href="/cs/write" class="btn-write">새글 등록</a>
  </div>

  <div class="table-wrapper">
    <table class="styled-table">
      <thead>
        <tr>
          <th>번호</th>
          <th>분류</th>
          <th>제목</th>
          <th>작성일</th>
          <th>상태</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="vo" items="${inquiryList}">
          <tr>
            <td>${vo.inquiry_id}</td>
            <td>${vo.category}</td>
            <td><a href="/cs/read?inquiry_id=${vo.inquiry_id}" class="inquiry-link">${vo.title}</a></td>
            <td><fmt:formatDate value="${vo.created_at}" pattern="yyyy-MM-dd" /></td>
            <td><span class="status received">${vo.status}</span></td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>
</section>





<%-- '1:1 문의 목록' 페이지 컨텐츠 끝 --%>

<%-- 5. 페이지의 끝을 마무리하는 footer 파일을 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>