<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원 포인트 상세 내역</title>
    <style>
        /* 이전 답변의 CSS 스타일 코드를 여기에 붙여넣으세요 */
        body { font-family: sans-serif; padding: 20px; }
        .container { max-width: 800px; margin: auto; }
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: center; }
        th { background-color: #f2f2f2; }
        .reason { text-align: left; }
        .point-plus { color: blue; font-weight: bold; }
        .point-minus { color: red; font-weight: bold; }
    </style>
</head>
<body>
    <div class="container">
        <h1>
            <c:out value="${member.member_name}"/> 님의 포인트 내역 (회원번호: <c:out value="${member.member_idx}"/>)
        </h1>
        <h3>현재 보유 포인트: <fmt:formatNumber value="${currentPoints}" pattern="#,###" /> P</h3>
        <hr>

        <h3>상세 적립/사용 내역</h3>
        <table>
            <thead>
                <tr>
                    <th>일시</th>
                    <th class="reason">내용</th>
                    <th>상태</th>
                    <th>포인트 변동</th>
                    <th>잔여 포인트</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty historyList}">
                        <tr><td colspan="5">포인트 내역이 없습니다.</td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="history" items="${historyList}">
                            <tr>
                                <td><fmt:formatDate value="${history.change_date}" pattern="yyyy-MM-dd HH:mm"/></td>
                                <td class="reason"><c:out value="${history.change_reason}"/></td>
                                <td><c:out value="${history.point_status}"/></td>
                                <td>
                                    <c:if test="${history.change_amount > 0}">
                                        <span class="point-plus">+<fmt:formatNumber value="${history.change_amount}" pattern="#,###"/></span>
                                    </c:if>
                                    <c:if test="${history.change_amount < 0}">
                                        <span class="point-minus"><fmt:formatNumber value="${history.change_amount}" pattern="#,###"/></span>
                                    </c:if>
                                </td>
                                <td><fmt:formatNumber value="${history.point_amount}" pattern="#,###"/></td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</body>
</html>