<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/review.css" />

<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>
<%@ include file="/WEB-INF/views/include/header.jsp" %>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>
<%@ include file="/WEB-INF/views/include/alert.jsp" %>

<%-- 팝업 메시지 강제 삭제(팝업이 안 뜨게!) --%>
<% session.removeAttribute("msg"); %>
<% session.setAttribute("msg", ""); %>


<div class="review-form">
  <h2>✏ 리뷰 수정</h2>

  <form action="${pageContext.request.contextPath}/review/update" method="post" enctype="multipart/form-data">
    <!-- 필수 데이터 hidden으로 전달 -->
    <input type="hidden" name="review_id" value="${review.review_id}" />
    <input type="hidden" name="book_id" value="${review.book_id}" />

    <!-- 도서명 출력 -->
    <p><strong>도서명:</strong> ${book.book_title}</p>

    <!-- 별점 -->
<div class="star-rating">
  <c:forEach var="i" begin="1" end="5">
    <label>
      <input type="radio" name="review_score" value="${i}" ${review.review_score == i ? 'checked' : ''}>★
    </label>
  </c:forEach>
  <span id="scoreDisplay">(0/5점)</span>
</div>

    <!-- 리뷰 내용 -->
    <div>
      <textarea name="review_text" rows="6" cols="80" required>${review.review_text}</textarea>
    </div>

    <!-- 기존 이미지 미리보기 + 삭제 X버튼 + 새 파일 업로드 -->
    <div>
      <label>이미지 수정 (최대 3장):</label><br>

       <!-- 1번 이미지 -->
      <div id="img-edit-wrap1">
        <c:if test="${not empty review.review_image1}">
          <span style="position:relative; display:inline-block;">
            <img src="${pageContext.request.contextPath}/resources/upload/${review.review_image1}" style="max-width:100px;" id="preview-img1">
            <input type="checkbox" name="delete_image1" id="delete-image1" style="display:none;">
            <button type="button" onclick="deleteOldImg(1)" style="position:absolute;top:0;right:0;">❌</button>
          </span>
        </c:if>
        <input type="file" name="review_image1" accept="image/*" onchange="previewNewImg(this,1)">
        <div id="new-preview-box1"></div>
      </div>
      <!-- 2번 이미지 -->
      <div id="img-edit-wrap2">
        <c:if test="${not empty review.review_image2}">
          <span style="position:relative; display:inline-block;">
            <img src="${pageContext.request.contextPath}/resources/upload/${review.review_image2}" style="max-width:100px;" id="preview-img2">
            <input type="checkbox" name="delete_image2" id="delete-image2" style="display:none;">
            <button type="button" onclick="deleteOldImg(2)" style="position:absolute;top:0;right:0;">❌</button>
          </span>
        </c:if>
        <input type="file" name="review_image2" accept="image/*" onchange="previewNewImg(this,2)">
        <div id="new-preview-box2"></div>
      </div>
      <!-- 3번 이미지 -->
      <div id="img-edit-wrap3">
        <c:if test="${not empty review.review_image3}">
          <span style="position:relative; display:inline-block;">
            <img src="${pageContext.request.contextPath}/resources/upload/${review.review_image3}" style="max-width:100px;" id="preview-img3">
            <input type="checkbox" name="delete_image3" id="delete-image3" style="display:none;">
            <button type="button" onclick="deleteOldImg(3)" style="position:absolute;top:0;right:0;">❌</button>
          </span>
        </c:if>
        <input type="file" name="review_image3" accept="image/*" onchange="previewNewImg(this,3)">
        <div id="new-preview-box3"></div>
      </div>
    </div>

    <!-- 버튼 -->
    <div style="margin-top:20px;">
      <button type="submit">수정</button>
      <!-- 취소 버튼은 상세페이지로 이동! -->
      <button type="button" onclick="location.href='${pageContext.request.contextPath}/book/view?book_id=${review.book_id}&sort=recent'">취소</button>
    </div>
  </form>
</div>

	<script>
  // 기존 이미지 ❌ 버튼
  function deleteOldImg(idx) {
    // 체크박스 체크
    document.getElementById('delete-image' + idx).checked = true;
    // 기존 미리보기 숨김
    document.getElementById('preview-img' + idx).style.display = 'none';
    // ❌버튼도 숨기고 싶으면 아래 코드 추가!
    event.target.style.display = 'none';
  }

  // 새 파일 input으로 이미지 선택 시 동작
  function previewNewImg(input, idx) {
    // 기존 미리보기, ❌버튼 숨김 (만약 다시 업로드하는 경우)
    if(document.getElementById('preview-img' + idx)) document.getElementById('preview-img' + idx).style.display = 'none';

    var previewBox = document.getElementById('new-preview-box' + idx);
    previewBox.innerHTML = "";

    if (input.files && input.files[0]) {
      var reader = new FileReader();
      reader.onload = function(e) {
        previewBox.innerHTML =
          '<span style="position:relative;display:inline-block;">' +
          '<img src="' + e.target.result + '" style="max-width:100px;border-radius:8px;" id="new-img'+idx+'">' +
          '<button type="button" onclick="removeNewImg('+idx+')" style="position:absolute;top:0;right:0;">❌</button>' +
          '</span>';
      };
      reader.readAsDataURL(input.files[0]);
    }
    // 새로 파일 올리면, 기존 삭제 체크 해제(원하면 추가)
    if(document.getElementById('delete-image'+idx)) document.getElementById('delete-image'+idx).checked = false;
  }

  // 새로 올린 이미지에서 ❌누를 때
  function removeNewImg(idx) {
    document.getElementsByName("review_image" + idx)[0].value = ""; // 파일 input 초기화
    document.getElementById("new-preview-box" + idx).innerHTML = ""; // 미리보기 삭제
  }
</script>

<script>
  document.addEventListener("DOMContentLoaded", function () {
    const radios = document.querySelectorAll('input[name="review_score"]');
    const labels = document.querySelectorAll('.star-rating label');
    const scoreDisplay = document.getElementById("scoreDisplay");

    // 별점 색칠 함수
    function updateStars(score) {
      labels.forEach((label, index) => {
        label.classList.toggle('selected', index < score);
      });

      // 점수 출력
      if (!score || isNaN(score)) {
        scoreDisplay.textContent = `(0/5점)`;
      } else {
        scoreDisplay.textContent = `(${score}/5점)`;
      }
    }

    // 초기 점수 세팅 (수정 페이지 진입 시)
    const checkedRadio = document.querySelector('input[name="review_score"]:checked');
    if (checkedRadio) {
      updateStars(parseInt(checkedRadio.value));
    }

    // 라디오 버튼 선택 시 반영
    radios.forEach((radio) => {
      radio.addEventListener("change", () => {
        const score = parseInt(radio.value);
        updateStars(score);
      });
    });
  });
</script>



<jsp:include page="/WEB-INF/views/include/footer.jsp" />