<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- 페이지 제목 설정 -->
<c:set var="pageTitle" value="도서 상세 페이지" />
<jsp:include page="/WEB-INF/views/include/header.jsp" />


<!-- 1. SweetAlert2 CDN 추가 (header.jsp에 넣어도 OK) -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<!-- 2. msg 플래시 메시지로 알림 띄우기 -->
<c:if test="${not empty msg}">
  <script>
    window.onload = function() {
      Swal.fire({
        icon: 'success',
        title: '완료!',
        text: '${msg}',
        confirmButtonText: '확인',
        backdrop: true
      });
    };
  </script>
</c:if>

<!-- 3. 에러 메시지 (❗이 부분 추가하는 거야!) -->
<c:if test="${not empty errorMsg}">
  <script>
    window.onload = function() {
      Swal.fire({
        icon: 'error',
        title: '오류!',
        text: '${errorMsg}',
        confirmButtonText: '확인',
        backdrop: true
      });
    };
  </script>
</c:if>

<!-- ======================== 도서 상세 정보 영역 ======================== -->
<div class="book-detail-wrapper">
  <!-- 도서 이미지 -->
  <div class="book-image">
    <img src="${pageContext.request.contextPath}/resources/img/book/${empty book.cover_image ? 'no_image.png' : book.cover_image}" alt="${book.book_title}" />
  </div>

  <!-- 도서 텍스트 정보 -->
  <div class="book-info">
    <h2>📖 
      <c:choose>
        <c:when test="${empty book.book_title}">제목 정보 없음</c:when>
        <c:otherwise>${book.book_title}</c:otherwise>
      </c:choose>
    </h2>

    <p><strong>저자:</strong> 
      <c:choose>
        <c:when test="${empty book.author_name}">저자 정보 없음</c:when>
        <c:otherwise>${book.author_name}</c:otherwise>
      </c:choose>
    </p>

    <p><strong>출판사:</strong> 
      <c:choose>
        <c:when test="${empty book.publisher}">출판사 정보 없음</c:when>
        <c:otherwise>${book.publisher}</c:otherwise>
      </c:choose>
    </p>

    <p><strong>가격:</strong> 
      <c:choose>
        <c:when test="${book.book_price == 0}">가격 정보 없음</c:when>
        <c:otherwise>${book.book_price}원</c:otherwise>
      </c:choose>
    </p>

    <p><strong>출판일:</strong> 
      <c:choose>
        <c:when test="${empty book.publish_date}">출판일 정보 없음</c:when>
        <c:otherwise>${book.publish_date}</c:otherwise>
      </c:choose>
    </p>

    <p><strong>책 소개:</strong></p>
    <p>
      <c:choose>
        <c:when test="${empty book.book_summary}">책 소개가 등록되지 않았습니다.</c:when>
        <c:otherwise>${book.book_summary}</c:otherwise>
      </c:choose>
    </p>

    <p><strong>판매 상태:</strong> 
      <c:choose>
        <c:when test="${empty book.stock_status}">판매 상태 미정</c:when>
        <c:otherwise>${book.stock_status}</c:otherwise>
      </c:choose>
    </p>
  </div>
  

<!-- ======================== 리뷰 전체 영역 ======================== -->
<div class="review-section">

  <!-- 리뷰 헤더: 제목 + 정렬 선택 -->
  <div class="review-header">
    <h3>🖍️ 리뷰 (${reviewCount}개)</h3>
    <form method="get" action="${pageContext.request.contextPath}/book/view">
      <input type="hidden" name="book_id" value="${book.book_id}" />
      <select name="sort" onchange="this.form.submit()">
        <option value="recent" ${reviewSort == 'recent' ? 'selected' : ''}>🕒 최신순</option>
        <option value="rating" ${reviewSort == 'rating' ? 'selected' : ''}>⭐ 평점순</option>
      </select>
    </form>
  </div>

  <!-- 리뷰 작성 버튼 -->
  <div class="review-write-btn">
    <button onclick="checkLoginBeforeWrite()" class="btn btn-primary">🖋 리뷰 작성</button>
  </div>

  <!-- 로그인 여부 확인 후 리뷰 작성 페이지 이동 -->
  <script>
    function checkLoginBeforeWrite() {
      const isLoggedIn = '${not empty sessionScope.loginUser}';
      if (isLoggedIn === 'true') {
        location.href = '${pageContext.request.contextPath}/review/write?book_id=${book.book_id}';
      } else {
        if (confirm("리뷰 작성은 로그인 후 가능합니다. 로그인 하시겠습니까?")) {
          location.href = '${pageContext.request.contextPath}/member/login';
        }
      }
    }

    // 더보기/접기 기능 구현
    function toggleReview(btn) {
      const li = btn.closest("li");
      const shortText = li.querySelector(".short-text");
      const fullText = li.querySelector(".full-text");
      const isExpanded = fullText.style.display === 'block';
      shortText.style.display = isExpanded ? 'block' : 'none';
      fullText.style.display = isExpanded ? 'none' : 'block';
      btn.innerText = isExpanded ? '더보기' : '접기';
    }
  </script>

  <!-- 등록된 리뷰가 없을 경우 -->
  <c:if test="${empty reviewList}">
    <p class="no-review">등록된 리뷰가 없습니다.</p>
  </c:if>

  <!-- 리뷰 리스트 출력 -->
  <c:if test="${not empty reviewList}">
    <ul class="review-list">
      <c:forEach var="review" items="${reviewList}">
        <li class="review-item">

          <!-- 별점 출력 -->
          <c:choose>
            <c:when test="${review.review_score >= 0 && review.review_score <= 5}">
              <div class="review-stars">
                <c:forEach begin="1" end="${review.review_score}" var="i">⭐</c:forEach>
                <c:forEach begin="1" end="${5 - review.review_score}" var="i">☆</c:forEach>
              </div>
            </c:when>
            <c:otherwise>
              <div class="review-stars error">⚠ 평점 오류</div>
            </c:otherwise>
          </c:choose>

          <!-- 작성자 + 날짜 출력 -->
          <div class="review-meta">
            ${review.member_name} |
            <fmt:formatDate value="${review.review_date}" pattern="yyyy.MM.dd"/>
          </div>
          
          <!-- ✅ 수정/삭제 버튼: 로그인한 본인일 때만 보이도록 -->
		<c:if test="${sessionScope.loginUser.member_idx == review.member_idx}">
		  <div class="review-actions">
		    <a href="${pageContext.request.contextPath}/review/edit?review_id=${review.review_id}">
		      <button type="button">수정</button>
		    </a>
		    <button type="button" onclick="deleteReview(${review.review_id})">삭제</button>
		  </div>
		</c:if>

          <!-- 리뷰 본문 + 더보기 버튼 -->
          <div id="review-text-${review.review_id}" data-text="${review.review_text}">
		  <c:choose>
		    <c:when test="${not empty review.review_text and fn:length(review.review_text) > 100}">
		      <p class="short-text">${fn:substring(review.review_text, 0, 100)}...</p>
		      <p class="full-text" style="display: none;">${review.review_text}</p>
		      <button type="button" class="toggle-btn" onclick="toggleReview(this)">더보기</button>
		    </c:when>
		    <c:otherwise>
		      <p>${review.review_text}</p>
		    </c:otherwise>
		  </c:choose>
		 </div>
		 
          <!-- 리뷰 이미지 -->
          <c:if test="${not empty review.review_image1}">
            <div class="review-image">
              <img src="${pageContext.request.contextPath}/resources/upload/${review.review_image1}" alt="리뷰 이미지" />
            </div>
          </c:if>

        </li>
      </c:forEach>
    </ul>
  </c:if>

  <!-- 페이징 처리 -->
  <div class="pagination">
    <c:if test="${criteria.prev}">
      <a href="${pageContext.request.contextPath}/book/view?book_id=${book.book_id}&sort=${reviewSort}&page=${criteria.startPage - 1}">&laquo;</a>
    </c:if>
    <c:forEach begin="${criteria.startPage}" end="${criteria.endPage}" var="p">
      <a href="${pageContext.request.contextPath}/book/view?book_id=${book.book_id}&sort=${reviewSort}&page=${p}" class="${criteria.page == p ? 'active' : ''}">${p}</a>
    </c:forEach>
    <c:if test="${criteria.next}">
      <a href="${pageContext.request.contextPath}/book/view?book_id=${book.book_id}&sort=${reviewSort}&page=${criteria.endPage + 1}">&raquo;</a>
    </c:if>
  </div>
</div>


		<!-- ✅ 리뷰 수정/삭제 관련 스크립트 -->
	<script>
	  // 리뷰 수정 폼 보여주기
	  function showEditForm(reviewId) {
	    const reviewTextDiv = document.querySelector(`#review-text-${reviewId}`);
	    const originalText = reviewTextDiv.dataset.text;
	
	    reviewTextDiv.innerHTML = `
	      <textarea id="edit-input-${reviewId}" rows="4" cols="60">${originalText}</textarea><br>
	      <button onclick="submitEdit(${reviewId})">저장</button>
	    `;
	  }

	  // 리뷰 수정 제출
	  function submitEdit(reviewId) {
	    const newText = document.querySelector(`#edit-input-${reviewId}`).value;
	
	    if (!newText.trim()) {
	      alert("내용을 입력해주세요!");
	      return;
	    }
	
	    const form = document.createElement("form");
	    form.method = "post";
	    form.action = "${pageContext.request.contextPath}/review/update";
	
	    const idInput = document.createElement("input");
	    idInput.type = "hidden";
	    idInput.name = "review_id";
	    idInput.value = reviewId;
	
	    const textInput = document.createElement("input");
	    textInput.type = "hidden";
	    textInput.name = "review_text";
	    textInput.value = newText;
	
	    form.appendChild(idInput);
	    form.appendChild(textInput);
	    document.body.appendChild(form);
	    form.submit();
	  }
	
	  // 리뷰 삭제
	  function deleteReview(review_id) {
	    alert("삭제 함수 진입 확인: " + review_id); // ✅ 디버깅용
	
	    if (!confirm("정말 삭제하시겠습니까?")) return;
	
	    const form = document.createElement("form");
	    form.method = "POST";
	    form.action = "${pageContext.request.contextPath}/review/delete";
	
	    const input = document.createElement("input");
	    input.type = "hidden";
	    input.name = "review_id";
	    input.value = review_id;
	
	    form.appendChild(input);
	    document.body.appendChild(form);
	    form.submit();
	  }
	</script>

<jsp:include page="/WEB-INF/views/include/footer.jsp" />