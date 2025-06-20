<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<body>

	<h2>공지사항 작성</h2>
	
	    <div class="content">
		<h1> /admin/notice_write.jsp </h1>
		
			<form action="${pageContext.request.contextPath}/admin/notice_write" method="post">
	
	  <div class="form-group">
	    <label for="title">제목</label>
	    <input class="form-control" id="title" name="notice_title" placeholder="제목을 입력하세요" required />
	  </div>
	
	  <div class="form-group">
	    <label for="content">내용</label>
	    <textarea class="form-control" id="content" name="notice_content" rows="8" placeholder="내용을 입력하세요" required></textarea>
	  </div>
	
	  <button type="submit" class="btn btn-primary">등록</button>
	</form>

	
</body>
</html>	
