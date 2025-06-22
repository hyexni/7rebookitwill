<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%-- 1. 페이지 기본 골격과 CSS/폰트 링크 --%>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>

    <title>OCR 결과 보기</title>
    <style>
    
        .container { max-width: 800px; margin: 20px; background-color: #fff; padding: 2em; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.05); }
        h1, h2 { color: #0056b3; }
        .summary-box { border: 1px solid #dee2e6; padding: 1.5em; border-radius: 8px; margin-bottom: 2em; }
        .summary-box h2 { margin-top: 0; }
        .summary-box p { font-size: 1.1em; margin: 0.5em 0; }
        .summary-box strong { color: #343a40; min-width: 120px; display: inline-block; }
        .items-table { width: 100%; border-collapse: collapse; margin-top: 1em; }
        .items-table th, .items-table td { border: 1px solid #dee2e6; padding: 12px; text-align: left; }
        .items-table thead { background-color: #e9ecef; }
        .items-table td.center { text-align: center; }
        .items-table td.right { text-align: right; }
        pre { background-color: #f1f3f5; padding: 1em; border: 1px solid #ced4da; white-space: pre-wrap; word-wrap: break-word; }
        .btn-link { text-decoration: none; background-color: #007bff; color: white; padding: 10px 15px; border-radius: 5px; display: inline-block; margin-top: 2em; }
        /* [개선] 정보가 없을 때 표시할 텍스트 스타일 추가 */
        .text-muted { color: #6c757d; font-style: italic; }
        
        .highlight { background-color: #e8f6ff; padding: 15px; border-radius: 5px; margin-top: 20px; }
        .highlight strong { font-size: 20px; color: #007bff; }
        
    </style>

<%-- 2. 상단 헤더 --%>
<%@ include file="/WEB-INF/views/include/header.jsp" %> 

<%-- 3. 왼쪽 사이드바 --%>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>


    <div class="container">
        <h1>🧾 영수증 인식 결과</h1>

        <div class="summary-box">
            <h2>영수증 요약</h2>
            <p>
                <strong>구매처:</strong>
                <%-- [개선] ocr_store 값이 비어있지 않을 때만 표시 --%>
                <c:choose>
                    <c:when test="${not empty uploadResult.ocr_store}">
                        ${uploadResult.ocr_store}
                    </c:when>
                    <c:otherwise>
                        <span class="text-muted">인식된 정보 없음</span>
                    </c:otherwise>
                </c:choose>
            </p>
            <p>
                <strong>구매일시:</strong>
                <%-- [개선] ocr_date 값이 비어있지 않을 때만 표시 --%>
                <c:choose>
                    <c:when test="${not empty uploadResult.ocr_date}">
                        <fmt:formatDate value="${uploadResult.ocr_date}" pattern="yyyy년 MM월 dd일 HH:mm:ss"/>
                    </c:when>
                    <c:otherwise>
                        <span class="text-muted">인식된 정보 없음</span>
                    </c:otherwise>
                </c:choose>
            </p>
            <p>
                <strong>도서명:</strong>
                <%-- [개선] ocr_store 값이 비어있지 않을 때만 표시 --%>
                <c:choose>
                    <c:when test="${not empty uploadResult.ocr_booktitle}">
                        ${uploadResult.ocr_booktitle}
                    </c:when>
                    <c:otherwise>
                        <span class="text-muted">인식된 정보 없음</span>
                    </c:otherwise>
                </c:choose>
            </p>
            <p>
                <strong>총 결제 금액:</strong>
                <%-- [개선] ocr_amount 값이 0보다 클 때만 표시 --%>
                <c:choose>
                    <c:when test="${uploadResult.ocr_amount > 0}">
                        <span style="color: #d9534f; font-weight: bold;">
                            <fmt:formatNumber value="${uploadResult.ocr_amount}" pattern="#,###"/> 원
                        </span>
                    </c:when>
                    <c:otherwise>
                        <span class="text-muted">인식된 정보 없음</span>
                    </c:otherwise>
                </c:choose>
            </p>
        </div>
        
        <%-- ========================================================== --%>
        <%-- ★★★★★ uploadResult 객체에 추가한 earnedPoints를 출력합니다. ★★★★★ --%>
        <%-- ========================================================== --%>
        <div class="highlight">
            <p>적립된 포인트: <strong><fmt:formatNumber value="${uploadResult.earnedPoints}" pattern="#,##0" /> 점</strong></p>
        </div>
        
        
        <h2>구매 품목 목록</h2>
        <%-- [개선] items 리스트가 비어있지 않을 때만 테이블을 표시 --%>
        <c:choose>
            <c:when test="${not empty uploadResult.items}">
                <table class="items-table">
                    <thead>
                        <tr>
                            <th>품명 (도서명)</th>
                            <th class="center">수량</th>
                            <th class="right">단가</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${uploadResult.items}">
                            <tr>
                                <td>${item.bookTitle}</td>
                                <td class="center">${item.quantity}</td>
                                <td class="right">
                                    <fmt:formatNumber value="${item.price}" pattern="#,###"/> 원
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <p class="text-muted">인식된 구매 품목이 없습니다.</p>
            </c:otherwise>
        </c:choose>

       
        
        <a href="${pageContext.request.contextPath}/receipt/upload" class="btn-link">🔄 다시 업로드하기</a>
    </div>
    
    <%-- 5. 하단 푸터 --%>
<%@include file="../include/footer.jsp" %>

