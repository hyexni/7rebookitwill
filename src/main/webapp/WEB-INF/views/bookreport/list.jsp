<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="/WEB-INF/views/include/alert.jsp" %> 


<%-- 1. 페이지 기본 골격과 공통 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>


<%-- 2. 상단 헤더 --%>
<%@ include file="/WEB-INF/views/include/header.jsp" %> 

<%-- 3. 왼쪽 사이드바 --%>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>독후감 게시판</title>
<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
    body { padding: 2rem; }
</style>
</head>
<body>

<div class="container">
    <h1 class="mb-4">독후감 게시판</h1>
    
    <table class="table table-hover text-center">
        <thead class="table-dark">
            <tr>
                <th>글번호</th>
                <th>제목</th>
                <th>저자</th>
                <th>작성일</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="report" items="${reportList}">
                <tr style="cursor:pointer;" onclick="location.href='/bookreport/read?report_id=${report.report_id}'">
                    <td>${report.report_id}</td>
                    <td><c:out value="${report.report_title}"/></td>
                    <td><c:out value="${report.author_name}"/></td>
                    <td>
                        <fmt:formatDate value="${report.report_regdate}" pattern="yyyy-MM-dd"/>
                    </td>
                </tr>
            </c:forEach>
             <c:if test="${empty reportList}">
                <tr>
                    <td colspan="4">작성된 독후감이 없습니다.</td>
                </tr>
            </c:if>
        </tbody>
    </table>

    <div class="d-flex justify-content-end mt-3">
        <a href="/bookreport/write" class="btn btn-primary">독후감 쓰기</a>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // 글쓰기, 수정, 삭제 후 alert 창
    const result = '${result}';
    if(result === 'CREATE_OK') {
        alert('독후감이 성공적으로 등록되었습니다.');
    } else if (result === 'MODIFY_OK') {
        alert('독후감이 수정되었습니다.');
    } else if (result === 'DELETE_OK') {
        alert('독후감이 삭제되었습니다.');
    }
    
    const authMsg = '${auth_msg}';
    if(authMsg) {
    	alert(authMsg);
    }
</script>
</body>
</html>