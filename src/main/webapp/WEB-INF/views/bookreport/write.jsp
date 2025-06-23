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


<style>
    .report-container {
        width: 100%;
        max-width: 800px;
        margin: 2rem auto;
        padding: 2rem;
        background-color: #ffffff;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
    }
    .report-header h2 {
        font-size: 1.8rem;
        font-weight: 600;
        color: #333;
        text-align: center;
        margin-bottom: 2rem;
    }
    .book-info-box {
        background-color: #f8f9fa;
        border: 1px solid #dee2e6;
        border-radius: 5px;
        padding: 1.5rem;
        margin-bottom: 2rem;
    }
    .book-info-box .title {
        font-size: 1.2rem;
        font-weight: bold;
        color: #0056b3;
    }
    .book-info-box .author {
        font-size: 1rem;
        color: #6c757d;
        margin-top: 0.5rem;
    }
    .form-group {
        margin-bottom: 1.5rem;
    }
    .form-group label {
        display: block;
        font-weight: 600;
        margin-bottom: 0.5rem;
        color: #495057;
    }
    .form-group input[type="date"],
    .form-group textarea {
        width: 100%;
        padding: 0.75rem;
        border: 1px solid #ced4da;
        border-radius: 4px;
        font-size: 1rem;
        transition: border-color 0.2s, box-shadow 0.2s;
    }
    .form-group textarea {
        min-height: 250px;
        resize: vertical;
    }
    .form-group input:focus, .form-group textarea:focus {
        border-color: #80bdff;
        box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
        outline: none;
    }

    /* Custom File Input */
    .file-input-wrapper {
        position: relative;
        overflow: hidden;
        display: inline-block;
        width: 100%;
    }
    .file-input-wrapper .btn-upload {
        border: 1px solid #007bff;
        color: #007bff;
        background-color: white;
        padding: 0.75rem;
        border-radius: 4px;
        cursor: pointer;
        font-weight: 500;
    }
    .file-input-wrapper input[type=file] {
        font-size: 100px;
        position: absolute;
        left: 0;
        top: 0;
        opacity: 0;
        cursor: pointer;
    }
    .file-name {
        margin-left: 1rem;
        color: #6c757d;
        font-style: italic;
    }
    .image-preview {
        margin-top: 1rem;
        max-width: 200px;
        max-height: 200px;
        border: 1px solid #ddd;
        border-radius: 4px;
        display: none; /* 기본 숨김 */
    }

    .btn-container {
        text-align: right;
        margin-top: 2rem;
    }
    .btn {
        padding: 0.8rem 1.5rem;
        font-size: 1rem;
        font-weight: 600;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        transition: background-color 0.2s;
    }
    .btn-primary {
        background-color: #007bff;
        color: white;
    }
    .btn-primary:hover {
        background-color: #0056b3;
    }
    .btn-secondary {
        background-color: #6c757d;
        color: white;
        margin-left: 0.5rem;
    }
    .btn-secondary:hover {
        background-color: #5a6268;
    }
    
    .form-control-readonly {
    width: 100%;
    padding: 0.75rem;
    font-size: 1rem;
    background-color: #e9ecef; /* 비활성화된 느낌을 주는 배경색 */
    border: 1px solid #ced4da;
    border-radius: 4px;
    cursor: not-allowed; /* 마우스 커서를 변경하여 클릭 불가 암시 */
}
</style>

<div class="report-container">
    <div class="report-header">
        <h2>독후감 작성</h2>
    </div>

    <div class="book-info-box">
        <p class="title"><c:out value="${book.book_title}"/></p>
        <p class="author">저자: <c:out value="${book.author}"/></p>
    </div>

    <div class="form-group">
    <label for="book_id">도서 번호</label>
    <input type="text" id="book_id" name="book_id" class="form-control-readonly" value="<c:out value='${book.book_id}'/>" readonly>
    </div>
        <div class="form-group">
            <label for="read_date">읽은 날짜</label>
            <input type="date" id="read_date" name="read_date" required>
        </div>

        <div class="form-group">
            <label for="report_text">독후감 내용</label>
            <textarea id="report_text" name="report_text" placeholder="여기에 독후감을 작성해주세요." required></textarea>
        </div>

        <%-- 이미지 첨부 1 --%>
        <div class="form-group">
            <label>이미지 첨부 1 (선택)</label>
            <div class="file-input-wrapper">
                <button type="button" class="btn-upload">파일 선택</button>
                <input type="file" name="report_image1" class="file-input" data-preview-id="preview1">
                <span class="file-name">선택된 파일 없음</span>
            </div>
            <img id="preview1" class="image-preview" src="#" alt="이미지 미리보기"/>
        </div>

        <%-- 이미지 첨부 2 --%>
        <div class="form-group">
            <label>이미지 첨부 2 (선택)</label>
            <div class="file-input-wrapper">
                <button type="button" class="btn-upload">파일 선택</button>
                <input type="file" name="report_image2" class="file-input" data-preview-id="preview2">
                <span class="file-name">선택된 파일 없음</span>
            </div>
            <img id="preview2" class="image-preview" src="#" alt="이미지 미리보기"/>
        </div>
        
        <%-- 이미지 첨부 3 --%>
        <div class="form-group">
            <label>이미지 첨부 3 (선택)</label>
            <div class="file-input-wrapper">
                <button type="button" class="btn-upload">파일 선택</button>
                <input type="file" name="report_image3" class="file-input" data-preview-id="preview3">
                <span class="file-name">선택된 파일 없음</span>
            </div>
            <img id="preview3" class="image-preview" src="#" alt="이미지 미리보기"/>
        </div>


        <div class="btn-container">
            <button type="submit" class="btn btn-primary">등록하기</button>
            <button type="button" class="btn btn-secondary" onclick="history.back()">취소</button>
        </div>
    </form>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // 모든 파일 입력 필드에 이벤트 리스너 추가
    document.querySelectorAll('.file-input').forEach(function(input) {
        // 실제 파일 input 클릭을 위한 버튼 이벤트
        input.closest('.file-input-wrapper').querySelector('.btn-upload').addEventListener('click', function() {
            input.click();
        });
        
        // 파일 선택 시 이벤트
        input.addEventListener('change', function(event) {
            const fileName = this.files.length > 0 ? this.files[0].name : '선택된 파일 없음';
            // 형제 요소인 .file-name에 파일명 표시
            this.closest('.file-input-wrapper').querySelector('.file-name').textContent = fileName;
            
            // 이미지 미리보기
            const previewId = this.dataset.previewId;
            const preview = document.getElementById(previewId);
            if (this.files && this.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.src = e.target.result;
                    preview.style.display = 'block';
                }
                reader.readAsDataURL(this.files[0]);
            } else {
                preview.style.display = 'none';
            }
        });
    });
});
</script>


<%-- '독후감' 페이지 컨텐츠 끝 --%>
<script>
  document.addEventListener("DOMContentLoaded", function () {
    const form = document.getElementById("bookreportForm");
    const title = document.getElementById("title");
    const content = document.getElementById("content");

   
    const titleError = document.getElementById("title-error");
    const contentError = document.getElementById("content-error");

    form.addEventListener("submit", function (e) {
      let isValid = true;

      // 초기화
      [title, content].forEach(el => el.style.border = "");
      [titleError, contentError].forEach(el => el.style.display = "none");

     
      // 제목 체크
      if (title.value.trim() === "") {
        title.style.border = "2px solid #f4c430"; // ✅ 노란 테두리
        titleError.style.display = "block";
        isValid = false;
      }

      // 내용 체크
      if (content.value.trim() === "") {
        content.style.border = "2px solid #f4c430"; // ✅ 노란 테두리
        contentError.style.display = "block";
        isValid = false;
      }

      if (!isValid) {
        e.preventDefault();
      }
    });
  });
</script>




<%-- 5. 페이지의 끝을 마무리하는 footer 파일을 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>

