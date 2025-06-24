<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 1. 페이지 기본 골격과 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>

<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/header.jsp" %> 

<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>

<%-- 4. 여기서부터 '독후감' 페이지만의 고유한 컨텐츠가 시작됩니다. --%>

	         
			<%-- 스타일은 write.jsp와 대부분 동일하나, 이미지 수정 관련 스타일 추가 --%>
<style>
    .report-container { width: 100%; max-width: 800px; margin: 2rem auto; padding: 2rem; background-color: #ffffff; border-radius: 8px; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08); }
    .report-header h2 { font-size: 1.8rem; font-weight: 600; color: #333; text-align: center; margin-bottom: 2rem; }
    .book-info-box { background-color: #f8f9fa; border: 1px solid #dee2e6; border-radius: 5px; padding: 1.5rem; margin-bottom: 2rem; }
    .book-info-box .title { font-size: 1.2rem; font-weight: bold; color: #0056b3; }
    .book-info-box .author { font-size: 1rem; color: #6c757d; margin-top: 0.5rem; }
    .form-group { margin-bottom: 1.5rem; }
    .form-group label { display: block; font-weight: 600; margin-bottom: 0.5rem; color: #495057; }
    .form-group input[type="date"], .form-group textarea { width: 100%; padding: 0.75rem; border: 1px solid #ced4da; border-radius: 4px; font-size: 1rem; transition: border-color 0.2s, box-shadow 0.2s; }
    .form-group textarea { min-height: 250px; resize: vertical; }
    .form-group input:focus, .form-group textarea:focus { border-color: #80bdff; box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25); outline: none; }
    .file-input-wrapper { position: relative; overflow: hidden; display: inline-block; width: 100%; }
    .file-input-wrapper .btn-upload { border: 1px solid #007bff; color: #007bff; background-color: white; padding: 0.75rem; border-radius: 4px; cursor: pointer; font-weight: 500; }
    .file-input-wrapper input[type=file] { font-size: 100px; position: absolute; left: 0; top: 0; opacity: 0; cursor: pointer; }
    .file-name { margin-left: 1rem; color: #6c757d; font-style: italic; }
    .btn-container { text-align: right; margin-top: 2rem; }
    .btn { padding: 0.8rem 1.5rem; font-size: 1rem; font-weight: 600; border: none; border-radius: 4px; cursor: pointer; transition: background-color 0.2s; }
    .btn-primary { background-color: #007bff; color: white; }
    .btn-primary:hover { background-color: #0056b3; }
    .btn-secondary { background-color: #6c757d; color: white; margin-left: 0.5rem; }
    .btn-secondary:hover { background-color: #5a6268; }

    /* 수정 페이지 추가 스타일 */
    .image-management-zone {
        border: 1px solid #e9ecef;
        padding: 1rem;
        border-radius: 5px;
        margin-top: 1rem;
    }
    .current-image-preview {
        max-width: 150px;
        max-height: 150px;
        border: 1px solid #ddd;
        border-radius: 4px;
        margin-bottom: 0.5rem;
    }
    .delete-image-label {
        color: #dc3545;
        font-size: 0.9rem;
    }
    .delete-image-label input {
        margin-right: 0.3rem;
    }
</style>

<div class="report-container">
    <div class="report-header">
        <h2>독후감 수정</h2>
    </div>

    <div class="book-info-box">
        <p class="title"><c:out value="${book.book_title}"/></p>
        <p class="author">저자: <c:out value="${book.author}"/></p>
    </div>
    
    <%-- report 변수는 Controller에서 넘겨준 BookReportVO 객체 --%>
    <form action="<c:url value='/bookreport/update'/>" method="post" enctype="multipart/form-data" id="updateForm">
        <input type="hidden" name="report_id" value="${report.report_id}">
        <input type="hidden" name="book_id" value="${report.book_id}">

        <div class="form-group">
            <label for="read_date">읽은 날짜</label>
            <input type="date" id="read_date" name="read_date" value="<c:out value='${report.read_date}'/>" required>
        </div>

        <div class="form-group">
            <label for="report_text">독후감 내용</label>
            <textarea id="report_text" name="report_text" required><c:out value='${report.report_text}'/></textarea>
        </div>

        <%-- 이미지 1 수정 --%>
        <div class="form-group">
            <label>이미지 1</label>
            <c:if test="${not empty report.report_image1}">
                <div class="image-management-zone">
                    <p><strong>현재 이미지:</strong></p>
                    <img src="<c:url value='/resources/upload/${report.report_image1}'/>" alt="현재 이미지1" class="current-image-preview">
                    <br>
                    <label class="delete-image-label">
                        <input type="checkbox" name="delete_image1"> 이 이미지 삭제하기
                    </label>
                </div>
            </c:if>
            <div class="file-input-wrapper" style="margin-top: 1rem;">
                <button type="button" class="btn-upload">새 이미지로 변경</button>
                <input type="file" name="report_image1" class="file-input">
                <span class="file-name">선택된 파일 없음</span>
            </div>
        </div>
        
        <%-- 이미지 2 수정 --%>
        <div class="form-group">
            <label>이미지 2</label>
            <c:if test="${not empty report.report_image2}">
                <div class="image-management-zone">
                     <p><strong>현재 이미지:</strong></p>
                    <img src="<c:url value='/resources/upload/${report.report_image2}'/>" alt="현재 이미지2" class="current-image-preview">
                    <br>
                    <label class="delete-image-label">
                        <input type="checkbox" name="delete_image2"> 이 이미지 삭제하기
                    </label>
                </div>
            </c:if>
            <div class="file-input-wrapper" style="margin-top: 1rem;">
                <button type="button" class="btn-upload">새 이미지로 변경</button>
                <input type="file" name="report_image2" class="file-input">
                <span class="file-name">선택된 파일 없음</span>
            </div>
        </div>
        
        <%-- 이미지 3 수정 --%>
        <div class="form-group">
            <label>이미지 3</label>
            <c:if test="${not empty report.report_image3}">
                 <div class="image-management-zone">
                     <p><strong>현재 이미지:</strong></p>
                    <img src="<c:url value='/resources/upload/${report.report_image3}'/>" alt="현재 이미지3" class="current-image-preview">
                    <br>
                    <label class="delete-image-label">
                        <input type="checkbox" name="delete_image3"> 이 이미지 삭제하기
                    </label>
                </div>
            </c:if>
            <div class="file-input-wrapper" style="margin-top: 1rem;">
                <button type="button" class="btn-upload">새 이미지로 변경</button>
                <input type="file" name="report_image3" class="file-input">
                <span class="file-name">선택된 파일 없음</span>
            </div>
        </div>

        <div class="btn-container">
            <button type="submit" class="btn btn-primary">수정하기</button>
            <button type="button" class="btn btn-secondary" onclick="location.href='<c:url value="/book/view?book_id=${report.book_id}"/>'">취소</button>
        </div>
    </form>
</div>

<script>
// write.jsp의 스크립트와 동일 (미리보기 기능은 제외, 파일명 표시만)
document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('.file-input').forEach(function(input) {
        input.closest('.file-input-wrapper').querySelector('.btn-upload').addEventListener('click', function() {
            input.click();
        });
        
        input.addEventListener('change', function(event) {
            const fileName = this.files.length > 0 ? this.files[0].name : '선택된 파일 없음';
            this.closest('.file-input-wrapper').querySelector('.file-name').textContent = fileName;
        });
    });
});
</script>




<%-- '1:1 문의하기' 페이지 컨텐츠 끝 --%>

<%-- 5. 페이지의 끝을 마무리하는 footer 파일을 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>