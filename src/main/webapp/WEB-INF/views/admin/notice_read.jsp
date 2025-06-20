<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

	<h2>📌 공지 상세보기</h2>
	<p><strong>제목:</strong> ${notice.notice_title}</p>
	<p><strong>내용:</strong> ${notice.notice_content}</p>
	<p><strong>작성일:</strong> ${notice.notice_date}</p>
	
	<form action="${pageContext.request.contextPath}/admin/notice/delete" method="post">
	  <input type="hidden" name="notice_id" value="${notice.notice_id}" />
	  <button type="submit" onclick="return confirm('정말 삭제하시겠습니까?')">삭제</button>
	</form>
	
	<br>
	<a href="${pageContext.request.contextPath}/admin/edit?notice_id=${notice.notice_id}">
	  <button>수정</button>
	</a>
	<a href="${pageContext.request.contextPath}/admin/notice_list">
	  <button>목록</button>
	</a>


</body>
</html>