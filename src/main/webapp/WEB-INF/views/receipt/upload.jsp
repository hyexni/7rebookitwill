<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../include/header.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>영수증 업로드</title>
</head>
<body>
<div class="box box-primary">
    <div class="box-header with-border">
        <h3 class="box-title">영수증 파일을 업로드해주세요</h3>
    </div>

    <form method="post" action="/receipt/upload" enctype="multipart/form-data" role="form">
        <div class="box-body">
            
            <div class="form-group">
                <label for="member_idx">작성자</label>
                <input type="text" name="member_idx" class="form-control" placeholder="작성자를 입력하세요!" />
            </div>

                       <div class="form-group">
                <label>영수증 파일 첨부</label>
                <input type="file" name="file" class="form-control-file" accept=".jpg,.jpeg,.png,.pdf" required />
            </div>

            <div>
                <h6>📌 주의사항</h6>
                <ul>
                    <li>png / jpg / pdf 파일만 업로드 가능</li>
                    <li>5MB 이하 파일만 업로드 가능</li>
                </ul>
            </div>

            <div class="box-footer">
                <button type="submit" class="btn btn-primary">업로드하기</button>
            </div>
        </div>
    </form>

    <!-- 메시지 출력 영역 -->
    <c:if test="${not empty message}">
        <div style="color: red; margin-top: 10px;">
            <strong>⚠ ${message}</strong>
        </div>
    </c:if>
</div>

<%@include file="../include/footer.jsp" %>
</body>
</html>
