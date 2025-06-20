<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 1. 페이지 기본 골격과 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>

<%-- =================================================================== --%>
<%-- CSS 스타일 추가: 이 부분을 head.jsp에 추가하거나 여기에 직접 작성합니다. --%>
<style>
    /* 파일 업로드를 위한 커스텀 스타일 */
    .receipt-upload-wrapper {
        text-align: left; /* 내부 요소들을 가운데 정렬합니다. */
        margin: 20px 0;
        
    }
    
    
.receipt-upload-wrapper img {
    width: 800px; /* 원하는 너비로 조절하세요. (예: 100%, 300px 등) */
    height: auto; /* 높이는 너비에 맞춰 비율대로 자동 조절됩니다. (이미지 왜곡 방지) */
    max-width: 100%; /* 화면이 이미지보다 작아질 경우, 이미지가 화면 밖으로 나가지 않도록 합니다. */
}
    

    /* 사용자가 클릭할 이미지와 라벨에 대한 스타일 */
    .receipt-upload-label {
        cursor: pointer; /* 마우스를 올리면 손가락 모양으로 변경 */
        display: inline-block; /* 라벨이 올바른 크기를 갖도록 설정 */
        border-radius: 8px;
        padding: 10px;
        transition: background-color 0.2s;
    }

    .receipt-upload-label:hover {
        background-color: #f7f7f7; /* 마우스를 올렸을 때 약간의 배경색 변화 */
    }

    .receipt-upload-label img {
        max-width: 100%; /* 이미지가 부모 요소를 넘어가지 않도록 설정 */
        height: auto;
    }
    
    /* 실제 파일 <input> 태그는 화면에서 숨깁니다. */
    #receiptFile {
        display: none;
    }

    /* 선택된 파일명을 보여줄 영역에 대한 스타일 */
    .file-name-display {
        margin-top: 25px;
        font-weight: bold;
        color: #007bff; /* 파란색 계열로 강조 */
        min-height: 20px; /* 파일이 없을 때도 높이를 유지하여 레이아웃이 깨지지 않게 함 */
    }
</style>
<%-- =================================================================== --%>


<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/header.jsp" %> 

<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>

<%-- 4. 여기서부터 '영수증 업로드 내역' 페이지만의 고유한 컨텐츠가 시작됩니다. --%>
<div class="box box-primary">
  
    <form method="post" action="/receipt/upload" enctype="multipart/form-data" role="form">
        <div class="box-body">
            
            <%-- ================================================================ --%>
           
            <div class="receipt-upload-wrapper">
                <label for="receiptFile" class="receipt-upload-label">
                    <%-- 
                        중요: 'src' 경로는 프로젝트의 이미지 저장 위치에 맞게 수정해야 합니다. 
                        예: /resources/images/receiptUpload.png 
                    --%>
                    <img src="${pageContext.request.contextPath}/resources/img/core-img/receiptUpload.png" alt="영수증 업로드 영역">
                </label>

                <input type="file" name="file" id="receiptFile" accept=".jpg,.jpeg,.png,.pdf" required />
                
                <div id="fileNameDisplay" class="file-name-display"></div>
            </div>
            <%-- ================================================================ --%>

            <div class="box-footer">
                <button type="submit" class="btn btn-primary">업로드하기</button>
            </div>
        </div>
    </form>

    <c:if test="${not empty message}">
        <div style="color: red; margin-top: 10px;">
            <strong>⚠ ${message}</strong>
        </div>
    </c:if>
</div>

<%-- 5. 하단 푸터를 불러옵니다. --%>
<%@include file="../include/footer.jsp" %>

<%-- =================================================================== --%>
<%-- JavaScript 추가: 이 부분을 footer.jsp 위에 추가하거나 js 파일로 분리합니다. --%>
<script>
    // 페이지 로드가 완료되면 스크립트 실행
    document.addEventListener('DOMContentLoaded', function() {
        
        // 필요한 HTML 요소들을 ID로 찾습니다.
        const fileInput = document.getElementById('receiptFile');
        const fileNameDisplay = document.getElementById('fileNameDisplay');

        // 파일 입력(input)에 변경이 감지되면(파일이 선택되면) 함수를 실행합니다.
        fileInput.addEventListener('change', function() {
            
            // 사용자가 파일을 선택했는지 확인합니다.
            if (this.files && this.files.length > 0) {
                // 선택된 파일의 이름을 가져와서 화면에 표시합니다.
                fileNameDisplay.textContent = '영수증 업로드가 완료되었습니다. 선택된 파일: ' + this.files[0].name;
            } else {
                // 파일 선택을 취소한 경우, 텍스트를 비웁니다.
                fileNameDisplay.textContent = '';
            }
        });
    });
</script>
<%-- =================================================================== --%>

</body>
</html>