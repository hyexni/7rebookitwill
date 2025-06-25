<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/review.css" />

<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>
<%@ include file="/WEB-INF/views/include/header.jsp" %>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>
<%@ include file="/WEB-INF/views/include/alert.jsp" %>

<% session.removeAttribute("msg"); %>



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
  <input type="radio" name="review_score" value="1" id="star1">
  <label for="star1">★</label>

  <input type="radio" name="review_score" value="2" id="star2">
  <label for="star2">★</label>

  <input type="radio" name="review_score" value="3" id="star3">
  <label for="star3">★</label>

  <input type="radio" name="review_score" value="4" id="star4">
  <label for="star4">★</label>

  <input type="radio" name="review_score" value="5" id="star5">
  <label for="star5">★</label>
	</div>

<span id="scoreDisplay">(0/5점)</span>
</div>


    <!-- 리뷰 내용 -->
    <div>
      <textarea name="review_text" placeholder="내용을 입력하세요" required></textarea>
    </div>

	  <!-- 이미지 첨부 (미리보기 + X버튼) -->
    <div>
      <label>이미지 첨부 (최대 3장):</label><br>

      <div class="file-line">
        <input type="file" name="review_image1" class="file-input" accept="image/png, image/jpeg" onchange="previewImage(this, 1)">
        <button type="button" onclick="clearFile(this, 1)">❌</button>
        <div id="preview-box1" style="display:inline-block;"></div>
      </div>

      <div class="file-line">
        <input type="file" name="review_image2" class="file-input" accept="image/png, image/jpeg" onchange="previewImage(this, 2)">
        <button type="button" onclick="clearFile(this, 2)">❌</button>
        <div id="preview-box2" style="display:inline-block;"></div>
      </div>

      <div class="file-line">
        <input type="file" name="review_image3" class="file-input" accept="image/png, image/jpeg" onchange="previewImage(this, 3)">
        <button type="button" onclick="clearFile(this, 3)">❌</button>
        <div id="preview-box3" style="display:inline-block;"></div>
      </div>

      <small>JPG, PNG 형식의 이미지만 업로드 가능합니다.</small>
    </div>

    <!-- 버튼 -->
    <div>
      <button type="submit">등록</button>
     <button type="button" onclick="location.href='${pageContext.request.contextPath}/book/view?book_id=${review.book_id}&sort=recent'">취소</button>
    </div>

  </form>
</div>

	<jsp:include page="/WEB-INF/views/include/footer.jsp" />
	
	<script> 
	  // 별점 점수 표시 + 별 색상 적용
  var stars = document.querySelectorAll('input[name="review_score"]');
  var scoreDisplay = document.getElementById("scoreDisplay");

  stars.forEach(function (star) {
    star.addEventListener("change", function () {
      var selectedScore = parseInt(this.value);
      scoreDisplay.textContent = "(" + selectedScore + "/5점)";

      // 별 색상 변경
      for (var i = 1; i <= 5; i++) {
        var label = document.querySelector('label[for="star' + i + '"]');
        if (label) {
          if (i <= selectedScore) {
            label.classList.add("selected"); // 노란 별
          } else {
            label.classList.remove("selected"); // 회색 별
          }
        }
      }
    });
  });

	  // 이미지 미리보기
	  function previewImage(input, idx) {
	    var previewBox = document.getElementById("preview-box" + idx);
	    previewBox.innerHTML = ""; // 초기화
	    if (input.files && input.files[0]) {
	      var reader = new FileReader();
	      reader.onload = function (e) {
	        // 미리보기 이미지 + X버튼(작성폼에선 그냥 미리보기만)
	        previewBox.innerHTML = '<img src="' + e.target.result + '" style="max-width:100px; margin-left:8px;">';
	      };
	      reader.readAsDataURL(input.files[0]);
	    }
	  }
	
	  // 파일 input & 미리보기 초기화
	  function clearFile(button, idx) {
	    var fileInput = button.previousElementSibling;
	    if (fileInput && fileInput.type === 'file') {
	      fileInput.value = '';
	    }
	    var previewBox = document.getElementById("preview-box" + idx);
	    previewBox.innerHTML = "";
	  }
	</script>
    