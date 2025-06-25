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

<%-- 로그인하지 않은 경우, 로그인 페이지로 안내 --%>
<c:if test="${empty sessionScope.member_idx}">
  <div style="padding: 30px; text-align: center;">
    <h3>⚠ 로그인한 사용자만 이용할 수 있는 기능입니다.</h3>
    <a href="${pageContext.request.contextPath}/member/login">[ 로그인 하러가기 ]</a>
  </div>
</c:if>

<%-- 로그인한 경우, 추천 목록 표시 --%>
<c:if test="${not empty sessionScope.member_idx}">
  
  <div class="box box-primary">
    <div class="box-header with-border">
      <%-- 제목: 영수증 기반 추천 --%>
      <h3>🧾 영수증 기반 추천 도서</h3>
      <p>최근 구매하신 도서의 영수증을 분석하여 회원님께 맞는 도서를 추천해 드려요!</p>
    </div>
    <div class="box-body">

      <c:choose>
        <%-- [분기 1] 추천 목록(receiptList)이 비어있는 경우 --%>
        <c:when test="${empty receiptList}">
          <div style="padding: 30px; text-align: center; border: 1px dashed #ccc; margin-top: 20px;">
            <p>😢 아쉽지만, 아직 추천해 드릴 도서가 없어요.</p>
            <p>영수증을 등록하여 회원님만을 위한 도서 추천을 받아보세요!</p>
            <%-- 필요하다면 영수증 등록 페이지로 가는 버튼을 추가할 수 있습니다. --%>
            <%-- <a href="/receipt/register" class="btn btn-primary">영수증 등록하러 가기</a> --%>
          </div>
        </c:when>
        
        <%-- [분기 2] 추천 목록이 있는 경우, 목록을 반복하여 출력 --%>
        <c:otherwise>
          <div style="display: flex; flex-wrap: wrap; gap: 20px;">
            <%-- Controller에서 받은 receiptList를 반복 --%>
            <c:forEach var="book" items="${receiptList}">
              <a href="${pageContext.request.contextPath}/book/view?book_id=${book.bookId}"
                 style="text-decoration: none; color: inherit;">
                <div style="border: 1px solid #ddd; padding: 10px; width: 250px; cursor: pointer; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                
                  <img src="${pageContext.request.contextPath}/resources/img/product-img/${book.coverImage}" 
                       alt="${book.bookTitle}" 
                       style="width: 100%; height: 300px; object-fit: cover; border-radius: 5px;" />
    
                  <div style="font-weight: bold; margin-top: 10px; height: 40px; overflow: hidden;">${book.bookTitle}</div>
    
                  <div style="color: #555; height: 20px; overflow: hidden;">${book.authorName}</div>
    
                  <div style="font-size: 16px; font-weight: bold; margin: 8px 0; color: #d9534f;">
                    <fmt:formatNumber value="${book.bookPrice}" type="number"/>원
                  </div>
                  
                  <div style="font-size: 14px; color: #f0ad4e;">
                    <c:forEach var="i" begin="1" end="5">
                      <c:choose>
                        <c:when test="${i <= book.avgRating}">
                          ⭐ <%-- 꽉 찬 별 --%>
                        </c:when>
                        <c:otherwise>
                          ☆ <%-- 빈 별 --%>
                        </c:otherwise>
                      </c:choose>
                    </c:forEach>
                    <span style="color: #777; margin-left: 5px;">(<fmt:formatNumber value="${book.avgRating}" maxFractionDigits="1"/>)</span>
                  </div>
                  
                </div>
              </a>
            </c:forEach>
          </div>
        </c:otherwise>
      </c:choose>

    </div>
  </div>
  
</c:if>

<%-- 4. 하단 푸터를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>