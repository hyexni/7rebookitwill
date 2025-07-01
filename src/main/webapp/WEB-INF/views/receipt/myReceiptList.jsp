<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>
<%@ include file="/WEB-INF/views/include/header.jsp" %>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>

<style>
    /* 기존 스타일 유지 */
    .user-receipt-container h1 {
        font-size: 26px; font-weight: 700; color: #212529;
        margin-top: 0; margin-bottom: 30px; text-align: center;
    }
    .user-receipt-container table {
        width: 100%; border-collapse: collapse; font-size: 15px;
    }
    .user-receipt-container thead { background-color: #f8f9fa; }
    .user-receipt-container th,
    .user-receipt-container td {
        padding: 12px 8px; text-align: center; border-bottom: 1px solid #dee2e6;
    }
    .user-receipt-container th { color: #495057; font-weight: 600; vertical-align: middle; }
    .user-receipt-container tbody tr:hover { background-color: #f1f3f5; }
    .user-receipt-container .no-records {
        text-align: center; padding: 60px 20px; color: #868e96;
    }
    .btn-detail {
        padding: 5px 12px; font-size: 13px; font-weight: 500;
        color: #fff; background-color: #6c757d; border: none;
        border-radius: 4px; text-decoration: none; transition: background-color 0.2s;
    }
    .btn-detail:hover {
        background-color: #5a6268; color: #fff;
    }
    .content-wrapper { padding-bottom: 80px !important; }
</style>

<div class="content-wrapper" style="background-color: #fff;">
<main class="main-content" style="padding:20px;">
    <div class="user-receipt-container">
        <h1>🧾 내 영수증 인증 내역</h1>

        <table>
            <thead>
                <tr>
                    <th style="width: 8%;">번호</th>
                    <th>판매처</th>
                    <th style="width: 12%;">결제 금액</th>
                    <th style="width: 12%;">거래 일시</th>
                    <th style="width: 10%;">적립 포인트</th> <th style="width: 12%;">인증 상태</th>
                    <th style="width: 15%;">업로드 날짜</th>
                    <th style="width: 8%;">상세</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty receiptList}">
                        <c:forEach var="receipt" items="${receiptList}">
                            <tr>
                                <%-- [수정] Mapper XML의 SELECT 컬럼에 맞춰 VO 필드명으로 모두 변경 --%>
                                <td>${receipt.upload_id}</td>
                                <td>${receipt.ocr_store}</td>
                                <td><fmt:formatNumber value="${receipt.ocr_amount}" pattern="#,###" />원</td>
                                <td><fmt:formatDate value="${receipt.ocr_date}" pattern="yyyy-MM-dd"/></td>
                                <td>✨ <fmt:formatNumber value="${receipt.earnedPoints}" pattern="#,###" /> P</td> <td>
                                    <c:choose>
                                        <c:when test="${receipt.upload_status == 'SUCCESS'}">
                                            <span style="color:green; font-weight:bold;">인증완료</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color:red; font-weight:bold;">${receipt.upload_status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td><fmt:formatDate value="${receipt.upload_time}" pattern="yyyy-MM-dd HH:mm"/></td>
                                <td>
                                    <a href="<c:url value='/admin/receiptDetail?upload_id=${receipt.upload_id}'/>" class="btn-detail">보기</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="8" class="no-records">등록된 영수증이 없습니다.</td> </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>

    </div>
</main>
</div>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>