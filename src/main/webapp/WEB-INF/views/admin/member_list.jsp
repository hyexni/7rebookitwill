<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 1. 페이지 기본 골격과 공통 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="include/layout_head.jsp" %>

<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@ include file="include/header.jsp" %> 

<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@ include file="include/sidebar.jsp" %> 

	
<!-- 공통 CSS 불러오기 -->
<main class="main-content">
	<div class="admin-container">	
		  <h1>👥 회원 관리</h1>
		
		  <!-- 🔍 검색 & 정렬 -->
		  <form action="${pageContext.request.contextPath}/admin/member_list" method="get" class="search-form">
		    <select name="sort" onchange="this.form.submit()">
		      <option value="regdate" ${sort == 'regdate' ? 'selected' : ''}>가입일순</option>
		      <option value="name" ${sort == 'name' ? 'selected' : ''}>이름순</option>
		      <option value="point" ${sort == 'point' ? 'selected' : ''}>포인트순</option>
		    </select>
		    <input type="text" name="keyword" placeholder="아이디, 이름, 이메일 검색" value="${keyword}"/>
		    <input type="submit" value="검색">
		  </form>
		
		  <!-- 📋 회원 목록 테이블 -->
		  <table>
		    <thead>
		      <tr>
		        <th>번호</th>
		        <th>회원 ID</th>
		        <th>상태</th>
		        <th>닉네임</th>
		        <th>이름</th>
		        <th>전화번호</th>
		        <th>이메일</th>
		        <th>포인트</th>
		      </tr>
		    </thead>
		    <tbody>
		      <c:forEach var="member" items="${memberList}" varStatus="loop">
		        <tr>
		          <td>${member.member_idx}</td>
		          <td>${member.member_id}</td>
		          <td class="${member.member_status == 'Y' ? 'status-active' : 'status-deleted'}">
		          	<c:choose><c:when test="${member.member_status == 'Y'}">활성</c:when>
		          	<c:otherwise>탈퇴</c:otherwise></c:choose>
		          </td>
		          <td>${member.member_nick}</td>
		          <td>${member.member_name}</td>
		          <td>${member.member_phone}</td>
		          <td>
					<c:out value="${empty member.member_email ? '-' : member.member_email}" />
			      </td>
		          <td>${member.point_total }</td>
		        </tr>
		      </c:forEach>
		    </tbody>
		  </table>
		
		  <!-- 📄 페이징 -->
		  <!-- 페이지네이션 버튼 -->
			<div class="pagination">
			  <a href="${pageContext.request.contextPath}/admin/member_list?page=${currentPage - 1}
			  			&sort=${sort}&keyword=${keyword}"
			     class="${currentPage == 1 ? 'disabled' : ''}">&laquo;</a>
			
			  <c:forEach var="i" begin="1" end="${totalPages}">
			    <a href="${pageContext.request.contextPath}/admin/member_list?page=${i}
			    		&sort=${sort}&keyword=${keyword}"
			       class="${i == currentPage ? 'active' : ''}">
			      ${i}
			    </a>
			  </c:forEach>
			
			  <a href="${pageContext.request.contextPath}/admin/member_list?page=${currentPage + 1}
			  		&sort=${sort}&keyword=${keyword}"
			     class="${currentPage == totalPages ? 'disabled' : ''}">&raquo;</a>
			</div>
		</div>
</main>




<%-- 4. 하단 푸터를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>