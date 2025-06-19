<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 1. 페이지 기본 골격과 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>

<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/header.jsp" %> 

<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>

<%-- 4. 여기서부터 '회원정보' 페이지만의 고유한 컨텐츠가 시작됩니다. --%>
	<h1>/member/info.jsp</h1>
	
	<fieldset>
		<h2> 아이디 : ${memberVO.member_id } </h2>
		<h2> 비밀번호 : ${memberVO.member_pw } </h2>
		<h2> 이름 : ${memberVO.member_name }</h2>
		<h2> 이메일 : ${memberVO.member_email }</h2>
		<h2> 회원가입일 : ${memberVO.member_regdate }</h2>
		<h2> 전화번호 : ${memberVO.member_phone}</h2>
		<h2> 닉네임   : ${memberVO.member_nick}</h2>
		<h2> 주소     : ${memberVO.member_address}</h2>
		<h2> 회원상태 : ${memberVO.member_status}</h2>
		<h2> 수정일   : ${memberVO.member_update_date}</h2>
	</fieldset>
	
	<a href="/member/main">메인페이지로...</a>
	
<%-- '회원정보' 페이지 컨텐츠 끝 --%>

<%-- 5. 페이지의 끝을 마무리하는 footer 파일을 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>