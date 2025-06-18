<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/include/header.jsp" />

<div class="review-form">
  <h2>✏ 리뷰 작성</h2>

  <form action="${pageContext.request.contextPath}/review/write" method="post" enctype="multipart/form-data">

    <!-- ⭐ book_id를 서버에 전달하기 위한 hidden 필드 -->
    <input type="hidden" name="book_id" value="${book.book_id}" />

    <!-- 도서명 -->
    <p><strong>도서명:</strong> ${book.book_title}</p>

    <!-- 별점 -->
    <label>평점:</label>
    <div class="star-rating">
      <label><input type="radio" name="review_score" value="1">★</label>
      <label><input type="radio" name="review_score" value="2">★</label>
      <label><input type="radio" name="review_score" value="3">★</label>
      <label><input type="radio" name="review_score" value="4">★</label>
      <label><input type="radio" name="review_score" value="5">★</label>
      <span id="scoreDisplay">(0/5점)</span>
    </div>

    <!-- 리뷰 내용 -->
    <div>
      <textarea name="review_text" placeholder="내용을 입력하세요" required></textarea>
    </div>

    <!-- 이미지 첨부 -->
    <div>
      <label>이미지 첨부 (최대 3장):</label><br>

      <div class="file-line">
        <input type="file" name="review_image1" class="file-input" accept="image/png, image/jpeg">
        <button type="button" onclick="clearFile(this)">❌</button>
      </div>

      <div class="file-line">
        <input type="file" name="review_image2" class="file-input" accept="image/png, image/jpeg">
        <button type="button" onclick="clearFile(this)">❌</button>
      </div>

      <div class="file-line">
        <input type="file" name="review_image3" class="file-input" accept="image/png, image/jpeg">
        <button type="button" onclick="clearFile(this)">❌</button>
      </div>

      <small>JPG, PNG 형식의 이미지만 업로드 가능합니다.</small>
    </div>

    <!-- 버튼 -->
    <div>
      <button type="submit">등록</button>
      <button type="button" onclick="history.back();">취소</button>
    </div>

  </form>
</div>

<jsp:include page="/WEB-INF/views/include/footer.jsp" />

<!-- ⭐ 별점 점수 표시 + 파일 초기화 스크립트 -->
<script>
  // 별점 점수 표시
  var stars = document.querySelectorAll('input[name="review_score"]');
  var scoreDisplay = document.getElementById("scoreDisplay");

  stars.forEach(function(star) {
    star.addEventListener("change", function () {
      scoreDisplay.textContent = "(" + this.value + "/5점)";
    });
  });

  // 파일 input 초기화
  function clearFile(button) {
    var fileInput = button.previousElementSibling;
    if (fileInput && fileInput.type === 'file') {
      fileInput.value = '';
    }
  }
</script>
