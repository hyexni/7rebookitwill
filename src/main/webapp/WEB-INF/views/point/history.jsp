<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@include file="../include/header.jsp" %> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>포인트 내역</title>
<style>
    body {
        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
        color: #333;
        margin: 0;
        padding: 20px;
        background-color: #f4f4f9;
    }
    .container {
        max-width: 800px;
        margin: 20px auto;
        background-color: #fff;
        padding: 20px 30px;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    }
    h1, h3 {
        color: #1a1a1a;
        border-bottom: 2px solid #eee;
        padding-bottom: 10px;
    }
    .summary-box {
        background-color: #f8f9fa;
        border: 1px solid #dee2e6;
        border-radius: 8px;
        padding: 20px;
        margin-bottom: 30px;
    }
    .summary-box p {
        margin: 0 0 10px 0;
        font-size: 14px;
        color: #6c757d;
    }
    .summary-box h2 {
        margin: 0 0 15px 0;
        font-size: 24px;
        text-align: right;
    }
    .summary-box ul {
        list-style: none;
        padding: 0;
        margin: 0;
        font-size: 15px;
    }
    .summary-box ul li {
        margin-bottom: 8px;
        display: flex;
        justify-content: space-between;
    }
    .details-table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
    }
    .details-table th, .details-table td {
        border-bottom: 1px solid #ddd;
        padding: 12px 8px;
        text-align: center;
        vertical-align: middle;
    }
    .details-table th {
        background-color: #f7f7f7;
        font-weight: 600;
    }
    .details-table .reason {
        text-align: left;
    }
    .point-plus {
        color: #007bff; /* 적립: 파란색 */
        font-weight: bold;
    }
    .point-minus {
        color: #dc3545; /* 사용: 빨간색 */
        font-weight: bold;
    }
    .no-data {
        text-align: center;
        padding: 50px;
        color: #777;
        font-size: 16px;
    }
</style>
</head>
<body>

    <div class="container">
        <h1>${currentMonth}월 포인트 내역</h1>

        <div class="summary-box">
            <p>조회기간: ${startDate} ~ ${endDate}</p>
            <h2>이번 달 총 적립 혜택: 
                <span class="point-plus">+<fmt:formatNumber value="${totalBenefitAmount}" pattern="#,###" /> P</span>
            </h2>
            <hr>
            <ul>
                <li><span>구매 적립</span> <span><fmt:formatNumber value="${purchaseAmount}" pattern="#,###" /> P</span></li>
                <li><span>영수증 적립</span> <span><fmt:formatNumber value="${receiptAmount}" pattern="#,###" /> P</span></li>
                <li><span>리뷰 적립</span> <span><fmt:formatNumber value="${reviewAmount}" pattern="#,###" /> P</span></li>
                <li><span>이벤트/기타</span> <span><fmt:formatNumber value="${eventAmount}" pattern="#,###" /> P</span></li>
            </ul>
        </div>
        
        <h3>상세 적립/사용 내역</h3>
        <table class="details-table">
            <thead>
                <tr>
                    <th style="width: 25%;">일시</th>
                    <th style="width: 45%;" class="reason">내용</th>
                    <th style="width: 15%;">상태</th>
                    <th style="width: 15%;">포인트</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty pointHistoryList}">
                        <tr>
                            <td colspan="4" class="no-data">이번 달 포인트 변동 내역이 없습니다.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="history" items="${pointHistoryList}">
                            <tr>
                                <td>
                                    <fmt:formatDate value="${history.change_date}" pattern="yyyy-MM-dd HH:mm"/>
                                </td>
                                <td class="reason">
                                    <c:out value="${history.change_reason}"/>
                                </td>
                                <td>
                                    <c:out value="${history.point_status}"/>
                                </td>
                                <td>
                                    <%-- 포인트가 양수(적립)이면 파란색, 음수(사용)이면 빨간색으로 표시 --%>
                                    <c:if test="${history.change_amount > 0}">
                                        <span class="point-plus">+<fmt:formatNumber value="${history.change_amount}" pattern="#,###"/></span>
                                    </c:if>
                                    <c:if test="${history.change_amount < 0}">
                                        <span class="point-minus"><fmt:formatNumber value="${history.change_amount}" pattern="#,###"/></span>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
 <%@include file="../include/footer.jsp" %>
</body>
</html>