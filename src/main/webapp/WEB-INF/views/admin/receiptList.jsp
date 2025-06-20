<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@ include file="include/header.jsp" %> 

<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@ include file="include/sidebar.jsp" %> 

<html>
<head>
    <title>관리자 - 영수증 관리</title>
    <%-- [개선] 테이블과 페이지 전체를 깔끔하게 보여주기 위한 CSS 스타일 추가 --%>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif; margin: 0; background-color: #f8f9fa; }
        .container { max-width: 1200px; margin: 2em auto; background-color: #fff; padding: 2em; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.05); }
        h1 { color: #333; border-bottom: 2px solid #eee; padding-bottom: 15px; margin-bottom: 30px; }
        
        /* 테이블 전체 디자인 */
        .receipt-table {
            width: 100%;
            border-collapse: collapse; /* 테이블 선 한줄로 만들기 */
            font-size: 0.95em;
        }

        /* 테이블 헤더와 셀 디자인 */
        .receipt-table th, .receipt-table td {
            border: 1px solid #dee2e6; /* 은은한 회색 테두리 */
            padding: 12px 15px; /* 셀 내부 여백 */
            text-align: center; /* 기본 정렬을 가운데로 */
            vertical-align: middle;
        }
        
        /* 테이블 헤더 특별 디자인 */
        .receipt-table thead {
            background-color: #f8f9fa; /* 헤더 배경색 */
            font-weight: bold;
            color: #495057;
        }

        /* 특정 컬럼 텍스트 왼쪽 정렬 */
        .receipt-table .text-left {
            text-align: left;
        }

        /* 상태 표시용 텍스트 스타일 */
        .status-success { color: #28a745; font-weight: bold; }
        .status-fail { color: #dc3545; font-weight: bold; }
        .status-mismatch { color: #fd7e14; font-weight: bold; }

        /* 상세보기 버튼 스타일 */
        .btn-detail {
            display: inline-block;
            padding: 5px 10px;
            font-size: 0.85em;
            text-align: center;
            text-decoration: none;
            color: #fff;
            background-color: #007bff;
            border-radius: 4px;
            transition: background-color 0.2s;
        }
        .btn-detail:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>영수증 업로드 목록</h1>

        <%-- [수정] CSS 클래스 적용 --%>
        <table class="receipt-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>사용자 ID</th>
                    <th>업로드 시간</th>
                    <th class="text-left">파일명</th> <%-- 파일명은 왼쪽 정렬 --%>
                    <th>OCR 상태</th>
                    <th>검증 상태</th>
                    <th>비고</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="receipt" items="${receiptList}">
                    <tr>
                        <td>${receipt.upload_id}</td>
                        <td>${receipt.member_idx}</td>
                        <td><fmt:formatDate value="${receipt.upload_time}" pattern="yyyy-MM-dd HH:mm"/></td>
                        <td class="text-left">${receipt.originalfilename}</td>
                        <td>
                            <c:choose>
                                <c:when test="${receipt.upload_status == 'SUCCESS'}">
                                    <span class="status-success">성공</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-fail">${receipt.upload_status}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                             <c:choose>
                                <c:when test="${receipt.verification_status == 'VERIFIED'}">
                                    <span class="status-success">확인됨</span>
                                </c:when>
                                <c:when test="${receipt.verification_status == 'MISMATCH_AMOUNT'}">
                                    <span class="status-mismatch">금액 불일치</span>
                                </c:when>
                                <c:otherwise>
                                    <span>-</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <%-- [개선] 상세보기 링크에 ID를 포함하여 기능 구체화 --%>
                            <a href="/admin/receipts/${receipt.upload_id}" class="btn-detail">상세보기</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</body>

<%-- 4. 하단 푸터를 불러옵니다. --%>
<%@ include file="include/footer.jsp" %> 