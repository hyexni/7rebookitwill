<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>
<%@ include file="/WEB-INF/views/include/header.jsp" %>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/review.css" />

<div class="review-form">
  <h2>✏ 리뷰 수정</h2>

  <form action="${pageContext.request.contextPath}/review/update" method="post" enctype="multipart/form-data">
    <input type="hidden" name="review_id" value="${review.review_id}" />
    <input type="hidden" name="book_id" value="${book.book_id}" />

    <!-- 도서 정보 -->
    <p><strong>도서명:</strong> ${book.book_title}</p>

    <!-- 별점 -->
    <div class="star-rating-wrap">
      <div class="star-rating">
        <c:forEach var="i" begin="1" end="5">
          <input type="radio" name="review_score" value="${i}" id="star${i}"
                 ${i == review.review_score ? 'checked' : ''} />
          <label for="star${i}" class="${i <= review.review_score ? 'selected' : ''}">★</label>
        </c:forEach>
      </div>
    </div>

    <!-- 리뷰 내용 -->
    <div>
      <textarea name="review_text" placeholder="리뷰 내용을 입력해주세요" required>${review.review_text}</textarea>
    </div>

    <!-- 이미지 첨부 -->
    <div>
      <label>이미지 첨부 (최대 3장):</label><br>

      <!-- 이미지 1 -->
<div class="file-line">
  <input type="file" name="review_image1" class="file-input" accept="image/png, image/jpeg" onchange="previewImage(this, 1)">
  <button type="button" onclick="clearFile(1)">❌</button>
  <input type="hidden" name="delete_image1" id="delete_image1" value="false">
  <div id="preview-box1" class="preview-box">
    <c:if test="${not empty review.review_image1}">
      <img src="/upload/reviews/${review.review_image1}" class="preview-img" />
      <p class="file-note">※ 기존 이미지가 등록되어 있습니다.</p>
    </c:if>
  </div>
</div>

<!-- 이미지 2 -->
<div class="file-line">
  <input type="file" name="review_image2" class="file-input" accept="image/png, image/jpeg" onchange="previewImage(this, 2)">
  <button type="button" onclick="clearFile(2)">❌</button>
  <input type="hidden" name="delete_image2" id="delete_image2" value="false">
  <div id="preview-box2" class="preview-box">
    <c:if test="${not empty review.review_image2}">
      <img src="/upload/reviews/${review.review_image2}" class="preview-img" />
      <p class="file-note">※ 기존 이미지가 등록되어 있습니다.</p>
    </c:if>
  </div>
</div>

<!-- 이미지 3 -->
<div class="file-line">
  <input type="file" name="review_image3" class="file-input" accept="image/png, image/jpeg" onchange="previewImage(this, 3)">
  <button type="button" onclick="clearFile(3)">❌</button>
  <input type="hidden" name="delete_image3" id="delete_image3" value="false">
  <div id="preview-box3" class="preview-box">
    <c:if test="${not empty review.review_image3}">
      <img src="/upload/reviews/${review.review_image3}" class="preview-img" />
      <p class="file-note">※ 기존 이미지가 등록되어 있습니다.</p>
    </c:if>
  </div>
</div>

      <small>JPG, PNG 형식의 이미지만 업로드 가능합니다.</small>
    </div>

    <!-- 버튼 -->
    <div style="margin-top: 20px;">
      <button type="submit">수정 완료</button>
      <button type="button" onclick="location.href='${pageContext.request.contextPath}/book/view?book_id=${book.book_id}&sort=recent'">취소</button>
    </div>
  </form>
</div>

<jsp:include page="/WEB-INF/views/include/footer.jsp" />

<!-- ✅ 미리보기 + 삭제 취소 스크립트 -->
<script>
  // 별점 표시 반영
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

	//이미지 미리보기 + 삭제 취소
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

      // 삭제 취소
      const hidden = document.getElementById("delete_image" + idx);
      if (hidden) hidden.value = "false";
    }
  }

  // 파일 제거 + 삭제 true 설정
  function clearFile(idx) {
    const input = document.querySelector(`input[name="review_image${idx}"]`);
    const preview = document.getElementById("preview-box" + idx);
    const hidden = document.getElementById("delete_image" + idx);

    if (input) input.value = "";
    if (preview) preview.innerHTML = "";
    if (hidden) hidden.value = "true";
  }
</script>
