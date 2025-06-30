<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 1. 페이지 기본 골격과 공통 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="include/layout_head.jsp" %>
<%-- [추가] Chart.js 라이브러리. layout_head.jsp에 없다면 여기에 추가합니다. --%>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.2.0/dist/chartjs-plugin-datalabels.min.js"></script>

<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@ include file="include/header.jsp" %> 

<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@ include file="include/sidebar.jsp" %> 

<%-- 2. 이 페이지 전용 스타일 정의 --%>
<style>
    /* 페이지 전체를 감싸는 컨테이너 스타일 */
    .grant-point-container {
        max-width: 650px; /* 폼 너비 */
        margin: 40px auto; /* 상하 여백 및 중앙 정렬 */
        padding: 40px;
        background-color: #ffffff;
        border: 1px solid #e9ecef;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
    }

    /* 페이지 제목(h2) 스타일 */
    .grant-point-container h2 {
        text-align: center;
        font-size: 26px;
        font-weight: 700;
        color: #212529;
        margin-top: 0;
        margin-bottom: 30px;
    }

    /* 폼 그룹 스타일 */
    .form-group {
        margin-bottom: 25px; /* 그룹 간 여백 */
    }

    /* 라벨 스타일 */
    .form-group label {
        display: block;
        margin-bottom: 8px;
        font-size: 15px;
        font-weight: 600;
        color: #495057;
    }

    /* 입력창(input) 스타일 */
    .form-group input {
        width: 100%;
        padding: 12px 15px;
        font-size: 15px;
        border: 1px solid #dee2e6;
        border-radius: 4px;
        box-sizing: border-box; /* 패딩을 포함하여 너비 계산 */
        transition: border-color 0.2s, box-shadow 0.2s;
    }

    /* 입력창 포커스 시 스타일 */
    .form-group input:focus {
        outline: none;
        border-color: #4c6ef5;
        box-shadow: 0 0 0 3px rgba(76, 110, 245, 0.15);
    }

    /* '포인트 지급하기' 버튼 스타일 */
    button[type="submit"] {
        width: 100%;
        padding: 14px 15px;
        font-size: 16px;
        font-weight: 600;
        color: #fff;
        background-color: #4c6ef5;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        transition: background-color 0.2s;
    }

    /* 버튼 호버 시 스타일 */
    button[type="submit"]:hover {
        background-color: #364fc7;
    }

    /* 성공/실패 메시지 스타일 */
    .message {
        padding: 15px 20px;
        margin-bottom: 30px;
        border-radius: 6px;
        font-weight: 500;
        text-align: center;
    }

    .message.success {
        background-color: #d1e7dd;
        color: #0f5132;
        border: 1px solid #badbcc;
    }

    .message.error {
        background-color: #f8d7da;
        color: #842029;
        border: 1px solid #f5c2c7;
    }
</style>

<%-- 3. 메인 콘텐츠 영역 --%>
<main class="main2-content">
    <div class="grant-point-container">
        
        <h2>✨ 관리자 포인트 수동 지급</h2>

        <c:if test="${not empty message}">
            <div class="message ${message.startsWith('성공') ? 'success' : 'error'}">
                ${message}
            </div>
        </c:if>

        <form action="<c:url value='/admin/add'/>" method="post" onsubmit="return confirm('정말로 포인트를 지급하시겠습니까?');">
            <div class="form-group">
                <label for="member_idx">회원 고유번호 (member_idx)</label>
                <input type="number" id="member_idx" name="member_idx" placeholder="포인트를 지급할 회원의 번호를 입력하세요" required>
            </div>
            <div class="form-group">
                <label for="change_amount">지급할 포인트</label>
                <input type="number" id="change_amount" name="change_amount" placeholder="예: 500" required>
            </div>
            <div class="form-group">
                <label for="change_reason">지급 사유</label>
                <input type="text" id="change_reason" name="change_reason" placeholder="예: 우수 회원 이벤트, 고객 보상" required>
            </div>
            <button type="submit">포인트 지급하기</button>
        </form>
        
    </div>
</main>

<%-- 4. 공통 푸터 include --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>