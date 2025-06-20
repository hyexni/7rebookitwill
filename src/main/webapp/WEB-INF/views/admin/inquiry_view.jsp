<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 1. 페이지 기본 골격과 공통 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>

<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@ include file="include/header.jsp" %> 

<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@ include file="include/sidebar.jsp" %> 



<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h2>1:1 문의 관리</h2>

<!-- 문의 상세 -->
    <p><strong>등록번호:</strong> ${inquiry.inquiry_id}</p>
    <p><strong>분류:</strong> 오류신고</p>
    <p><strong>문의자:</strong> ${inquiry.member_id}</p>
    <p><strong>등록일자:</strong> ${inquiry.created_at}</p>
    <p><strong>처리상태:</strong> 
        <c:choose>
            <c:when test="${empty response}">접수</c:when>
            <c:otherwise>답변완료</c:otherwise>
        </c:choose>
    </p>
    
    <hr>
    <p><strong>제목:</strong> ${inquiry.title}</p>
    <p><strong>내용:</strong><br>${inquiry.content}</p>

<!-- 답변 작성 / 수정 영역 -->
    <h4>답변 작성</h4>
    
    <c:choose>
        <c:when test="${empty response}">
            <!-- 답변 등록 -->
            <form action="insertResponse" method="post">
                <textarea name="response_content" rows="6" style="width: 100%;" placeholder="답변을 입력하세요" required></textarea>
                <input type="hidden" name="inquiry_id" value="${inquiry.inquiry_id}" />
                <input type="hidden" name="admin_id" value="admin01" />
                <button type="submit" style="margin-top: 10px;">답변 등록</button>
            </form>
        </c:when>
        
        <c:otherwise>
            <!-- 답변 수정 -->
            <form action="updateResponse" method="post">
                <textarea name="response_content" rows="6" style="width: 100%;">${response.response_content}</textarea>
                <input type="hidden" name="inquiry_id" value="${inquiry.inquiry_id}" />
                <input type="hidden" name="response_id" value="${response.response_id}" />
                <button type="submit" style="margin-top: 10px;">답변 수정</button>
            </form>

            <!-- 답변 삭제 -->
            <form action="deleteResponse" method="post" style="margin-top: 5px;">
                <input type="hidden" name="inquiry_id" value="${inquiry.inquiry_id}" />
                <input type="hidden" name="response_id" value="${response.response_id}" />
                <button type="submit" style="color: red;">답변 삭제</button>
            </form>
        </c:otherwise>
    </c:choose>











<%-- 4. 하단 푸터를 불러옵니다. --%>
<%@ include file="include/footer.jsp" %> 