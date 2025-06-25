<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 1. 페이지 기본 골격과 공통 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="include/layout_head.jsp" %>

<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@ include file="include/header.jsp" %> 

<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@ include file="include/sidebar.jsp" %> 



<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<main class="main-content">
	<div class="admin-container">
	  <h1>📩 1:1 문의 관리</h1>

    <!-- 🔍 검색 영역 -->
    <form class="search-form" method="get" action="list">
        <input type="text" name="keyword" placeholder="제목/작성자 검색" value="${keyword}">
        <input type="submit" value="검색">
    </form>

    <!-- 📋 문의 목록 테이블 -->
    <table class="admin-table">
        <thead>
            <tr>
                <th><a href="?sort=desc" class="desc">등록번호</a></th>
                <th>작성자</th>
                <th>제목</th>
                <th>문의일</th>
                <th>처리상태</th>
                <th>처리일자</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="inquiry" items="${inquiryList}">
                <tr>
                    <td>${inquiry.inquiry_id}</td>
                    <td>${inquiry.member_id}</td>
                    <td style="text-align: left;">
                        <a href="view?inquiry_id=${inquiry.inquiry_id}">
                            ${inquiry.title}
                        </a>
                    </td>
                    <td><fmt:formatDate value="${inquiry.created_at}" pattern="yyyy-MM-dd" /></td>
                    <td>
                        <c:choose>
                            <c:when test="${inquiry.status eq '답변완료'}">
                                <span class="status-badge status-done">답변완료</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge status-received">접수</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${not empty inquiry.processed_at}">
                                <fmt:formatDate value="${inquiry.processed_at}" pattern="yyyy-MM-dd HH:mm" />
                            </c:when>
                            <c:otherwise>-</c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty inquiryList}">
                <tr>
                    <td colspan="6" class="no-records">등록된 문의가 없습니다.</td>
                </tr>
            </c:if>
        </tbody>
    </table>

   <!-- 페이지네이션 버튼 -->
	<div class="pagination">
	  <!-- << 이전 페이지 -->
	  <a href="${pageContext.request.contextPath}/admin/list?page=${currentPage - 1}"
	     <c:if test="${currentPage == 1}">class="disabled"</c:if>>&laquo;</a>
	
	  <!-- 페이지 번호 -->
	  <c:forEach var="i" begin="1" end="${totalPages}">
	    <a href="${pageContext.request.contextPath}/admin/list?page=${i}"
	       <c:if test="${i == currentPage}">class="active"</c:if>>${i}</a>
	  </c:forEach>
	
	  <!-- >> 다음 페이지 -->
	  <a href="${pageContext.request.contextPath}/admin/list?page=${currentPage + 1}"
	     <c:if test="${currentPage == totalPages}">class="disabled"</c:if>>&raquo;</a>
	
	 </div>
	</div>
</main>



<%-- 4. 하단 푸터를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>