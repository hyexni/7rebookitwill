<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>독후감 상세</title>
<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
    body { padding: 2rem; }
    .card-body { white-space: pre-wrap; } /* 줄바꿈 적용 */
</style>
</head>
<body>

<div class="container">
    <h1 class="mb-4">독후감 상세 보기</h1>
    
    <div class="card">
        <div class="card-header">
            <h3><c:out value="${vo.report_title}"/></h3>
        </div>
        <div class="card-body">
            <p><strong>책제목:</strong> <c:out value="${vo.rbook_title}"/></p>
            <p><strong>저자:</strong> <c:out value="${vo.author_name}"/></p>
            <p><strong>출판사:</strong> <c:out value="${vo.publisher}"/></p>
            <hr>
            <p class="card-text">${vo.report_text}</p>
        </div>
        <div class="card-footer text-muted">
            작성일: <fmt:formatDate value="${vo.report_regdate}" pattern="yyyy-MM-dd HH:mm"/>
        </div>
    </div>
    
    <div class="d-flex justify-content-end gap-2 mt-4">
        <a href="/bookreport/list" class="btn btn-secondary">목록으로</a>
        
        <!-- 본인 글일 경우에만 수정/삭제 버튼 표시 -->
        <c:if test="${sessionScope.member_idx == vo.member_idx}">
            <a href="/bookreport/modify?report_id=${vo.report_id}" class="btn btn-warning">수정</a>
        
            <form action="/bookreport/delete" method="post" onsubmit="return confirm('정말로 삭제하시겠습니까?');">
                <input type="hidden" name="report_id" value="${vo.report_id}">
                <button type="submit" class="btn btn-danger">삭제</button>
            </form>
        </c:if>
    </div>
</div>

</body>
</html>
