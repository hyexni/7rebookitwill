<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> <%-- JSTL functions 라이브러리 추가 --%>

<%-- 1. 페이지 기본 골격과 공통 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>

<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/header.jsp" %>

<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>

<%-- 4. 여기서부터 '공지사항' 페이지만의 고유한 컨텐츠가 시작됩니다. --%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/pagination.css">

	<div class="content">
	
	<div class="box">
            <div class="box-header with-border">
              <h3 class="box-title">공지사항 (/notice/listALL.jsp) </h3>
            </div>
            
            <!-- /.box-header -->
            <div class="box-body">
              <table class="table table-bordered">
                <tbody>
                <tr class="text-center">
                  <th style="width:30px;">NO.</th>
                  <th style="width:200px;">제목</th>
                  <th style="width:130px;">등록일자</th>
                </tr>
                
               <c:forEach var="vo" items="${noticeList}">
                <tr>
                  <td class="text-center">${vo.notice_id }</td>
                  <td class="text-center">
                    <a href="${pageContext.request.contextPath}/notice/read?notice_id=${vo.notice_id}">
                    	${vo.notice_title }</a></td>
                  <td class="text-center">${vo.notice_date }</td>
                </tr>
               </c:forEach>
     
              </tbody></table>
            </div>
            <!-- /.box-body -->
        <div class="box-footer clearfix">
		  <ul class="pagination pagination-sm no-margin pull-right">
		    <!-- 이전 버튼 -->
		    <li class="${currentPage == 1 ? 'disabled' : ''}">
		      <a href="?page=${currentPage-1}">&laquo;</a>
		    </li>
		    <!-- 1,2,3... 페이지 번호 -->
		    <c:forEach begin="1" end="${totalPages}" var="i">
		      <li class="${i == currentPage ? 'active' : ''}">
		        <a href="?page=${i}">${i}</a>
		      </li>
		    </c:forEach>
		    <!-- 다음 버튼 -->
		    <li class="${currentPage == totalPages ? 'disabled' : ''}">
		      <a href="?page=${currentPage+1}">&raquo;</a>
		    </li>
		  </ul>
		</div>

          </div>
          
	</div>


<%-- '공지사항' 페이지 컨텐츠 끝 --%>

<%-- 5. 페이지의 끝을 마무리하는 footer 파일을 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
