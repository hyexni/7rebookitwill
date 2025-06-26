<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="/WEB-INF/views/include/alert.jsp" %> 

<%-- 1. 페이지 기본 골격과 공통 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>

<style>
    /* 전체 페이지 배경 및 폰트 설정 */
    body {
        background-color: #f8f9fa; /* 부드러운 회색 배경 */
        font-family: 'Noto Sans KR', sans-serif; /* 웹폰트 적용 */
    }

    /* 컨테이너 중앙 정렬 및 최대 너비 설정 */
    .container {
        max-width: 1000px;
        margin: 40px auto; /* 위아래 여백 추가 */
    }

    /* 폼 전체를 감싸는 카드 디자인 */
    .report-form-card {
        background: #ffffff;
        border: none;
        border-radius: 12px; /* 모서리를 더 둥글게 */
        padding: 40px;
        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08); /* 부드러운 그림자 효과 */
        transition: transform 0.3s ease;
    }

    .report-form-card:hover {
        transform: translateY(-5px); /* 호버 시 살짝 떠오르는 효과 */
    }
    
    /* 페이지 제목 스타일 */
    .page-title {
        text-align: center;
        color: #212529;
        font-weight: 700; /* 굵은 글씨 */
        margin-bottom: 35px;
    }

    /* 폼 라벨 스타일 */
    .form-label {
        font-weight: 500; /* 살짝 굵게 */
        color: #495057;
        margin-bottom: 8px;
    }

    /* 입력 필드(input, textarea) 스타일 */
    .form-control {
        border-radius: 8px;
        border: 1px solid #ced4da;
        padding: 12px 15px; /* 내부 여백 증가 */
        transition: border-color 0.2s ease, box-shadow 0.2s ease;
    }

    .form-control:focus {
        border-color: #86b7fe;
        box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25); /* Bootstrap 기본 포커스 색상 유지 */
        background-color: #fff;
    }

    /* 버튼 스타일 */
    .btn {
        border-radius: 8px;
        font-weight: 500;
        padding: 10px 25px;
        transition: all 0.3s ease;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
    }
    
    .btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
    }
    
    .btn-primary {
        background-color: #0d6efd;
        border-color: #0d6efd;
    }
    
    .btn-secondary {
        background-color: #6c757d;
        border-color: #6c757d;
    }
    
      .form-group textarea {
        width: 100%; 
        padding: 0.75rem; 
        border: 1px solid #ced4da; 
        border-radius: 4px; 
        font-size: 1rem;
        transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
    }
    .form-group textarea { 
        min-height: 300px; 
        resize: vertical; 
    }
    .form-group input:focus, 
    .form-group textarea:focus { 
        border-color: #80bdff; 
        box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25); 
        outline: none; 
    }
    
    

</style>


<%-- 2. 상단 헤더 --%>
<%@ include file="/WEB-INF/views/include/header.jsp" %> 

<%-- 3. 왼쪽 사이드바 --%>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>


<body>

<div class="container">
    <h1 class="mb-4">독후감 게시판</h1>
    
    <table class="table table-hover text-center">
        <thead class="table-dark">
            <tr>
                <th>글번호</th>
                <th>제목</th>
                <th>저자</th>
                <th>작성일</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="report" items="${reportList}">
                <tr style="cursor:pointer;" onclick="location.href='/bookreport/read?report_id=${report.report_id}'">
                    <td>${report.report_id}</td>
                    <td><c:out value="${report.report_title}"/></td>
                    <td><c:out value="${report.author_name}"/></td>
                    <td>
                        <fmt:formatDate value="${report.report_regdate}" pattern="yyyy-MM-dd"/>
                    </td>
                </tr>
            </c:forEach>
             <c:if test="${empty reportList}">
                <tr>
                    <td colspan="4">작성된 독후감이 없습니다.</td>
                </tr>
            </c:if>
        </tbody>
    </table>

    <div class="d-flex justify-content-end mt-3">
        <a href="/bookreport/write" class="btn btn-primary">독후감 쓰기</a>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // 글쓰기, 수정, 삭제 후 alert 창
    const result = '${result}';
    if(result === 'CREATE_OK') {
        alert('독후감이 성공적으로 등록되었습니다.');
    } else if (result === 'MODIFY_OK') {
        alert('독후감이 수정되었습니다.');
    } else if (result === 'DELETE_OK') {
        alert('독후감이 삭제되었습니다.');
    }
    
    const authMsg = '${auth_msg}';
    if(authMsg) {
    	alert(authMsg);
    }
</script>
</body>
</html>