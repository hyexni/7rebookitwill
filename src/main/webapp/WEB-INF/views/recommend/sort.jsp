<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
    
	
	<title>추천 도서 정렬 기능</title>
	
<!-- 드롭다운을 감싸는 박스 (오른쪽 정렬 포함) -->
<div style="text-align: right; margin-bottom: 20px; margin-right: 150px;">
  <form method="get" action="/recommend/all" style="display: inline-block;">
    <select name="sort" id="sort" onchange="this.form.submit()"
            style="padding:6px 12px; font-size:14px; border-radius:6px; border:1px solid #ccc;">
      <option value=""      ${currentSort==''       ? 'selected' : ''}>정렬 기준</option>
      <option value="popular"${currentSort=='popular'? 'selected' : ''}>🔥 인기순</option>
      <option value="recent" ${currentSort=='recent' ? 'selected' : ''}>📅 최신순</option>
      <option value="rating" ${currentSort=='rating' ? 'selected' : ''}>⭐ 평점순</option>
    </select>
  </form>
</div>
