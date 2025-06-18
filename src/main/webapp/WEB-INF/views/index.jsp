<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ReBook</title>
    <%-- 
      전통적인 Spring MVC 구조에서는 resources 폴더 아래의 정적 파일을 가리키도록 경로를 설정합니다.
      <c:url> 태그는 컨텍스트 경로(Context Path)를 자동으로 포함해줘서 안정적인 URL을 만들어줍니다.
    --%>
       
       <!-- 글자체 수정 -->
       <link rel="preconnect" href="https://fonts.googleapis.com">
		<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
		<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
       
   		 <link rel="stylesheet" href="<c:url value='/resources/css/style.css'/>">
    
       <link rel="stylesheet" href="${pageContext.request.contextPath }/resources/css/custom.css">
    
    
    </head>
<body>
<%@include file="./include/header.jsp" %>

     <%-- 메인 콘텐츠 영역의 헤더 (여기에 검색창/로그인 위치) --%>
            <header class="main-header">
                <%-- ★★★ 검색/로그인/회원가입 그룹 ★★★ --%>
                <div class="user-menu">
                    <div class="search-box">
                        <input type="search" name="search" placeholder="도서, 저자, 출판사 검색">
                        <button type="submit">검색</button>
                    </div>
                    <div class="auth-buttons">
                        <a href="#">로그인</a>
                        <a href="#">회원가입</a>
                    </div>
                </div>
            </header>

    <main>
        <section class="main-banner">
            <img src="<c:url value='/resources/images/main-banner.jpg'/>" alt="메인 배너 이미지"
                 onerror="this.onerror=null; this.src='https://via.placeholder.com/1200x400';">
        </section>

        <section class="book-section">
            <h2>인기 도서</h2>
            <div class="book-list">
                <div class="book-card">
                    <img src="<c:url value='/resources/images/book-cover.png'/>" alt="책 표지"
                         onerror="this.onerror=null; this.src='https://via.placeholder.com/150x220';">
                    <h3>책 제목</h3>
                    <p>저자 이름</p>
                </div>
                </div>
        </section>

    </main>


 <%@include file="./include/footer.jsp" %>
</body>
</html>