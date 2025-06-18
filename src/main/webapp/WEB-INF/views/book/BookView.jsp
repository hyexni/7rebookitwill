<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<!--  header include  -->
<jsp:include page="/WEB-INF/views/include/header.jsp" />

<!--  여기부터 본문 콘텐츠 작성 -->
<div class="content">
  <h1>📖 도서 상세 페이지</h1>
  
    <!-- 1️⃣ 커버 이미지 -->
  <img src="${pageContext.request.contextPath}/resources/img/book/${book.cover_image}" 
       alt="${book.book_title}" 
       style="width: 200px; height: auto; margin-bottom: 20px;" />
  
  <p>도서 제목: ${book.book_title}</p>
  <p>저자: ${book.author_name}</p>
  <p>출판사: ${book.publisher}</p>
  <p>가격: ${book.book_price}원</p>
  <!-- 여기다가 리뷰, 찜하기, 구매 버튼 등 추가할 예정이야 -->
</div>

<!--  footer include -->
<jsp:include page="/WEB-INF/views/include/footer.jsp" />