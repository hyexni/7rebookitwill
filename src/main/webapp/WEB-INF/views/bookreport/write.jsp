<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="/WEB-INF/views/include/alert.jsp" %> 

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>독후감 작성</title>
<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
    body { padding: 2rem; }
</style>
</head>
<body>

<div class="container">
    <h1 class="mb-4">독후감 작성</h1>
    
    <form action="/bookreport/write" method="post">
        <div class="mb-3">
            <label for="report_title" class="form-label">제목</label>
            <input type="text" class="form-control" id="report_title" name="report_title" required>
        </div>
        <div class="row mb-3">
        <div class="col">
                <label for="author_name" class="form-label">책제목</label>
                <input type="text" class="form-control" id="rbook_title" name="rbook_title" required>
            </div>
            <div class="col">
                <label for="author_name" class="form-label">저자</label>
                <input type="text" class="form-control" id="author_name" name="author_name" required>
            </div>
            <div class="col">
                <label for="publisher" class="form-label">출판사</label>
                <input type="text" class="form-control" id="publisher" name="publisher" required>
            </div>
        </div>
        <div class="mb-3">
            <label for="report_text" class="form-label">내용</label>
            <textarea class="form-control" id="report_text" name="report_text" rows="10" required></textarea>
        </div>
        
     
        <div class="d-flex justify-content-end gap-2 mt-4">
            <button type="submit" class="btn btn-primary">등록하기</button>
            <a href="/bookreport/list" class="btn btn-secondary">목록으로</a>
        </div>
    </form>
</div>

</body>
</html>
