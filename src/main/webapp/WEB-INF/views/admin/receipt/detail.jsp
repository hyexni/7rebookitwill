<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>


<%-- 1. 페이지 기본 골격과 공통 CSS/폰트 링크를 불러옵니다. --%>
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
        /* [개선] 정보가 없을 때 표시할 텍스트 스타일 추가 */
        .text-muted { color: #6c757d; font-style: italic; }
        
        .highlight { background-color: #e8f6ff; padding: 15px; border-radius: 5px; margin-top: 20px; }
        .highlight strong { font-size: 20px; color: #007bff; }
        
        /* [수정] 버튼 기본 스타일 */
    .btn-link {
        display: inline-block; /* 버튼 정렬 및 크기 적용을 위함 */
        text-decoration: none; /* 밑줄 제거 */
        color: white; /* 글자색 */
        font-size: 16px; /* 글자 크기 키우기 */
        font-weight: bold; /* 글자 굵게 */
        
        background-color: #007bff; /* 기본 배경색 */
        padding: 12px 24px; /* 내부 여백을 늘려 버튼 크기 키우기 */
        margin-top: 2em; /* 위쪽 여백 */
        margin-right: 10px; /* 오른쪽 여백 (버튼 사이 간격) */
        
        border: none; /* 테두리 제거 */
        border-radius: 8px; /* 모서리를 더 둥글게 */
        box-shadow: 0 2px 5px rgba(0,0,0,0.15); /* 입체감을 위한 그림자 */
        
        cursor: pointer; /* 마우스 커서를 손가락 모양으로 */
        transition: all 0.3s ease; /* 모든 효과를 0.3초 동안 부드럽게 전환 */
    }

/*     /* [추가] 마우스를 버튼에 올렸을 때 스타일 */ */
/*     .btn-link:hover { */
/*         background-color: #0056b3; /* 배경색을 더 진하게 */ */
/*         box-shadow: 0 4px 12px rgba(0,0,0,0.2); /* 그림자를 더 강조 */ */
/*         transform: translateY(-2px); /* 버튼이 살짝 위로 떠오르는 효과 */ */
/*     } */
        
        
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
                <strong>이름:</strong>
                <%-- [개선] ocr_store 값이 비어있지 않을 때만 표시 --%>
                <c:choose>
                    <c:when test="${not empty memberVO.member_name}">
                        ${memberVO.member_name}
                    </c:when>
                    <c:otherwise>
                        <span class="text-muted">인식된 정보 없음</span>
                    </c:otherwise>
                </c:choose>
            </p>
            <p>
                <strong>구매처:</strong>
                <%-- [개선] ocr_store 값이 비어있지 않을 때만 표시 --%>
                <c:choose>
                    <c:when test="${not empty receiptDetail.ocr_store}">
                        ${receiptDetail.ocr_store}
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
                    <c:when test="${not empty receiptDetail.ocr_date}">
                        <fmt:formatDate value="${receiptDetail.ocr_date}" pattern="yyyy년 MM월 dd일 HH:mm:ss"/>
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
                    <c:when test="${not empty receiptDetail.ocr_booktitle}">
                        ${receiptDetail.ocr_booktitle}
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
                    <c:when test="${receiptDetail.ocr_amount > 0}">
                        <span style="color: #d9534f; font-weight: bold;">
                            <fmt:formatNumber value="${receiptDetail.ocr_amount}" pattern="#,###"/> 원
                        </span>
                    </c:when>
                    <c:otherwise>
                        <span class="text-muted">인식된 정보 없음</span>
                    </c:otherwise>
                </c:choose>
            </p>
        </div>
        
        <%-- ========================================================== --%>
        <%-- ★★★★★ receipt 객체에 추가한 earnedPoints를 출력합니다. ★★★★★ --%>
        <%-- ========================================================== --%>
        <div class="highlight">
            <p>적립된 포인트: <strong><fmt:formatNumber value="${receiptDetail.earnedPoints}" pattern="#,##0" /> 점</strong></p>
        </div>
        
        

               
        <a href="${pageContext.request.contextPath}/receipt/upload" class="btn-link">🔄 목록으로 가기</a>
         <a href="${pageContext.request.contextPath}/recommend/byReceipt" class="btn-link">🔄 영수증 기반 추천도서</a>
    </div>
    
    <%-- 5. 하단 푸터 --%>
<%@include file="../include/footer.jsp" %>

