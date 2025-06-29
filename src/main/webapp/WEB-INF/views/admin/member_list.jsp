<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="java.net.URLEncoder" %>
<%
    String encodedKeyword = "";
    if (request.getParameter("keyword") != null) {
        encodedKeyword = URLEncoder.encode(request.getParameter("keyword"), "UTF-8");
    }
    request.setAttribute("encodedKeyword", encodedKeyword);
%>



<%-- 1. 페이지 기본 골격과 공통 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="include/layout_head.jsp" %>

<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@ include file="include/header.jsp" %> 

<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@ include file="include/sidebar.jsp" %> 

	
<!-- 공통 CSS 불러오기 -->
<main class="main-content" id="member-list">
	<div class="admin-container" >	
		  <h1>👥 회원 관리</h1>
		
		  <!-- 🔍 검색 & 정렬 -->
		<form action="${cpath}/admin/member_list#member-list" method="get" class="search-form">
		  <!-- 🔍 검색창만 남김 -->
		  <input type="text" name="keyword" value="${keyword}" placeholder="아이디, 이름, 이메일 검색" />
		  <input type="submit" value="검색" />
		</form>

		
		  <!-- 📋 회원 목록 테이블 -->
		  <table>
		    <thead>
		      <tr>
		        <!-- 가입일 정렬 -->
			      <th style="width: 10%;">
			        <c:set var="toggleDir" value="${sort=='regdate' && dir=='asc' ? 'desc' : 'asc'}" />
			        <a href="${pageContext.request.contextPath}/admin/member_list?page=1&sort=regdate&dir=${fn:trim(toggleDir)}
			        			&keyword=${encodedKeyword}#member-list"
			        	title="가입일 순 정렬" class="sortable">
			          번호
			          <c:choose>
					      <c:when test="${sort == 'regdate'}">
					        <span>${dir == 'asc' ? '▲' : '▼'}</span>
					      </c:when>
					      <c:otherwise>
					        <span class="neutral">⇅</span>
					      </c:otherwise>
					  </c:choose>
			        </a>
			      </th>
		        
		        <th style="width: 12%;">회원ID</th>
			      
		        <th style="width: 12%;">닉네임</th>

		         <!-- 이름 정렬 -->
			      <th style="width: 12%;">
			        <c:set var="toggleDir" value="${sort=='name' && dir=='asc' ? 'desc' : 'asc'}" />
			        <a href="${pageContext.request.contextPath}/admin/member_list?page=1&sort=name&dir=${fn:trim(toggleDir)}
			        			&keyword=${encodedKeyword}#member-list"
			        	title="이름 순 정렬" class="sortable">
			          이름
			          <c:choose>
					      <c:when test="${sort == 'name'}">
					        <span>${dir == 'asc' ? '▲' : '▼'}</span>
					      </c:when>
					      <c:otherwise>
					        <span class="neutral">⇅</span>
					      </c:otherwise>
					    </c:choose>
			        </a>
			      </th>
			      

		        <th style="width: 5%;">상태</th>
		        
		        <th style="width: 15%;">전화번호</th>
		        
		        <th style="width: 20%;">이메일</th>
		        
		        <!-- 포인트 정렬 -->
			      <th  style="width: 9%;">
					  <c:set var="toggleDir" value="${sort=='point' && dir=='asc' ? 'desc' : 'asc'}" />
					  <a href="${pageContext.request.contextPath}/admin/member_list?page=1&sort=point&dir=${fn:trim(toggleDir)}
					  			&keyword=${encodedKeyword}#member-list"
					     title="포인트 순 정렬" class="sortable">
					    포인트
					    <c:choose>
					      <c:when test="${sort == 'point'}">
					        <span>${dir == 'asc' ? '▲' : '▼'}</span>
					      </c:when>
					      <c:otherwise>
					        <span class="neutral">⇅</span>
					      </c:otherwise>
					    </c:choose>
					  </a>
					</th>
		      </tr>
		    </thead>
		    
		    <tbody>
		      <c:forEach var="member" items="${memberList}" varStatus="loop">
		        <tr>
		          <td>${member.member_idx}</td>
		          <td>${member.member_id}</td>
		          <td>${member.member_nick}</td>
		          <td>${member.member_name}</td>
		          <td class="${member.member_status == 'Y' ? 'status-active' : 'status-deleted'}">
		          	<c:choose><c:when test="${member.member_status == 'Y'}">활성</c:when>
		          	<c:otherwise>탈퇴</c:otherwise></c:choose>
		          </td>
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
			  			&sort=${sort}&dir=${dir}&keyword=${encodedKeyword}#member-list"
			     class="${currentPage == 1 ? 'disabled' : ''}">&laquo;</a>
			
			  <c:forEach var="i" begin="1" end="${totalPages}">
			    <a href="${pageContext.request.contextPath}/admin/member_list?page=${i}
			    		&sort=${sort}&dir=${dir}&keyword=${encodedKeyword}#member-list"
			       class="${i == currentPage ? 'active' : ''}">
			      ${i}
			    </a>
			  </c:forEach>
			
			  <a href="${pageContext.request.contextPath}/admin/member_list?page=${currentPage + 1}
			  		&sort=${sort}&dir=${dir}&keyword=${encodedKeyword}#member-list"
			     class="${currentPage == totalPages ? 'disabled' : ''}">&raquo;</a>
			</div>
		</div>
</main>




<%-- 4. 하단 푸터를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>