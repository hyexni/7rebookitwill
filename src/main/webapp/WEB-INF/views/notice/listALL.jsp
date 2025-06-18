<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file = "../include/header.jsp" %>

	<div class="content">
		<h1> /notice/listALL.jsp </h1>
	
	<div class="box">
            <div class="box-header with-border">
              <h3 class="box-title">공지사항</h3>
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
                  <td class="text-center">${vo.notice_title }</td>
                  <td class="text-center">${vo.notice_date }</td>
                </tr>
               </c:forEach>
     
              </tbody></table>
            </div>
            <!-- /.box-body -->
            <div class="box-footer clearfix">
              <ul class="pagination pagination-sm no-margin pull-right">
                <li><a href="#">«</a></li>
                <li><a href="#">1</a></li>
                <li><a href="#">2</a></li>
                <li><a href="#">3</a></li>
                <li><a href="#">»</a></li>
              </ul>
            </div>
          </div>
          
	</div>



<%@ include file = "../include/footer.jsp" %>