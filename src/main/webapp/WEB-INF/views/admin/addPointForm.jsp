<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 포인트 지급</title>
<style>
    body { font-family: sans-serif; padding: 20px; }
    .container { width: 500px; margin: 0 auto; border: 1px solid #ccc; padding: 30px; border-radius: 5px; }
    .form-group { margin-bottom: 15px; }
    .form-group label { display: block; margin-bottom: 5px; }
    .form-group input { width: 95%; padding: 8px; }
    button { padding: 10px 15px; background-color: #007bff; color: white; border: none; cursor: pointer; border-radius: 3px; }
    .message { padding: 10px; margin-bottom: 20px; border-radius: 3px; }
    .message.success { background-color: #d4edda; color: #155724; }
    .message.error { background-color: #f8d7da; color: #721c24; }
</style>
</head>
<body>

    <div class="container">
        <h2>관리자 포인트 수동 지급</h2>

        <c:if test="${not empty message}">
            <div class="message ${message.startsWith('성공') ? 'success' : 'error'}">
                ${message}
            </div>
        </c:if>

        <form action="/admin/add" method="post" onsubmit="return confirm('정말로 포인트를 지급하시겠습니까?');">
            <div class="form-group">
                <label for="member_idx">회원 고유번호 (member_idx)</label>
                <input type="number" id="member_idx" name="member_idx" placeholder="포인트를 지급할 회원의 번호를 입력하세요" required>
            </div>
            <div class="form-group">
                <label for="points">지급할 포인트</label>
                <input type="number" id="change_amount" name="change_amount" placeholder="예: 500" required>
            </div>
            <div class="form-group">
                <label for="reason">지급 사유</label>
                <input type="text" id="change_reason" name="change_reason" placeholder="예: 우수 회원 이벤트, 고객 보상" required>
            </div>
            <button type="submit">포인트 지급하기</button>
        </form>
    </div>

</body>
</html>