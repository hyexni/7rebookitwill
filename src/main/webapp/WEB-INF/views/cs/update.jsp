<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 1. 페이지 기본 골격과 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>

<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/header.jsp" %> 

<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>

<%-- 4. 여기서부터 '1:1 문의하기' 페이지만의 고유한 컨텐츠가 시작됩니다. --%>

	          <form action="/cs/write" method="post">
				  <label for="category">문의 분류</label>
				  <select id="category" name="category" required class="form-select mb-2">
				    <option value="">분류를 선택하세요</option>
				    <option value="이용문의">이용문의</option>
				    <option value="배송문의">배송문의</option>
				    <option value="서비스제안">서비스 제안</option>
				    <option value="기타">기타</option>
				  </select>
				
				  <label for="title">문의 제목</label>
				  <input type="text" id="title" name="title" class="form-control mb-2" placeholder="제목을 입력하세요!" required>
				
				  <label for="content">내용</label>
				  <textarea id="content" name="content" class="form-control mb-3" placeholder="내용을 입력하세요!" rows="5" required></textarea>
				
				  <button type="submit" class="btn btn-primary">문의 접수</button>
				  <a href="/cs/list" class="btn btn-outline-secondary">과거 1:1문의 확인</a>
				</form>
	          




<%-- '1:1 문의하기' 페이지 컨텐츠 끝 --%>

<%-- 5. 페이지의 끝을 마무리하는 footer 파일을 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>