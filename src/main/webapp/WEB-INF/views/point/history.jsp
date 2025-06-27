<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> <%-- JSTL functions 라이브러리 추가 --%>


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
    /* 전체 레이아웃을 감싸는 컨테이너 */
    .point-page-container {
        padding: 24px;
        background-color: #f0f2f5; /* 밝은 회색 배경 */
        font-family: -apple-system, BlinkMacSystemFont, "Apple SD Gothic Neo", "Malgun Gothic", "맑은 고딕", sans-serif;
    }

    /* 페이지 제목 */
    .point-page-container .page-title {
        font-size: 28px;
        font-weight: 800;
        color: #1e2022;
        margin: 0 0 24px 0;
    }

    /* 카드 형태의 공통 스타일 */
    .card {
        background-color: #ffffff;
        padding: 24px;
        border-radius: 18px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        margin-bottom: 20px;
    }

    /* 보유 포인트 카드 */
    .point-balance-card .label {
        font-size: 16px;
        color: #666;
    }
    .point-balance-card .amount {
        font-size: 38px;
        font-weight: 800;
        color: #2c3e50;
        margin-top: 8px;
        display: flex;
        align-items: baseline;
    }
    .point-balance-card .amount .unit {
        font-size: 28px;
        font-weight: 600;
        margin-left: 4px;
    }
    
    /* 액션 버튼 */
    .action-buttons {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 12px;
        margin-top: 24px;
    }
    .action-buttons .btn {
        padding: 14px;
        font-size: 16px;
        font-weight: 600;
        border-radius: 12px;
        text-align: center;
        text-decoration: none;
        cursor: pointer;
        transition: background-color 0.2s, transform 0.1s;
    }
    .action-buttons .btn:active {
        transform: scale(0.98);
    }
    .action-buttons .btn-primary {
        background-color: #03c75a;
        color: white;
    }

    /* 월별 내역 카드 */
    .month-selector {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 24px;
    }
    .month-selector .month-display {
        font-size: 24px;
        font-weight: 700;
        color: #2c3e50;
    }
    .month-selector .nav-arrow {
        font-size: 30px;
        color: #bdc3c7;
        cursor: pointer;
        font-weight: bold;
    }

    /* 적립 혜택 요약 그래프 */
    .benefit-breakdown .summary {
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-size: 18px;
        font-weight: 600;
        margin-bottom: 24px;
        padding-bottom: 16px;
        border-bottom: 1px solid #f0f2f5;
    }

    .benefit-breakdown .item {
        display: flex;
        align-items: center;
        margin-bottom: 14px;
        font-size: 15px;
    }
    .benefit-breakdown .item .label {
        width: 100px;
        flex-shrink: 0;
        color: #555;
    }
    .benefit-breakdown .item .bar-container {
        flex-grow: 1;
        height: 10px;
        background-color: #eef0f2;
        border-radius: 5px;
        overflow: hidden;
    }
    .benefit-breakdown .item .bar {
        height: 100%;
        border-radius: 5px;
        transition: width 0.5s ease-in-out;
    }
    .benefit-breakdown .item .bar-purchase { background: linear-gradient(90deg, #9b59b6, #8e44ad); }
    .benefit-breakdown .item .bar-review { background: linear-gradient(90deg, #3498db, #2980b9); }
    .benefit-breakdown .item .bar-event { background: linear-gradient(90deg, #f1c40f, #f39c12); }
    .benefit-breakdown .item .bar-receipt { background: linear-gradient(90deg, #1abc9c, #16a085); }

    .benefit-breakdown .item .amount {
        width: 100px;
        flex-shrink: 0;
        text-align: right;
        font-weight: 600;
        font-size: 16px;
        color: #333;
    }

    /* 내역 필터 탭 */
    .history-tabs {
        display: flex;
        gap: 8px;
        margin-top: 30px;
        margin-bottom: 15px;
        padding-bottom: 5px;
        border-bottom: 2px solid #f0f2f5;
    }
    .history-tabs .tab {
        padding: 8px 16px;
        font-size: 16px;
        font-weight: bold;
        cursor: pointer;
        color: #999;
        border-bottom: 3px solid transparent;
        transition: all 0.2s;
    }
    .history-tabs .tab.active {
        color: #03c75a;
        border-bottom-color: #03c75a;
    }
    
    /* 포인트 상세 내역 리스트 */
    .point-list-item {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 20px 10px;
        border-bottom: 1px solid #f0f2f5;
    }
    .point-list-item:last-child {
        border-bottom: none;
    }
    .point-list-item .details .reason {
        font-size: 17px; /* 글자 크기 증가 */
        font-weight: 600;
        color: #2c3e50;
        margin-bottom: 6px;
    }
    .point-list-item .details .sub-info {
        font-size: 14px;
        color: #7f8c8d;
    }
    .point-list-item .amount-change {
        font-size: 19px; /* 글자 크기 증가 */
        font-weight: 700;
        min-width: 100px;
        text-align: right;
    }
    .point-list-item .amount-change.positive { color: #27ae60; }
    .point-list-item .amount-change.negative { color: #e74c3c; }

    /* 내역 없을 때 */
    .no-records {
        text-align: center;
        padding: 60px 20px;
        color: #999;
        font-size: 16px;
    }
  /* ✨ [CSS 추가] 페이징 컨트롤 스타일 */
    .pagination-controls {
        display: flex;
        justify-content: center;
        align-items: center;
        margin-top: 30px;
        padding: 10px 0;
    }
    .pagination-controls .page-link {
        padding: 8px 14px;
        margin: 0 4px;
        border-radius: 8px;
        font-size: 15px;
        font-weight: 600;
        color: #555;
        background-color: #fff;
        border: 1px solid #ddd;
        cursor: pointer;
        transition: all 0.2s;
    }
    .pagination-controls .page-link:hover {
        background-color: #f0f2f5;
        color: #03c75a;
    }
    .pagination-controls .page-link.active {
        background-color: #03c75a;
        color: white;
        border-color: #03c75a;
        cursor: default;
    }
</style>
<main class="main-content">
    <div class="point-history-container">

        <h1 class="page-title">포인트</h1>

        <div class="card point-balance-card">
            <div class="label">보유 포인트</div>
            <div class="amount">
                <fmt:formatNumber value="${totalPoints}" type="number"/>
                <span class="unit">P</span>
            </div>
        </div>

        <div class="card">
            <div class="month-selector">
                <span class="nav-arrow">&lt;</span>
                <span class="month-display">6월</span>
                <span class="nav-arrow">&gt;</span>
            </div>

            <c:choose>
                <c:when test="${not empty pointHistoryList}">
                    <%-- 월별 적립 사유별 합계 계산 --%>
                    <c:set var="totalEarned" value="0" /><c:set var="receiptPoints" value="0" /><c:set var="purchasePoints" value="0" /><c:set var="reviewPoints" value="0" /><c:set var="eventPoints" value="0" />
                    <c:forEach var="point" items="${pointHistoryList}">
                        <c:if test="${point.change_amount > 0}">
                            <c:set var="totalEarned" value="${totalEarned + point.change_amount}" />
                            <c:choose>
                                <c:when test="${fn:contains(point.change_reason, '영수증')}"><c:set var="receiptPoints" value="${receiptPoints + point.change_amount}" /></c:when>
                                <c:when test="${fn:contains(point.change_reason, '구매')}"><c:set var="purchasePoints" value="${purchasePoints + point.change_amount}" /></c:when>
                                <c:when test="${fn:contains(point.change_reason, '리뷰')}"><c:set var="reviewPoints" value="${reviewPoints + point.change_amount}" /></c:when>
                                <c:otherwise><c:set var="eventPoints" value="${eventPoints + point.change_amount}" /></c:otherwise>
                            </c:choose>
                        </c:if>
                    </c:forEach>
                    <c:set var="maxCategoryAmount" value="1" />
                    <c:if test="${receiptPoints > maxCategoryAmount}"><c:set var="maxCategoryAmount" value="${receiptPoints}" /></c:if>
                    <c:if test="${purchasePoints > maxCategoryAmount}"><c:set var="maxCategoryAmount" value="${purchasePoints}" /></c:if>
                    <c:if test="${reviewPoints > maxCategoryAmount}"><c:set var="maxCategoryAmount" value="${reviewPoints}" /></c:if>
                    <c:if test="${eventPoints > maxCategoryAmount}"><c:set var="maxCategoryAmount" value="${eventPoints}" /></c:if>

                    <%-- ✨ [복원] 월별 적립 혜택 요약 그래프 --%>
                    <div class="benefit-breakdown">
                        <div class="summary">
                            <span>총 적립 혜택</span>
                            <span class="amount-change positive">
                                <fmt:formatNumber value="${totalEarned}" pattern="+#,##0"/> P
                            </span>
                        </div>
                        <div class="breakdown-list">
                            <c:if test="${purchasePoints > 0}">
                                <div class="item">
                                    <span class="label">구매적립</span>
                                    <div class="bar-container"><div class="bar bar-purchase" style="width: ${purchasePoints * 100 / maxCategoryAmount}%;"></div></div>
                                    <span class="amount"><fmt:formatNumber value="${purchasePoints}" type="number"/> P</span>
                                </div>
                            </c:if>
                            <c:if test="${receiptPoints > 0}">
                                <div class="item">
                                    <span class="label">영수증 인증</span>
                                    <div class="bar-container"><div class="bar bar-receipt" style="width: ${receiptPoints * 100 / maxCategoryAmount}%;"></div></div>
                                    <span class="amount"><fmt:formatNumber value="${receiptPoints}" type="number"/> P</span>
                                </div>
                            </c:if>
                            <c:if test="${reviewPoints > 0}">
                                <div class="item">
                                    <span class="label">리뷰</span>
                                    <div class="bar-container"><div class="bar bar-review" style="width: ${reviewPoints * 100 / maxCategoryAmount}%;"></div></div>
                                    <span class="amount"><fmt:formatNumber value="${reviewPoints}" type="number"/> P</span>
                                </div>
                            </c:if>
                            <c:if test="${eventPoints > 0}">
                                <div class="item">
                                    <span class="label">이벤트/기타</span>
                                    <div class="bar-container"><div class="bar bar-event" style="width: ${eventPoints * 100 / maxCategoryAmount}%;"></div></div>
                                    <span class="amount"><fmt:formatNumber value="${eventPoints}" type="number"/> P</span>
                                </div>
                            </c:if>
                        </div>
                    </div>
                    <%-- ✨ 그래프 복원 완료 --%>


                    <div class="history-tabs">
                        <div class="tab active" data-filter="all">전체</div>
                        <div class="tab" data-filter="earned">적립</div>
                        <div class="tab" data-filter="used">사용</div>
                    </div>
                    
                    <div class="point-list">
                        <c:forEach var="point" items="${pointHistoryList}">
                            <div class="point-list-item" data-type="${point.change_amount > 0 ? 'earned' : 'used'}">
                                <div class="details">
                                    <div class="reason">${point.change_reason}</div>
                                    <div class="sub-info">
                                        <fmt:formatDate value="${point.change_date}" pattern="yyyy.MM.dd"/> | ${point.point_status}
                                    </div>
                                </div>
                                <div class="amount-change ${point.change_amount > 0 ? 'positive' : 'negative'}">
                                    <fmt:formatNumber value="${point.change_amount}" pattern="+#,##0;-#,##0"/> P
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    
                    <div id="no-filtered-records" class="no-records" style="display: none;">
                        선택하신 조건의 내역이 없습니다.
                    </div>

                    <div class="pagination-controls"></div>

                </c:when>
                <c:otherwise>
                    <p class="no-records">조회 가능한 포인트 내역이 없습니다.</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<script>
    // JavaScript는 변경 사항이 없으므로 이전과 동일하게 사용합니다.
    document.addEventListener('DOMContentLoaded', function() {
        const itemsPerPage = 5;
        const tabs = document.querySelectorAll('.history-tabs .tab');
        const pointListContainer = document.querySelector('.point-list');
        const allPointListItems = Array.from(pointListContainer.querySelectorAll('.point-list-item'));
        const noFilteredRecordsMessage = document.getElementById('no-filtered-records');
        const paginationContainer = document.querySelector('.pagination-controls');

        tabs.forEach(tab => {
            tab.addEventListener('click', function() {
                tabs.forEach(t => t.classList.remove('active'));
                this.classList.add('active');
                filterAndPaginate();
            });
        });

        function filterAndPaginate() {
            const activeFilter = document.querySelector('.history-tabs .tab.active').dataset.filter;
            const filteredItems = allPointListItems.filter(item => {
                const itemType = item.dataset.type;
                return activeFilter === 'all' || activeFilter === itemType;
            });
            showPage(1, filteredItems);
        }

        function showPage(page, items) {
            allPointListItems.forEach(item => item.style.display = 'none');
            const startIndex = (page - 1) * itemsPerPage;
            const endIndex = startIndex + itemsPerPage;
            const pageItems = items.slice(startIndex, endIndex);
            pageItems.forEach(item => item.style.display = 'flex');
            updatePaginationControls(page, items);
            noFilteredRecordsMessage.style.display = items.length === 0 ? 'block' : 'none';
            paginationContainer.style.display = items.length > 0 && Math.ceil(items.length / itemsPerPage) > 1 ? 'flex' : 'none';
        }

        function updatePaginationControls(currentPage, items) {
            paginationContainer.innerHTML = '';
            const totalPages = Math.ceil(items.length / itemsPerPage);
            if (totalPages <= 1) return;
            for (let i = 1; i <= totalPages; i++) {
                const pageLink = document.createElement('a');
                pageLink.className = 'page-link';
                pageLink.textContent = i;
                if (i === currentPage) {
                    pageLink.classList.add('active');
                }
                pageLink.addEventListener('click', () => {
                    showPage(i, items);
                });
                paginationContainer.appendChild(pageLink);
            }
        }

        if (allPointListItems.length > 0) {
            filterAndPaginate();
        }
    });
</script>

<%@include file="../include/footer.jsp" %>