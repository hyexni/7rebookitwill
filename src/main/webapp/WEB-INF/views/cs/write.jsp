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


<!-- ✅ 공통 CSS 불러오기 -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/custom.css">

<div class="container" style="max-width: 700px; margin: 50px auto;">
    <h2 style="margin-bottom: 50px;">1:1 문의 작성</h2>

    <form id="inquiryForm" action="${pageContext.request.contextPath}/cs/write" method="post">

    
		<!-- 분류 -->    
        <div class="form-group" style="margin-bottom: 70px;">
			  <label for="category" style="display: block; margin-bottom: 6px;">분류</label>
			  <select name="category" id="category" class="form-control">
			    <option value="">분류를 선택하세요</option>
                <option value="회원정보/로그인">회원정보/로그인</option>
                <option value="주문/결제 문의">주문/결제 문의</option>
                <option value="배송 문의">배송 문의</option>
                <option value="도서 관련 문의">도서 관련 문의</option>
                <option value="리워드/포인트">리워드/포인트</option>
                <option value="영수증 인증 문의">영수증 인증 문의</option>
                <option value="이벤트/쿠폰">이벤트/쿠폰</option>
                <option value="서비스 제안">서비스 제안</option>
                <option value="기타">기타</option>
            </select>
            <!-- 분류 오류 메시지 -->
			<small id="category-error" class="text-danger" style="display:none;">
			  <span style="margin-right: 4px;">⚠️</span> 분류를 선택하세요
			</small>
        </div>
        
		<!-- 제목 -->
        <div class="form-group" style="margin-bottom: 20px;">
		  <label for="title" style="display: block; margin-bottom: 6px;">제목</label>
		  <input type="text" id="title" name="title" class="form-control" placeholder="제목을 입력하세요!" />
		  <!-- 제목 오류 메시지 -->
		  <small id="title-error" class="text-danger" style="display:none;">
		    <span style="margin-right: 4px;">⚠️</span> 제목을 입력하세요
		  </small>
		</div>
		
		<!-- 내용 -->
		<div class="form-group" style="margin-bottom: 30px;">
		  <label for="content" style="display: block; margin-bottom: 6px;">내용</label>
		  <textarea id="content" name="content" class="form-control" rows="6" placeholder="내용을 입력하세요!"></textarea>
		 <!-- 내용 오류 메시지 -->
		 <small id="content-error" class="text-danger" style="display:none;">
		   <span style="margin-right: 4px;">⚠️</span> 내용을 입력하세요
		 </small>
		</div>

        <div class="d-flex gap-2">
            <button type="submit" class="btn btn-primary">문의 접수</button>
            <a href="${pageContext.request.contextPath}/cs/list" class="btn btn-outline-secondary">과거 1:1문의 확인</a>
        </div>
    </form>
</div>




<%-- '1:1 문의하기' 페이지 컨텐츠 끝 --%>
<script>
  document.addEventListener("DOMContentLoaded", function () {
    const form = document.getElementById("inquiryForm");
    const category = document.getElementById("category");
    const title = document.getElementById("title");
    const content = document.getElementById("content");

    const categoryError = document.getElementById("category-error");
    const titleError = document.getElementById("title-error");
    const contentError = document.getElementById("content-error");

    form.addEventListener("submit", function (e) {
      let isValid = true;

      // 초기화
      [category, title, content].forEach(el => el.style.border = "");
      [categoryError, titleError, contentError].forEach(el => el.style.display = "none");

      // 분류 체크
      if (category.value === "") {
        category.style.border = "2px solid #f4c430"; // ✅ 노란 테두리
        categoryError.style.display = "block";
        isValid = false;
      }

      // 제목 체크
      if (title.value.trim() === "") {
        title.style.border = "2px solid #f4c430"; // ✅ 노란 테두리
        titleError.style.display = "block";
        isValid = false;
      }

      // 내용 체크
      if (content.value.trim() === "") {
        content.style.border = "2px solid #f4c430"; // ✅ 노란 테두리
        contentError.style.display = "block";
        isValid = false;
      }

      if (!isValid) {
        e.preventDefault();
      }
    });
  });
</script>




<%-- 5. 페이지의 끝을 마무리하는 footer 파일을 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>

