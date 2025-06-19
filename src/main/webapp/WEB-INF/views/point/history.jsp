<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RE:BOOK - 포인트 내역</title>
    <%-- [추가] 웹 폰트 링크 --%>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    
    <%-- [핵심 수정] CSS 코드를 <style> 태그 안에 직접 포함 --%>
    <style>
        /* Google Web Font Import */
        @import url('https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap');

        /* Basic Reset & Body Style */
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #f4f6f9;
            color: #333;
            margin: 0;
            padding: 40px 20px;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            min-height: 100vh;
        }

        /* Main Container */
        .container {
            width: 100%;
            max-width: 900px;
            background-color: #ffffff;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
        }

        h1 {
            font-size: 28px;
            font-weight: 700;
            color: #2c3e50;
            margin-top: 0;
            margin-bottom: 8px;
            text-align: center;
        }

        .subtitle {
            font-size: 16px;
            color: #7f8c8d;
            text-align: center;
            margin-bottom: 40px;
        }

        /* Message Styles */
        .message {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 8px;
            text-align: center;
            font-weight: 500;
        }

        .message.success {
            background-color: #e8f5e9;
            color: #2e7d32;
            border: 1px solid #c8e6c9;
        }

        .message.error {
            background-color: #ffebee;
            color: #c62828;
            border: 1px solid #ffcdd2;
        }

        /* Current Points Display */
        .current-points {
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

        .current-points span {
            font-size: 18px;
            font-weight: 500;
        }

        .current-points strong {
            font-size: 26px;
            font-weight: 700;
        }

        /* Table Styles */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 30px;
        }

        th, td {
            padding: 15px;
            text-align: center;
            border-bottom: 1px solid #ecf0f1;
        }

        thead {
            background-color: #f8f9fa;
        }

        th {
            font-weight: 700;
            color: #34495e;
            font-size: 14px;
        }

        tbody tr:hover {
            background-color: #f9f9f9;
        }

        td {
            font-size: 15px;
            color: #555;
        }

        /* Point Change Colors */
        td.positive {
            color: #27ae60;
            font-weight: 700;
        }

        td.negative {
            color: #e74c3c;
            font-weight: 700;
        }

        /* No Records Message */
        .no-records {
            text-align: center;
            padding: 40px;
            background-color: #fafafa;
            color: #999;
            border-radius: 8px;
            border: 1px dashed #ddd;
        }

        /* Point Management Forms */
        .point-forms {
            background-color: #fdfdfd;
            border: 1px solid #eee;
            padding: 25px;
            border-radius: 10px;
            margin-top: 30px;
        }

        .point-forms h3 {
            margin-top: 0;
            margin-bottom: 20px;
            text-align: center;
            color: #34495e;
            font-size: 18px;
        }

        .form-wrapper {
            display: flex;
            gap: 30px;
            justify-content: center;
        }

        .point-forms form {
            flex: 1;
            padding: 20px;
            background-color: #fff;
            border: 1px solid #eaeaea;
            border-radius: 8px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            font-weight: 500;
            margin-bottom: 8px;
            color: #555;
        }

        .point-forms input[type="number"],
        .point-forms input[type="text"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
            transition: border-color 0.3s;
        }

        .point-forms input:focus {
            outline: none;
            border-color: #3498db;
        }

        .point-forms button {
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 5px;
            color: #fff;
            background-color: #3498db;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .point-forms button:hover {
            background-color: #2980b9;
        }

        .point-forms button.use-btn {
            background-color: #e74c3c;
        }

        .point-forms button.use-btn:hover {
            background-color: #c0392b;
        }

        /* Back Link */
        .back-link {
            text-align: center;
            margin-top: 40px;
        }

        .back-link a {
            color: #3498db;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s;
        }

        .back-link a:hover {
            color: #2980b9;
            text-decoration: underline;
        }

        /* Responsive Styles */
        @media (max-width: 768px) {
            .container {
                padding: 20px;
            }

            .current-points {
                flex-direction: column;
                gap: 10px;
                text-align: center;
            }

            .form-wrapper {
                flex-direction: column;
                gap: 15px;
            }

            table {
                font-size: 14px;
            }
            
            th, td {
                padding: 10px 8px;
            }
        }
    </style>
</head>


<body>



    <%-- [추가] 전체 콘텐츠를 감싸는 컨테이너 --%>
    <div class="container">
        <h1>포인트 내역</h1>
        <p class="subtitle">나의 포인트 적립 및 사용 내역을 확인하세요.</p>

        <%-- 메시지 출력 영역 --%>
        <c:if test="${not empty message}">
            <p class="message success">${message}</p>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <p class="message error">${errorMessage}</p>
        </c:if>

        <%-- 현재 총 포인트 --%>
        <div class="current-points">
            <span>현재 보유 포인트</span>
            <strong><fmt:formatNumber value="${totalPoints}" type="number"/> P</strong>
        </div>

        <%-- 포인트 내역 테이블 --%>
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
                                <td><fmt:formatDate value="${point.change_date}" pattern="yyyy.MM.dd HH:mm"/></td>
                                <td>${point.change_reason}</td>
                                <td class="<c:if test='${point.change_amount > 0}'>positive</c:if><c:if test='${point.change_amount < 0}'>negative</c:if>">
                                    <fmt:formatNumber value="${point.change_amount}" type="number" pattern="+ #,##0;- #,##0"/>
                                </td>
                                <td><fmt:formatNumber value="${point.point_amount}" type="number"/> P</td>
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

        <%-- 포인트 관리 테스트 폼 --%>
        <div class="point-forms">
            <h3>포인트 관리 (테스트용)</h3>
            <div class="form-wrapper">
                <form action="${pageContext.request.contextPath}/point/earn" method="post">
                    <div class="form-group">
                        <label for="earnAmount">적립 포인트:</label>
                        <input type="number" id="earnAmount" name="amount" required min="1" placeholder="예: 500">
                    </div>
                    <div class="form-group">
                        <label for="earnReason">사유:</label>
                        <input type="text" id="earnReason" name="reason" value="테스트 적립">
                    </div>
                    <button type="submit">포인트 적립</button>
                </form>

                <form action="${pageContext.request.contextPath}/point/use" method="post">
                     <div class="form-group">
                        <label for="useAmount">사용 포인트:</label>
                        <input type="number" id="useAmount" name="amount" required min="1" placeholder="예: 300">
                    </div>
                    <div class="form-group">
                        <label for="useReason">사유:</label>
                        <input type="text" id="useReason" name="reason" value="테스트 사용">
                    </div>
                    <button type="submit" class="use-btn">포인트 사용</button>
                </form>
            </div>
        </div>

        <p class="back-link"><a href="/">메인으로 돌아가기</a></p>
    </div>
</body>
</html>