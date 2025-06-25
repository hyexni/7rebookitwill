<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>독후감 수정</title>
<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
    body { padding: 2rem; }
</style>
</head>
<body>

<div class="container">
    <h1 class="mb-4">독후감 수정</h1>
    
    <form action="/bookreport/modify" method="post">
        <!-- 수정 시 report_id 값을 함께 보내야 함 -->
        <input type="hidden" name="report_id" value="${vo.report_id}">
    
        <div class="mb-3">
            <label for="report_title" class="form-label">제목</label>
            <input type="text" class="form-control" id="report_title" name="report_title" value="<c:out value='${vo.report_title}'/>" required>
        </div>
        <div class="row mb-3">
        <div class="col">
                <label for="author_name" class="form-label">책제목</label>
                <input type="text" class="form-control" id="rbook_title" name="rbook_title" value="<c:out value='${vo.author_name}'/>" required>
            </div>
            <div class="col">
                <label for="author_name" class="form-label">저자</label>
                <input type="text" class="form-control" id="author_name" name="author_name" value="<c:out value='${vo.author_name}'/>" required>
            </div>
            <div class="col">
                <label for="publisher" class="form-label">출판사</label>
                <input type="text" class="form-control" id="publisher" name="publisher" value="<c:out value='${vo.publisher}'/>" required>
            </div>
        </div>
        <div class="mb-3">
            <label for="report_text" class="form-label">내용</label>
            <textarea class="form-control" id="report_text" name="report_text" rows="10" required>${vo.report_text}</textarea>
        </div>

        <div class="d-flex justify-content-end gap-2 mt-4">
            <button type="submit" class="btn btn-primary">수정 완료</button>
            <a href="/bookreport/read?report_id=${vo.report_id}" class="btn btn-secondary">취소</a>
        </div>
    </form>
</div>

</body>
</html>
