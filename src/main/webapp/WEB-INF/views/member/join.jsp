<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 1. 페이지 기본 골격과 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>

<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/header.jsp" %> 

<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>

<%-- 4. 여기서부터 '회원가입' 페이지만의 고유한 컨텐츠가 시작됩니다. --%>
	<h1>/views/member/join.jsp</h1>
	
	<h2> 회원가입 </h2>
	
	<fieldset>
		<form action="/member/join" method="post" onsubmit="return checkPwMatch()">
			아이디 : <input type="text" name="member_id"><br>
			비밀번호 : <input type="password" name="member_pw"><br>
			비밀번호 확인     : <input type="password" name="member_pwConfirm" id="member_pwConfirm" /><br>
			닉네임 : <input type="text" name="member_nick"> <br>
			이름 : <input type="text" name="member_name"><br>
			휴대폰번호 : <input type="text" name="member_phone"><br>
			이메일 : <input type="email" name="member_email"><br>
			주소 : <input type="text" name="member_address"><br>
			<hr>
			<input type="submit" value="회원가입">
		
		</form>	
		
	</fieldset>
	
	
	
	
	
	
	
<%-- '로그인 메인' 페이지 컨텐츠 끝 --%>

<%-- 5. 페이지의 끝을 마무리하는 footer 파일을 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>