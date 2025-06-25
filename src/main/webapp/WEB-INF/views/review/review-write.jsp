<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/review.css" />

<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>
<%@ include file="/WEB-INF/views/include/header.jsp" %>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>
<%@ include file="/WEB-INF/views/include/alert.jsp" %>

<div class="review-form">
  <h2>✏ 리뷰 작성</h2>

  <form action="${pageContext.request.contextPath}/review/write" method="post" enctype="multipart/form-data">

    <!-- ⭐ book_id를 서버에 전달하기 위한 hidden 필드 -->
    <input type="hidden" name="book_id" value="${book.book_id}" />

    <!-- 도서명 -->
    <p><strong>도서명:</strong> ${book.book_title}</p>

    <!-- 별점 -->
    <div class="star-rating-wrap">
      <div class="star-rating">
        <c:forEach var="i" begin="1" end="5">
          <input type="radio" name="review_score" value="${i}" id="star${i}" />
          <label for="star${i}">★</label>
        </c:forEach>
      </div>
    </div>

    <!-- 리뷰 내용 -->
    <div>
      <textarea name="review_text" placeholder="내용을 입력하세요" required></textarea>
    </div>

    <!-- 이미지 첨부 (미리보기 + X버튼) -->
    <div>
      <label>이미지 첨부 (최대 3장):</label><br>

      <div class="file-line">
        <input type="file" name="review_image1" class="file-input" accept="image/png, image/jpeg, image/jpg" onchange="previewImage(this, 1)">
        <button type="button" onclick="clearFile(this, 1)">❌</button>
        <div id="preview-box1" class="preview-box"></div>
      </div>

      <div class="file-line">
        <input type="file" name="review_image2" class="file-input" accept="image/png, image/jpeg, image/jpg" onchange="previewImage(this, 2)">
        <button type="button" onclick="clearFile(this, 2)">❌</button>
        <div id="preview-box2" class="preview-box"></div>
      </div>

      <div class="file-line">
        <input type="file" name="review_image3" class="file-input" accept="image/png, image/jpeg, image/jpg" onchange="previewImage(this, 3)">
        <button type="button" onclick="clearFile(this, 3)">❌</button>
        <div id="preview-box3" class="preview-box"></div>
      </div>

      <small>JPG, PNG 형식의 이미지만 업로드 가능합니다.</small>
    </div>

    <!-- 버튼 -->
    <div>
      <button type="submit">등록</button>
      <button type="button" onclick="location.href='${pageContext.request.contextPath}/book/view?book_id=${book.book_id}&sort=recent'">취소</button>
    </div>
  </form>
</div>

<jsp:include page="/WEB-INF/views/include/footer.jsp" />

<script>
  // 별점 선택 처리
  document.addEventListener("DOMContentLoaded", function () {
    const stars = document.querySelectorAll('input[name="review_score"]');

    function updateStars(score) {
      for (let i = 1; i <= 5; i++) {
        const label = document.querySelector('label[for="star' + i + '"]');
        if (label) {
          label.classList.toggle("selected", i <= score);
        }
      }
    }

    const checked = document.querySelector('input[name="review_score"]:checked');
    if (checked) updateStars(parseInt(checked.value));

    stars.forEach((star) => {
      star.addEventListener("change", function () {
        updateStars(parseInt(this.value));
      });
    });
  });

  // 이미지 미리보기
  function previewImage(input, idx) {
  const file = input.files[0];
  const previewBox = document.getElementById("preview-box" + idx);
  previewBox.innerHTML = "";

  if (file) {
    const reader = new FileReader();
    reader.onload = function (e) {
      const img = document.createElement("img");
      img.src = e.target.result;
      img.className = "preview-img";
      previewBox.appendChild(img);
    };
    reader.readAsDataURL(file);
  }
}

  // 파일 초기화
  function clearFile(button, idx) {
    var fileInput = button.previousElementSibling;
    if (fileInput && fileInput.type === 'file') {
      fileInput.value = '';
    }
    var previewBox = document.getElementById("preview-box" + idx);
    previewBox.innerHTML = "";
  }
</script>