<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 1. 페이지 기본 골격과 CSS/폰트 링크 --%>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>

<%-- CSS 스타일 (기존과 동일) --%>
<style>
    /* ... 기존 스타일 코드는 여기에 그대로 둡니다 ... */
    .receipt-upload-wrapper {
        text-align: left;
        margin: 20px 0;
    }
    .receipt-upload-wrapper img {
        width: 800px;
        height: auto;
        max-width: 100%;
    }
    .receipt-upload-label {
        cursor: pointer;
        display: inline-block;
        border-radius: 8px;
        padding: 10px;
        transition: background-color 0.2s;
    }
    .receipt-upload-label:hover {
        background-color: #f7f7f7;
    }
    #receiptFile {
        display: none;
    }
    .file-name-display {
        margin-top: 25px;
        font-weight: bold;
        color: #007bff;
        min-height: 20px;
    }
</style>

<%-- 2. 상단 헤더 --%>
<%@ include file="/WEB-INF/views/include/header.jsp" %> 

<%-- 3. 왼쪽 사이드바 --%>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>

<%-- 4. '영수증 업로드' 페이지 고유 컨텐츠 --%>
<div class="box box-primary">
 
    <form method="post" action="/receipt/upload" enctype="multipart/form-data" id="uploadForm" role="form">
        <div class="box-body">
         
            <div class="receipt-upload-wrapper">
                <label for="receiptFile" class="receipt-upload-label">
                    <img src="${pageContext.request.contextPath}/resources/img/core-img/receiptUpload.png" alt="영수증 업로드 영역">
                </label>

                <input type="file" name="file" id="receiptFile" accept=".jpg,.jpeg,.png,.pdf" />
                
                <div id="fileNameDisplay" class="file-name-display"></div>
            </div>

            <div class="box-footer">
                <button type="submit" class="btn btn-primary">업로드하기</button>
            </div>
        </div>
    </form>

    <%-- 
        [삭제] 기존에 텍스트로 메시지를 보여주던 부분입니다.
        이제 JavaScript alert으로 대체되므로 이 부분은 필요 없습니다.
    <c:if test="${not empty message}">
        <div style="color: red; margin-top: 10px;">
            <strong>⚠ ${message}</strong>
        </div>
    </c:if>
    --%>
</div>

<%-- 5. 하단 푸터 --%>
<%@include file="../include/footer.jsp" %>

<%-- =================================================================== --%>
<%-- [수정] JavaScript 로직 --%>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        
        const fileInput = document.getElementById('receiptFile');
        const fileNameDisplay = document.getElementById('fileNameDisplay');
        const uploadForm = document.getElementById('uploadForm');

        // ================== [추가] 오류 메시지 Alert 처리 ==================
        // Controller가 RedirectAttributes에 담아 보낸 "message" 값을 가져옵니다.
        const message = "${message}";
        
        // message 변수에 내용이 있는지 확인합니다.
        if (message && message.trim().length > 0) {
            // 내용이 있으면 alert 팝업을 띄웁니다.
            alert(message);
        }
        // ================================================================

        // 파일 입력(input)에 변경이 감지되면(파일이 선택되면) 함수를 실행합니다.
        fileInput.addEventListener('change', function() {
            if (this.files && this.files.length > 0) {
                // [개선] 사용자 혼동을 줄이기 위해 안내 문구 수정
                fileNameDisplay.textContent = '선택된 파일: ' + this.files[0].name;
            } else {
                fileNameDisplay.textContent = '';
            }
        });

        // [개선] 폼 제출 시 파일이 선택되었는지 최종 확인
        uploadForm.addEventListener('submit', function(event) {
            if (fileInput.files.length === 0) {
                alert('영수증 파일을 선택해주세요.');
                event.preventDefault(); // 파일이 없으면 폼 제출을 막습니다.
            }
        });
    });
</script>
<%-- =================================================================== --%>
