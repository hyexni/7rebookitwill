<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 1. 페이지 기본 골격과 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>

<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/header.jsp" %> 

<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>

<%-- 4. 여기서부터 '포인트 내역' 페이지만의 고유한 컨텐츠가 시작됩니다. --%>
<div class="products-catagories-area clearfix">
    <div class="container point-history-container"> <%-- 식별을 위한 클래스 추가 --%>
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
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>
<%-- '포인트 내역' 페이지 컨텐츠 끝 --%>

<%-- 5. 페이지의 끝을 마무리하는 footer 파일을 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>