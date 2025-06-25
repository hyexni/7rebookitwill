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

<div class="container">
    <h1>1:1 문의 관리</h1>

    <%-- 문의 메타 정보 요약 테이블 --%>
    <table class="table-bordered" style="width: 100%; border-collapse: collapse;">
        <tr style="background-color: #f8f9fa;">
            <th>등록번호</th>
            <th>분류</th>
            <th>문의자</th>
            <th>등록일자</th>
            <th>처리상태</th>
        </tr>
        <tr>
            <td>${inquiry.inquiry_id}</td>
            <td>${inquiry.category}</td>
            <td>${inquiry.member_id}</td>
            <td><fmt:formatDate value="${inquiry.created_at}" pattern="yyyy-MM-dd" /></td>
            <td colspan="3">
                <c:choose>
                    <c:when test="${inquiry.status eq '답변완료'}">
                        <span class="status-badge status-done">답변완료</span>
                    </c:when>
                    <c:otherwise>
                        <span class="status-badge status-received">접수</span>
                    </c:otherwise>
                </c:choose>
            </td>
        </tr>
    </table>

    <%-- 문의 제목/내용 --%>
    <div style="margin-bottom: 30px;">
        <h3 style="font-size: 18px; font-weight: 600; margin-bottom: 10px;">제 목</h3>
        <p style="margin-bottom: 20px;">${inquiry.title}</p>

        <h3 style="font-size: 18px; font-weight: 600; margin-bottom: 10px;">내 용</h3>
        <p style="white-space: pre-line;">${inquiry.content}</p>
    </div>

    <c:choose>
    <%-- 답변이 없는 경우: 등록 폼 --%>
    <c:when test="${empty response}">
        <form method="post" action="inquiry/responseInsert">
            <input type="hidden" name="inquiry_id" value="${inquiry.inquiry_id}">
            <input type="hidden" name="ad_id" value="admin01" /> <%-- 관리자 ID 하드코딩 또는 세션값으로 대체 가능 --%>
            <div style="margin-top: 40px;">
                <label for="response_content" style="display: block; font-weight: 600; margin-bottom: 8px;">답변 작성</label>
                <textarea name="response_content" id="response_content"
                          rows="6" placeholder="답변을 입력하세요"
                          style="width: 100%; padding: 12px; font-size: 15px; border: 1px solid #ccc; border-radius: 6px;"></textarea>
            </div>
            <div style="margin-top: 20px; text-align: right;">
                <a href="list" class="btn btn-outline-primary">목록</a>
                <button type="submit" class="btn btn-primary">답변 등록</button>
            </div>
        </form>
    </c:when>

    <%-- 답변이 있는 경우: 수정/삭제 폼 --%>
    <c:otherwise>
        <form method="post" action="inquiry/responseUpdate">
            <input type="hidden" name="inquiry_id" value="${inquiry.inquiry_id}" />
            <input type="hidden" name="response_id" value="${response.response_id}" />
            <div style="margin-top: 40px;">
                <label for="response_content" style="display: block; font-weight: 600; margin-bottom: 8px;">답변 내용</label>
                <textarea name="response_content" id="response_content"
                          rows="6"
                          style="width: 100%; padding: 12px; font-size: 15px; border: 1px solid #ccc; border-radius: 6px;">${response.response_content}</textarea>
            </div>
            <div style="margin-top: 20px; text-align: right;">
                <a href="list" class="btn btn-outline-primary">목록</a>
                <button type="submit" class="btn btn-outline-primary">답변 수정</button>
                <a href="inquiry/responseDelete?response_id=${response.response_id}&inquiry_id=${inquiry.inquiry_id}"
                   class="btn btn-outline-danger"
                   onclick="return confirm('정말 삭제하시겠습니까?');">답변 삭제</a>
            </div>
        </form>
    </c:otherwise>
</c:choose>


       









<%-- 4. 하단 푸터를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>