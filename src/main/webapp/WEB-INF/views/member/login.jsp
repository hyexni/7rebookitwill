<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 1. 페이지 기본 골격과 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>

<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/header.jsp" %> 

<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>

<%-- 4. 여기서부터 '로그인 메인' 페이지만의 고유한 컨텐츠가 시작됩니다. --%>
	<h1>/member/login.jsp</h1>
	
	<fieldset>
		<form action="/member/login" method="post">
			아이디 : <input type="text" name="member_id"> <br>
			비밀번호 : <input type="password" name="member_pw"> <br>
			<hr>
			<input type="submit" value="로그인 ">
			<input type="button" value="회원가입" 
			       onclick=" location.href='/member/join'; ">
		</form>	
	</fieldset>
	
	
	
<%-- '로그인 메인' 페이지 컨텐츠 끝 --%>

<%-- 5. 페이지의 끝을 마무리하는 footer 파일을 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>