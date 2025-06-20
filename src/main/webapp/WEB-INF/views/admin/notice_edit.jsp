<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

	<h2>공지사항 수정</h2>
	
	<form action="${pageContext.request.contextPath}/admin/edit" method="post">
	  <input type="hidden" name="notice_id" value="${notice.notice_id}" />
	  <p>제목: <input type="text" name="notice_title" value="${notice.notice_title}" /></p>
	  <p>내용: <textarea name="notice_content" rows="5" cols="60">${notice.notice_content}</textarea></p>
	  <button type="submit">수정 완료</button>
	</form>


</body>
</html>