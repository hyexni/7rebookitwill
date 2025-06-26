<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%-- 레이아웃 상단(head, header, sidebar)을 불러옵니다. --%>
<%@ include file="/WEB-INF/views/admin/include/layout_head.jsp" %>
<%@ include file="/WEB-INF/views/admin/include/header.jsp" %> 
<%@ include file="/WEB-INF/views/admin/include/sidebar.jsp" %> 

<style>
    /* [적용] 샘플 파일의 CSS를 기반으로, 이 페이지 전용 클래스(.admin-receipt-container)를 사용하여
      다른 페이지에 영향을 주지 않도록 스타일을 정의합니다.
    */

    /* 전체 컨테이너 및 제목 */
    .admin-receipt-container h1 {
        font-size: 26px; font-weight: 700; color: #212529;
        margin-top: 0; margin-bottom: 30px; text-align: center;
    }

    /* 검색 폼 */
    .admin-receipt-container .search-form {
        margin-bottom: 30px; padding: 20px; background-color: #f1f3f5;
        border-radius: 6px; display: flex; justify-content: center;
        align-items: center; gap: 10px;
    }
    .admin-receipt-container .search-form select,
    .admin-receipt-container .search-form input[type="text"] {
        padding: 9px 12px; border: 1px solid #dee2e6; border-radius: 4px;
        font-size: 15px; transition: all 0.2s;
    }
    .admin-receipt-container .search-form select:focus,
    .admin-receipt-container .search-form input[type="text"]:focus {
        outline: none; border-color: #007bff; box-shadow: 0 0 0 2px rgba(0, 123, 255, 0.25);
    }
    .admin-receipt-container .search-form input[type="submit"] {
        padding: 9px 25px; font-size: 15px; font-weight: 500; color: #fff;
        background-color: #007bff; border: none; border-radius: 4px;
        cursor: pointer; transition: background-color 0.2s;
    }
    .admin-receipt-container .search-form input[type="submit"]:hover {
        background-color: #0056b3;
    }

    /* 테이블 */
    .admin-receipt-container table {
        width: 100%; border-collapse: collapse; font-size: 15px;
    }
    .admin-receipt-container thead { background-color: #f8f9fa; }
    .admin-receipt-container th, 
    .admin-receipt-container td {
        padding: 0px 0px; text-align: center; border-bottom: 1px solid #dee2e6;
    }
    .admin-receipt-container th { color: #495057; font-weight: 500; vertical-align: middle; }
    .admin-receipt-container tbody tr:hover { background-color: #f1f3f5; }

    /* [적용] 클릭 정렬을 위한 화살표 스타일 */
    .admin-receipt-container th a {
        text-decoration: none; color: inherit; display: inline-block;
        position: relative; padding-right: 15px;
    }
    .admin-receipt-container th.asc a::after,
    .admin-receipt-container th.desc a::after {
        content: ''; position: absolute; right: 0; top: 50%;
        transform: translateY(-50%); font-size: 10px; color: #007bff;
    }
    .admin-receipt-container th.asc a::after { content: '▲'; }
    .admin-receipt-container th.desc a::after { content: '▼'; }

    /* 데이터 없을 때 메시지 */
    .admin-receipt-container .no-records {
        text-align: center; padding: 60px 20px; color: #868e96;
    }

    /* 페이지네이션 */
    .admin-receipt-container .pagination {
        margin-top: 30px; text-align: center;
    }
    .admin-receipt-container .pagination a {
        display: inline-block; width: 36px; height: 36px; line-height: 36px;
        margin: 0 4px; text-align: center; text-decoration: none; color: #495057;
        background-color: #fff; border: 1px solid #dee2e6; border-radius: 4px;
        transition: all 0.2s;
    }
    .admin-receipt-container .pagination a:hover {
        background-color: #e9ecef; border-color: #007bff; color: #007bff;
    }
    .admin-receipt-container .pagination a.active {
        background-color: #007bff; border-color: #007bff; color: #fff;
        font-weight: 500; cursor: default;
    }
    
    .content-wrapper {
        padding-bottom: 80px !important; 
    }
</style>

<%-- 메인 컨텐츠 영역 시작 --%>
<div class="content-wrapper" style="background-color: #fff;">
<main class="main-content" style="padding:20px;">
    <div class="admin-receipt-container">
        <h1>🗂️ 전체 영수증 인증 목록</h1>

        <%-- [수정] 영수증 목록에 맞는 검색 기능 --%>
        <div class="search-form">
            <form action="<c:url value='/admin/receipt/list'/>" method="get">
            
                <%-- ================== ▼▼▼ 이 부분이 추가됩니다 ▼▼▼ ================== --%>
              <%-- 현재 정렬 기준을 숨겨진 값으로 함께 전송하여 정렬 상태를 유지합니다. --%>
               <input type="hidden" name="sortColumn" value="${pageMaker.cri.sortColumn}">
               <input type="hidden" name="sortOrder" value="${pageMaker.cri.sortOrder}">
               <%-- ================== ▲▲▲ 여기까지 추가됩니다 ▲▲▲ ================== --%>
            
                <select name="searchType">
                    <option value="member_id" ${pageMaker.cri.searchType == 'member_id' ? 'selected' : ''}>회원 아이디</option>
                    <option value="member_name" ${pageMaker.cri.searchType == 'member_name' ? 'selected' : ''}>회원 이름</option>
                    <option value="ocr_store" ${pageMaker.cri.searchType == 'ocr_store' ? 'selected' : ''}>판매처</option>
                </select>
                <input type="text" name="keyword" value="${pageMaker.cri.keyword}" placeholder="검색어를 입력하세요">
                <input type="submit" value="검색">
            </form>
        </div>

        <table>
            <thead>
                <tr>
                    <%-- [적용] 클릭 정렬 기능이 적용된 테이블 헤더 --%>
                    <th class="${pageMaker.cri.sortColumn == 'upload_id' ? pageMaker.cri.sortOrder : ''}" style="width: 8%;">
                        <a href="<c:url value='/admin/receipt/list${pageMaker.cri.sortUrl("upload_id")}' />">#번호</a>
                    </th>
                    <th class="${pageMaker.cri.sortColumn == 'member_id' ? pageMaker.cri.sortOrder : ''}" style="width: 12%;">
                        <a href="<c:url value='/admin/receipt/list${pageMaker.cri.sortUrl("member_id")}' />">회원ID</a>
                    </th>
                    <th class="${pageMaker.cri.sortColumn == 'member_name' ? pageMaker.cri.sortOrder : ''}" style="width: 12%;">
                        <a href="<c:url value='/admin/receipt/list${pageMaker.cri.sortUrl("member_name")}' />">회원이름</a>
                    </th>
                    <th>판매처</th>
                    <th class="${pageMaker.cri.sortColumn == 'ocr_amount' ? pageMaker.cri.sortOrder : ''}" style="width: 12%;">
                        <a href="<c:url value='/admin/receipt/list${pageMaker.cri.sortUrl("ocr_amount")}' />">결제 금액</a>
                    </th>
                    <th class="${pageMaker.cri.sortColumn == 'earnedPoints' ? pageMaker.cri.sortOrder : ''}" style="width: 12%;">
                        <a href="<c:url value='/admin/receipt/list${pageMaker.cri.sortUrl("earnedPoints")}' />">적립 포인트</a>
                    </th>
                    <th style="width: 10%;">인증 상태</th>
                    <th class="${pageMaker.cri.sortColumn == 'upload_time' ? pageMaker.cri.sortOrder : ''}" style="width: 15%;">
                        <a href="<c:url value='/admin/receipt/list${pageMaker.cri.sortUrl("upload_time")}' />">업로드 날짜</a>
                    </th>
                    <th style="width: 10%;">상세보기</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty receiptList}">
                        <c:forEach var="receipt" items="${receiptList}">                          
                            <tr>
                                <td>${receipt.upload_id}</td>
                                <td>${receipt.member_id} </td>
                                <td>${receipt.member_name}</td>
                                <td>${receipt.ocr_store}</td>
                                <td><fmt:formatNumber value="${receipt.ocr_amount}" pattern="#,###" />원</td>
                                <td><fmt:formatNumber value="${receipt.earnedPoints}" pattern="#,##0" />점</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${receipt.upload_status == 'SUCCESS'}"><span class="label label-success">인증완료</span></c:when>
                                        <c:otherwise><span class="label label-danger">${receipt.upload_status}</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td><fmt:formatDate value="${receipt.upload_time}" pattern="yyyy-MM-dd HH:mm"/></td>
                                <td>
                                                                 
                                  
								<a href="<c:url value='/admin/receiptDetail?upload_id=${receipt.upload_id}'/>" class="btn btn-primary btn-xs">상세보기</a>

                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="7" class="no-records">영수증 내역이 없습니다.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>

        <%-- [적용] 개선된 페이징 UI --%>
        <div class="pagination">
            <c:if test="${pageMaker.prev}">
                <a href="<c:url value='/admin/receipt/list${pageMaker.cri.pageUrl(pageMaker.startPage - 1)}'/>">&laquo;</a>
            </c:if>
            <c:forEach begin="${pageMaker.startPage}" end="${pageMaker.endPage}" var="pageNum">
                <a href="<c:url value='/admin/receipt/list${pageMaker.cri.pageUrl(pageNum)}'/>" 
                   class="${pageMaker.cri.page == pageNum ? 'active' : ''}">${pageNum}</a>
            </c:forEach>
            <c:if test="${pageMaker.next}">
                <a href="<c:url value='/admin/receipt/list${pageMaker.cri.pageUrl(pageMaker.endPage + 1)}'/>">&raquo;</a>
            </c:if>
        </div>
    </div>
</main>
</div>

<%-- 4. 하단 푸터를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>