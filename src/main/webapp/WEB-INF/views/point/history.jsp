<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 1. 페이지 기본 골격과 공통 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>

<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/header.jsp" %>

<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>

<%-- 
=========================================================================
    [핵심] 이 페이지의 콘텐츠에만 적용될 전용 스타일 정의
=========================================================================
--%>
<style>
    /* 이 스타일 블럭은 pointHistory.jsp 에서만 사용됩니다.
      다른 페이지에 영향을 주지 않도록 모든 선택자 앞에 
      고유 클래스인 .point-history-container 를 붙여 범위를 제한합니다.
    */

    .point-history-container h1 {
        font-size: 28px;
        font-weight: 700;
        color: #2c3e50;
        margin-top: 0;
        margin-bottom: 8px;
        text-align: center;
    }

    .point-history-container .subtitle {
        font-size: 16px;
        color: #7f8c8d;
        text-align: center;
        margin-bottom: 40px;
    }

    /* 현재 보유 포인트 요약 박스 */
    .point-history-container .current-points {
        background: linear-gradient(135deg, #3498db, #2980b9);
        color: #fff;
        padding: 20px 30px;
        border-radius: 10px;
        margin-bottom: 30px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        box-shadow: 0 4px 15px rgba(52, 152, 219, 0.4);
    }

    .point-history-container .current-points span {
        font-size: 18px;
        font-weight: 500;
    }

    .point-history-container .current-points strong {
        font-size: 26px;
        font-weight: 700;
    }

    /* "상세 변동 내역"과 같은 섹션 제목 */
    .point-history-container .section-title {
        font-size: 20px;
        text-align: center;
        color: #34495e;
        margin-top: 40px;
        margin-bottom: 20px;
        border-bottom: 2px solid #ecf0f1;
        padding-bottom: 10px;
    }

    /* 포인트 내역 테이블 */
    .point-history-container table {
        width: 100%;
        border-collapse: collapse;
        margin-bottom: 30px;
    }

    .point-history-container th, 
    .point-history-container td {
        padding: 15px;
        text-align: center;
        border-bottom: 1px solid #ecf0f1;
    }

    .point-history-container thead {
        background-color: #f8f9fa;
    }

    .point-history-container th {
        font-weight: 700;
        color: #34495e;
        font-size: 14px;
    }

    .point-history-container tbody tr:hover {
        background-color: #f9f9f9;
    }

    .point-history-container td {
        font-size: 15px;
        color: #555;
    }

    /* 포인트 변동량 글자색 */
    .point-history-container td.positive {
        color: #27ae60;
        font-weight: 700;
    }

    .point-history-container td.negative {
        color: #e74c3c;
        font-weight: 700;
    }

    /* 내역이 없을 때 메시지 박스 */
    .point-history-container .no-records {
        text-align: center;
        padding: 40px;
        background-color: #fafafa;
        color: #999;
        border-radius: 8px;
        border: 1px dashed #ddd;
    }
</style>


<%-- 
=========================================================================
            이 페이지의 실제 콘텐츠는 여기부터 시작됩니다.                   
=========================================================================
--%>

<%-- 공통 레이아웃의 메인 콘텐츠 영역을 지정하는 태그 (예시) --%>
<main class="main-content">
    <%-- 이 페이지의 모든 콘텐츠를 감싸는 고유한 컨테이너 클래스 추가 --%>
    <div class="point-history-container">
        <h1>포인트 내역</h1>
        <p class="subtitle">나의 포인트 적립 및 사용 내역을 확인하세요.</p>

        <%-- 현재 총 포인트 --%>
        <div class="current-points">
            <span>현재 보유 포인트</span>
            <strong><fmt:formatNumber value="${totalPoints}" type="number"/> P</strong>
        </div>
            
        <%-- 포인트 상세 내역 테이블 --%>
    
        <h2 class="section-title">상세 변동 내역</h2>
        
        <c:choose>
            <c:when test="${not empty pointHistoryList}">
                <table>
                    <thead>
                        <tr>
                            <th>번호</th>
                            <th>변동 일시</th>
                            <th>변동 사유</th>
                            <th>변동 포인트</th>
                            <th>거래 후 잔액</th>
                            <th>상태</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="point" items="${pointHistoryList}" varStatus="status">
                            <tr>
                                <td>${status.count}</td>
                                <td>
                                    <fmt:formatDate value="${point.change_date}" pattern="yyyy.MM.dd HH:mm"/>
                                </td>
                                <td>${point.change_reason}</td>
                                <td class="<c:if test='${point.change_amount > 0}'>positive</c:if><c:if test='${point.change_amount < 0}'>negative</c:if>">
                                    <fmt:formatNumber value="${point.change_amount}" pattern="+ #,##0;- #,##0"/>
                                </td>
                                <td>
                                    <fmt:formatNumber value="${point.point_amount}" type="number"/> P
                                </td>
                                <td>${point.point_status}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <p class="no-records">조회 가능한 포인트 내역이 없습니다.</p>
            </c:otherwise>
        </c:choose>

    </div> <%-- /.point-history-container --%>
</main> <%-- /.main-content --%>


<%-- 4. 하단 푸터를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>