 <%@include file="../include/header.jsp" %> 
 <%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<html>
<head>
    
    <title>포인트적립리스트</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f2f5;
            margin: 0;
            padding: 20px;
        }
        .container1 {
            width: 375px; /* 모바일 화면 너비에 맞춤 */
            margin: 20px auto;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            overflow: hidden; /* 자식 요소의 float 해제 */
        }
        h1 {
            font-size: 20px;
            color: #333;
            padding: 15px 20px;
            border-bottom: 1px solid #eee;
            margin: 0;
            font-weight: bold;
        }

        /* 2번 영역: 월별 포인트 요약 */
        .summary-section {
            padding: 20px;
            border-bottom: 1px solid #eee;
        }
        .month-selector {
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 16px;
            font-weight: bold;
            color: #555;
            margin-bottom: 15px;
        }
        .month-selector button {
            background: none;
            border: none;
            font-size: 20px;
            cursor: pointer;
            color: #999;
            padding: 0 10px;
        }
        .month-selector span {
            margin: 0 10px;
        }
        .total-benefit {
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-size: 22px;
            font-weight: bold;
            color: #333;
            margin-bottom: 15px;
        }
        .total-benefit .help-icon {
            font-size: 14px;
            color: #888;
            margin-left: 5px;
            cursor: pointer;
        }
        .category-summary {
            margin-top: 20px;
        }
        .category-item {
            display: flex;
            align-items: center;
            margin-bottom: 8px;
            font-size: 14px;
            color: #666;
        }
        .category-item span:first-child {
            flex-basis: 70px; /* 카테고리 이름 고정 너비 */
        }
        .category-bar-container1 {
            flex-grow: 1;
            height: 8px;
            background-color: #e0e0e0;
            border-radius: 4px;
            margin-right: 10px;
            overflow: hidden;
        }
        .category-bar {
            height: 100%;
            border-radius: 4px;
            background-color: #4CAF50; /* 초록색 바 */
            width: 0%; /* JavaScript로 동적으로 변경 */
        }
        .category-item.purchase .category-bar { background-color: #62C1C9; } /* 구매 색상 */
        .category-item.receipt .category-bar { background-color: #2196F3; } /* 영수증 색상 */
        .category-item.review .category-bar { background-color: #FFC107; } /* 리뷰 색상 */
        .category-item.event .category-bar { background-color: #9C27B0; } /* 이벤트/기타 색상 */
        .category-item span:last-child {
            font-weight: bold;
            color: #333;
            width: 50px; /* 금액 고정 너비 */
            text-align: right;
        }

        /* 3번 영역: 포인트 내역 리스트 */
        .list-section {
            padding: 20px;
        }
        .tab-buttons {
            display: flex;
            justify-content: center;
            margin-bottom: 20px;
            border: 1px solid #ddd;
            border-radius: 5px;
            overflow: hidden;
        }
        .tab-buttons button {
            flex: 1;
            padding: 10px 0;
            background-color: #f8f8f8;
            border: none;
            cursor: pointer;
            font-size: 15px;
            color: #555;
            font-weight: bold;
            transition: background-color 0.2s, color 0.2s;
        }
        .tab-buttons button:not(:last-child) {
            border-right: 1px solid #ddd;
        }
        .tab-buttons button.active {
            background-color: #62C1C9; /* 활성화된 탭 색상 */
            color: white;
        }
        .point-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid #eee;
            font-size: 15px;
        }
        .point-item:last-child {
            border-bottom: none;
        }
        .point-item .date {
            flex-basis: 70px;
            color: #888;
        }
        .point-item .description {
            flex-grow: 1;
            color: #333;
            margin-left: 10px;
        }
        .point-item .amount {
            font-weight: bold;
            text-align: right;
            width: 80px;
        }
        .point-item .amount.plus {
            color: #4CAF50; /* 적립 포인트 색상 */
        }
        .point-item .amount.minus {
            color: #F44336; /* 사용 포인트 색상 */
        }
    </style>
</head>
<body>
    <div class="container1">
        <h1>포인트적립리스트</h1>

        <div class="summary-section">
            <div class="month-selector">
                <button>&lt;</button>
                <span>${currentMonth}월</span>
                <span>${startDate} ~ ${endDate}.</span>
                <button>&gt;</button>
            </div>
            <div class="total-benefit">
                <span>총 적립 혜택 <span class="help-icon">?</span></span>
                <span><fmt:formatNumber value="${totalBenefitAmount}" type="number" />원 <span style="font-size: 16px;">▲</span></span>
            </div>
            <div class="category-summary">
                <div class="category-item purchase">
                    <span>구매</span>
                    <div class="category-bar-container1">
                        <div class="category-bar" style="width: ${purchaseAmount * 100 / (totalBenefitAmount > 0 ? totalBenefitAmount : 1)}%;"></div>
                    </div>
                    <span><fmt:formatNumber value="${purchaseAmount}" type="number" />원</span>
                </div>
                <div class="category-item receipt">
                    <span>영수증</span>
                    <div class="category-bar-container1">
                        <div class="category-bar" style="width: ${receiptAmount * 100 / (totalBenefitAmount > 0 ? totalBenefitAmount : 1)}%;"></div>
                    </div>
                    <span><fmt:formatNumber value="${receiptAmount}" type="number" />원</span>
                </div>
                <div class="category-item review">
                    <span>리뷰</span>
                    <div class="category-bar-container1">
                        <div class="category-bar" style="width: ${reviewAmount * 100 / (totalBenefitAmount > 0 ? totalBenefitAmount : 1)}%;"></div>
                    </div>
                    <span><fmt:formatNumber value="${reviewAmount}" type="number" />원</span>
                </div>
                <div class="category-item event">
                    <span>이벤트/기타</span>
                    <div class="category-bar-container1">
                        <div class="category-bar" style="width: ${eventAmount * 100 / (totalBenefitAmount > 0 ? totalBenefitAmount : 1)}%;"></div>
                    </div>
                    <span><fmt:formatNumber value="${eventAmount}" type="number" />원</span>
                </div>
            </div>
        </div>

        <div class="list-section">
            <div class="tab-buttons">
                <button class="active" onclick="filterPoints('all')">전체</button>
                <button onclick="filterPoints('accumulate')">적립</button>
                <button onclick="filterPoints('use')">사용</button>
            </div>

            <div id="pointList">
                <c:if test="${empty pointHistoryList}">
                    <p style="text-align: center; color: #777;">조회된 포인트 내역이 없습니다.</p>
                </c:if>
                <c:forEach var="history" items="${pointHistoryList}">
                    <div class="point-item" data-type="${history.changeAmount > 0 ? 'accumulate' : 'use'}">
                        <span class="date"><fmt:formatDate value="${history.changeDate}" pattern="MM.dd" /></span>
                        <span class="description">${history.changeReason}</span>
                        <span class="amount ${history.changeAmount > 0 ? 'plus' : 'minus'}">
                            <c:if test="${history.changeAmount > 0}">+</c:if>
                            <fmt:formatNumber value="${history.changeAmount}" type="number" />원
                        </span>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
    
    

    <script>
        function filterPoints(type) {
            const buttons = document.querySelectorAll('.tab-buttons button');
            buttons.forEach(btn => btn.classList.remove('active'));

            document.querySelector(`.tab-buttons button[onclick="filterPoints('${type}')"]`).classList.add('active');

            const pointItems = document.querySelectorAll('.point-item');
            pointItems.forEach(item => {
                if (type === 'all') {
                    item.style.display = 'flex';
                } else {
                    if (item.dataset.type === type) {
                        item.style.display = 'flex';
                    } else {
                        item.style.display = 'none';
                    }
                }
            });
        }

        // 초기 로드 시 "전체" 탭 활성화 (CSS로 이미 설정되어 있지만 명시적으로)
        document.addEventListener('DOMContentLoaded', () => {
            filterPoints('all');
        });

        // 카테고리 바 width 계산 및 설정 (초기값은 JSP에서 직접 계산)
        // JavaScript로 동적으로 처리하고 싶다면, 이곳에서 계산 로직 추가
        // 예시: const total = ${totalBenefitAmount};
        // const purchaseWidth = (${purchaseAmount} / total) * 100;
        // document.querySelector('.category-item.purchase .category-bar').style.width = purchaseWidth + '%';
    </script>

	
 <%@include file="../include/footer.jsp" %> 
 
 </body>
</html>
<!-- 템플릿 푸터 추가 -->