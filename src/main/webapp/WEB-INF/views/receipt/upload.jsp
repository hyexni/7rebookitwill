<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%-- 컨트롤러로부터 'msg' 라는 이름의 속성(Attribute)이 전달된 경우에만 아래 코드를 실행 --%>
${loginUser }@@@@@@@@@
${member_idx}@@@@@@@@@
${id }@@@@@@@@@
${loginUser.member_nick}@@@@@@@@@@@@

<%-- 1. 페이지 기본 골격과 공통 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>
<%-- 2. 상단 헤더 --%>
<%@ include file="/WEB-INF/views/include/header.jsp" %> 
<%@ include file="/WEB-INF/views/include/alert.jsp" %>


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
    
    /* 버튼 공통 스타일 */
    .btns {
        display: flex;
        justify-content: center;
        width: 50%;
        border-radius: 10px;
        font-weight: 700;
        padding: 12px 30px;
        transition: all 0.3s ease;
        border: none;
        cursor: pointer;
    }
    
    .btns:hover {
        transform: translateY(-3px);
        box-shadow: 0 8px 15px rgba(0, 0, 0, 0.15);
    }
</style>



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
                <button type="submit" class="btns btn-primary">업로드하기</button>
            </div>
        </div>
    </form>

    
</div>

<%-- 5. 하단 푸터 --%>
<%@include file="../include/footer.jsp" %>

<%-- =================================================================== --%>
<%-- JavaScript 로직 --%>
<%-- =================================================================== --%>

<script>
document.addEventListener('DOMContentLoaded', function() {
    
    const fileInput = document.getElementById('receiptFile');
    const fileNameDisplay = document.getElementById('fileNameDisplay');
    const uploadForm = document.getElementById('uploadForm');

    // 파일 입력(input)에 변경이 감지되면(파일이 선택되면) 함수를 실행합니다.
    fileInput.addEventListener('change', function() {
        if (this.files && this.files.length > 0) {
            fileNameDisplay.textContent = '선택된 파일: ' + this.files[0].name;
        } else {
            fileNameDisplay.textContent = '';
        }
    });

    // 폼 제출 시 파일이 선택되었는지 최종 확인
    uploadForm.addEventListener('submit', function(event) {
        if (fileInput.files.length === 0) {
            // [수정] 기본 alert 대신 Swal.fire()를 사용하여 SweetAlert2 팝업 호출
            
            event.preventDefault(); // 제일 먼저 폼 제출을 막습니다.
            
            Swal.fire({
                icon: 'warning', // 아이콘: 경고
                title: '파일 미선택', // 제목
                text: '영수증 파일을 선택해주세요.', // 내용
                confirmButtonColor: '#0056b3', // 확인 버튼 색상
                confirmButtonText: '확인' // 확인 버튼 텍스트
            });
        }
    });
});
</script>
<%-- =================================================================== --%>