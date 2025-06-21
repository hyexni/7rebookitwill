<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 1. 페이지 기본 골격과 공통 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="include/layout_head.jsp" %>

<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@ include file="include/header.jsp" %> 

<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@ include file="include/sidebar.jsp" %> 



<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h2>1:1 문의 관리</h2>

<!-- 🔍 검색 영역 -->
<form method="get" action="list" style="text-align: right; margin-bottom: 10px;">
    <input type="text" name="keyword" placeholder="제목/작성자 검색" value="${param.keyword}">
    <button type="submit">검색</button>
</form>

<!-- 📋 문의 목록 테이블 -->
<table border="1" width="100%" style="border-collapse: collapse; text-align: center;">
    <thead>
        <tr>
            <th><a href="?sort=desc">등록번호 ▼</a></th>
            <th>작성자</th>
            <th>제목</th>
            <th>문의일</th>
            <th>처리상태</th>
            <th>처리일자</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="inquiry" items="${inquiryList}">
            <tr>
                <td>${inquiry.inquiry_id}</td>
                <td>${inquiry.member_id}</td>
                <td>
                    <a href="view?inquiry_id=${inquiry.inquiry_id}">
                        ${inquiry.title}
                    </a>
                </td>
                <td><fmt:formatDate value="${inquiry.created_at}" pattern="yyyy-MM-dd" /></td>
                <td>
                    <c:choose>
                        <c:when test="${inquiry.status eq '답변완료'}">답변완료</c:when>
                        <c:otherwise>접수</c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <c:choose>
                        <c:when test="${not empty inquiry.created_at}">
                            <fmt:formatDate value="${inquiry.created_at}" pattern="yyyy-MM-dd" />
                        </c:when>
                        <c:otherwise>-</c:otherwise>
                    </c:choose>
                </td>
            </tr>
        </c:forEach>
        <c:if test="${empty inquiryList}">
            <tr><td colspan="6">등록된 문의가 없습니다.</td></tr>
        </c:if>
    </tbody>
</table>

<!-- 📄 페이징 -->
<div style="margin-top: 20px; text-align: center;">
    <c:forEach var="i" begin="1" end="${totalPages}">
        <a href="list?page=${i}&keyword=${param.keyword}" 
           style="margin: 0 5px; ${i == currentPage ? 'font-weight:bold;' : ''}">
           ${i}
        </a>
    </c:forEach>
</div>

<!-- 🔻 (10건 단위로 페이징 처리) -->
<p style="text-align: center; font-size: 0.9em; color: gray;">(10건 단위로 페이징 처리)</p>





<%-- 4. 하단 푸터를 불러옵니다. --%>
<%@ include file="include/footer.jsp" %> 