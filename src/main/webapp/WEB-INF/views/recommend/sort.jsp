<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
    
	
	<title>추천 도서 정렬 기능</title>
	
<!-- 드롭다운을 감싸는 박스 (오른쪽 정렬 포함) -->
<div style="text-align: right; margin-bottom: 20px;">
  <form method="get" action="${pageContext.request.contextPath}/recommend/all" style="display: inline-block;"> <!-- action="/all" 제거함 -->
    <select name="sort" id="sort" onchange="this.form.submit()"
            style="padding: 6px 12px; font-size: 14px; border-radius: 6px; border: 1px solid #ccc;">
      <option value="" disabled selected hidden>정렬 기준</option>
      <option value="popular" ${currentSort== 'popular' ? 'selected' : ''}>🔥 인기순</option>
      <option value="recent" ${currentSort== 'recent' ? 'selected' : ''}>📅 최신순</option>
      <option value="price_asc" ${currentSort== 'price_asc' ? 'selected' : ''}>💰 낮은 가격순</option>
      <option value="price_desc" ${currentSort== 'price_desc' ? 'selected' : ''}>💸 높은 가격순</option>
    </select>
  </form>
</div>

	
<%-- <div style="text-align: right; margin-bottom: 20px;">
  <form method="get" style="display: inline-block;"> <!-- action="/all" 제거함 -->
    <select name="sort" id="sort" onchange="this.form.submit()"
            style="padding: 6px 12px; font-size: 14px; border-radius: 6px; border: 1px solid #ccc;">
      <option value="" disabled selected hidden>정렬 기준</option>
      <option value="popular" ${sort eq 'popular' ? 'selected' : ''}>🔥 인기순</option>
      <option value="recent" ${sort eq 'recent' ? 'selected' : ''}>📅 최신순</option>
      <option value="price_asc" ${sort eq 'price_asc' ? 'selected' : ''}>💰 낮은 가격순</option>
      <option value="price_desc" ${sort eq 'price_desc' ? 'selected' : ''}>💸 높은 가격순</option>
    </select>
  </form>
</div> --%>