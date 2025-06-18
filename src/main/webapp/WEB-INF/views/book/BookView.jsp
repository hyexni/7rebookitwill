<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!--  페이지 타이틀 설정 -->
<c:set var="pageTitle" value="도서 상세 페이지" />

<!--  헤더 include -->
<jsp:include page="/WEB-INF/views/include/header.jsp" />

<!--  도서 상세 콘텐츠 시작 -->
<div class="book-detail-wrapper" style="display: flex; gap: 40px; padding: 40px;">

  <!-- 1️⃣ 책 표지 이미지 영역 -->
  <div class="book-image">
    <img src="${pageContext.request.contextPath}/resources/img/book/${empty book.cover_image ? 'no_image.png' : book.cover_image}" 
         alt="${book.book_title}" 
         style="width: 240px; height: auto; border: 1px solid #ccc;" />
  </div>

  <!-- 2️⃣ 책 정보 영역 -->
  <div class="book-info" style="flex: 1;">
    <h2 style="margin-bottom: 20px;">📖 ${empty book.book_title ? '제목 정보 없음' : book.book_title}</h2>

    <p><strong>저자:</strong> ${empty book.author_name ? '저자 정보 없음' : book.author_name}</p>
    <p><strong>출판사:</strong> ${empty book.publisher ? '출판사 정보 없음' : book.publisher}</p>

    <p><strong>가격:</strong> 
      <c:choose>
        <c:when test="${book.book_price == 0}">가격 정보 없음</c:when>
        <c:otherwise>${book.book_price}원</c:otherwise>
      </c:choose>
    </p>

    <p><strong>출판일:</strong> 
      <c:choose>
        <c:when test="${empty book.publish_date}">출판일 정보 없음</c:when>
        <c:otherwise>${book.publish_date}</c:otherwise>
      </c:choose>
    </p>

    <p><strong>책 소개:</strong></p>
    <p style="white-space: pre-line;">
      ${empty book.book_summary ? '책 소개가 등록되지 않았습니다.' : book.book_summary}
    </p>

    <p><strong>판매 상태:</strong> 
      ${empty book.stock_status ? '판매 상태 미정' : book.stock_status}
    </p>
  </div>

</div>

<!-- 푸터 include -->
<jsp:include page="/WEB-INF/views/include/footer.jsp" />
