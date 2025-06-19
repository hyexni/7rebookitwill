<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- 1. 페이지 기본 골격과 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>

<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/header.jsp" %> 

<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>

<%-- 4. 여기서부터 '공지사항 상세' 페이지만의 고유한 컨텐츠가 시작됩니다. --%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pagination.css">


<div class="content">
  <h2>공지사항 상세 (/notice/read.jsp)</h2>
  <div class="box">
    <div class="box-body">

      <div class="form-group">
        <label>NO.</label>
        <input type="text" readonly class="form-control"
               value="${notice.notice_id}" />
      </div>

      <div class="form-group">
        <label>제목</label>
        <input type="text" readonly class="form-control"
               value="${notice.notice_title}" />
      </div>

      <div class="form-group">
        <label>작성자 / 날짜</label>
        <p>
          ${notice.ad_id} /
          <fmt:formatDate value="${notice.notice_date}"
                          pattern="yyyy-MM-dd HH:mm"/>
        </p>
      </div>

      <div class="form-group">
        <label>내용</label>
        <textarea readonly class="form-control" rows="8">
<c:out value="${notice.notice_content}"/>
        </textarea>
      </div>

      <a href="${pageContext.request.contextPath}/notice/listALL"
         class="btn btn-secondary">목록으로 돌아가기</a>

    </div>
  </div>
</div>




<%-- '공지사항 상세' 페이지 컨텐츠 끝 --%>

<%-- 5. 페이지의 끝을 마무리하는 footer 파일을 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>