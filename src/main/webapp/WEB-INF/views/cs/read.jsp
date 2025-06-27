<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/inquiry_detail.css">

<%-- 1. 페이지 기본 골격과 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>

<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/header.jsp" %> 

<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>
<%@ include file="/WEB-INF/views/include/alert.jsp" %>

<%-- 4. 여기서부터 '문의 상세조회' 페이지만의 고유한 컨텐츠가 시작됩니다. --%>

<div class="inquiry-detail">
  <h1 class="page-title">
  	<span style="font-size: 28px;">💬</span> 
  	${vo.title}</h1>

  <!-- 메타 정보 -->
  <div class="inquiry-info-card">
	  <!-- 제목과 내용 -->
	  <div class="inquiry-meta">
	    <div><strong>번호:</strong> ${vo.inquiry_id}</div>
	    <div><strong>작성일:</strong> <fmt:formatDate value="${vo.created_at}" pattern="yyyy-MM-dd HH:mm:ss"/></div>
	    <div><strong>분류:</strong> ${vo.category}</div>
	    <div><strong>상태:</strong> ${vo.status}</div>
	  <hr class="inquiry-divider" />
	  <div class="inquiry-title-line"> ${vo.content}</div>
  </div>
</div>
	  
	  
	<!-- 관리자 답변 (없으면 출력 안 됨) -->
	<c:if test="${not empty responseVO}">
	  <div class="reply-box">
	    <div class="reply-title">↩ 관리자 답변</div>
	    <div class="reply-body">${responseVO.response_content}</div>
	    <div class="reply-date">
	      <fmt:formatDate value="${responseVO.created_at}" pattern="yyyy-MM-dd HH:mm:ss"/>
	    </div>
	  </div>
	</c:if>


  <!-- 수정/삭제/목록 버튼 -->
  <div class="button-box">
    <a href="/cs/list" class="btn-jw-inquiry-gray">목록으로</a>

    <c:if test="${vo.status eq '접수'}">
      <button class="btn btn-outline-warning" onclick="document.getElementById('editForm').style.display='block'">✏ 수정하기</button>
      <a href="${pageContext.request.contextPath}/cs/delete?inquiry_id=${vo.inquiry_id}" 
         class="btn btn-jw-inquiry-red"
         onclick="return confirm('정말 삭제하시겠습니까?');">🗑 삭제</a>
    </c:if>
  </div>

  <!-- 수정 폼 -->
  <c:if test="${vo.status eq '접수'}">
    <div id="editForm" style="display:none; margin-top:20px;">
      <form action="${pageContext.request.contextPath}/cs/update" method="post">
        <input type="hidden" name="inquiry_id" value="${vo.inquiry_id}" />

        <label>제목</label>
        <input type="text" name="title" class="form-control" value="${vo.title}" />

        <label class="mt-3">내용</label>
        <textarea name="content" class="form-control" rows="5">${vo.content}</textarea>
	<div class="button-box">
        <button type="submit" class="btn btn-jw-inquiry-blue">수정 완료</button>
    </div>    
      </form>
    </div>
  </c:if>
</div>




<%-- '문의 상세조회' 페이지 컨텐츠 끝 --%>

<%-- 5. 페이지의 끝을 마무리하는 footer 파일을 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>