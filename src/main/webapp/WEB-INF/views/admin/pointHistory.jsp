<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@include file="../include/header.jsp" %>
<html>
<head>
    <title>관리자 - 포인트 관리</title>
    <style> /* 이전 답변의 CSS 스타일 참고 */ </style>
</head>
<body>
    <div class="container">
        <h1>
            <c:out value="${member.user_name}"/> (ID: <c:out value="${member.user_id}"/>) 님의 포인트 내역
        </h1>
        <h3>현재 보유 포인트: <fmt:formatNumber value="${member.point}" pattern="#,###" /> P</h3>
        
        <table class="items-table">
            <thead>
                <tr>
                    <th>내역 ID</th>
                    <th>거래 시점</th>
                    <th>사유</th>
                    <th>변동 포인트</th>
                    <th>연동 주문번호</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="history" items="${historyList}">
                    <tr>
                        <td>${history.historyId}</td>
                        <td><fmt:formatDate value="${history.transactionDate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                        <td><c:out value="${history.reason}"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${history.pointChange > 0}">
                                    <span style="color:blue; font-weight:bold;">+<fmt:formatNumber value="${history.pointChange}" pattern="#,###" /></span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color:red; font-weight:bold;"><fmt:formatNumber value="${history.pointChange}" pattern="#,###" /></span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:if test="${not empty history.orderId}">
                                <a href="/admin/orders/${history.orderId}">${history.orderId}</a>
                            </c:if>
                            <c:if test="${empty history.orderId}">
                                -
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</body>
</html>
 <%@include file="../include/footer.jsp" %> 