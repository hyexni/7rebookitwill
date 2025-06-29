<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/book-view.css" />

<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>
<%@ include file="/WEB-INF/views/include/header.jsp" %>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>
<%@ include file="/WEB-INF/views/include/alert.jsp" %>

<!-- ======================== 도서 상세 정보 영역 ======================== -->
<div class="book-detail-wrapper">

  <!-- 1. 왼쪽: 이미지 + 별점 -->
  <div class="book-image-column">
    <div class="book-image">
      <img src="/upload/books/${book.cover_image}"
	     onerror="this.onerror=null; this.src='/resources/img/product-img/no_image.png';"
	     alt="${book.book_title}" />
    </div>
    <c:if test="${averageRating > 0}">
      <div class="avg-star-box">
        <div class="stars-outer">
          <div class="stars-inner" style="width: ${averageRating * 20}%"></div>
        </div>
        <span class="score">(<fmt:formatNumber value="${averageRating}" type="number" maxFractionDigits="1" /> / 5)</span>
      </div>
    </c:if>
  </div>

  <!-- 2. 가운데: 책 정보 -->
  <div class="book-info">
    <h2>📖 ${empty book.book_title ? '제목 정보 없음' : book.book_title}</h2>
    <p><strong>저자:</strong> ${empty book.author_name ? '저자 정보 없음' : book.author_name}</p>
    <p><strong>출판사:</strong> ${empty book.publisher ? '출판사 정보 없음' : book.publisher}</p>
    <p><strong>가격:</strong> 
      <c:choose>
        <c:when test="${book.book_price == 0}">가격 정보 없음</c:when>
        <c:otherwise><fmt:formatNumber value="${book.book_price}" pattern="#,###"/>원</c:otherwise>
      </c:choose>
    </p>
    <p><strong>출판일:</strong> ${empty book.publish_date ? '출판일 정보 없음' : book.publish_date}</p>
    <p><strong>책 소개:</strong></p>
    <p>${empty book.book_summary ? '책 소개가 등록되지 않았습니다.' : book.book_summary}</p>
  </div>

  <!-- 3. 오른쪽: 구매 + 찜 -->
  
  
  <div class="book-action-column">
   <button id="wishlistBtn" onclick="toggleWishlist()" class="wishlist-btn">
      <img id="wishlistIcon" src="${pageContext.request.contextPath}/resources/img/icon/heart-gray.png" alt="찜 하트" width="32" height="32" />
    </button>
    
    <c:choose>
      <c:when test="${fn:trim(book.stock_status) eq '판매중'}">
        <button class="buy-btn" onclick="goBuy('${book.book_id}')">🛒 구매하기</button>
      </c:when>
      <c:when test="${fn:trim(book.stock_status) eq '품절'}">
        <button class="buy-btn" disabled>⚠ 품절</button>
      </c:when>
      <c:when test="${fn:trim(book.stock_status) eq '절판'}">
        <button class="buy-btn" disabled>⚠ 절판</button>
      </c:when>
      <c:otherwise>
        <button class="buy-btn" disabled>⚠ 상태 정보 없음</button>
      </c:otherwise>
    </c:choose>
  </div>
</div>

<!-- 알림 메시지 -->
<div id="wishlistAlert" class="wishlist-alert"></div>

<!-- ======================== 리뷰 전체 영역 ======================== -->
<div class="review-section">

  <!-- 🔸 헤더: 리뷰 수 + 정렬 + 작성 버튼 -->
  <div class="review-header">
    <h3 class="review-title">🖍 리뷰 (${reviewCount}개)</h3>
    <div class="review-controls">
      <form method="get" action="${pageContext.request.contextPath}/book/view" class="sort-form">
        <input type="hidden" name="book_id" value="${book.book_id}" />
        <select name="sort" onchange="this.form.submit()">
          <option value="recent" ${reviewSort == 'recent' ? 'selected' : ''}>🕒 최신순</option>
          <option value="rating" ${reviewSort == 'rating' ? 'selected' : ''}>⭐ 평점순</option>
        </select>
      </form>
      <button class="write-review-btn" onclick="checkLoginBeforeWrite()">🖋 리뷰 작성</button>
    </div>
  </div>

  <!-- 🔸 리뷰가 없는 경우 -->
  <c:if test="${empty reviewList}">
    <p class="no-review">등록된 리뷰가 없습니다.</p>
  </c:if>

  <!-- 🔸 리뷰 리스트 시작 -->
  <ul class="review-list">
    <c:forEach var="review" items="${reviewList}">
      <li class="review-item">
        <div class="review-card">

          <!-- 왼쪽: 텍스트 영역 -->
          <div class="review-left">

            <!-- ⭐ 별점 -->
            <div class="review-stars">
              <c:choose>
                <c:when test="${review.review_score >= 0 && review.review_score <= 5}">
                  <c:forEach begin="1" end="${review.review_score}" var="i">⭐</c:forEach>
                  <c:forEach begin="1" end="${5 - review.review_score}" var="i">☆</c:forEach>
                </c:when>
                <c:otherwise>⚠ 평점 오류</c:otherwise>
              </c:choose>
            </div>

             <div class="review-meta">
            ${review.member_nick} |
            <fmt:formatDate value="${review.review_date}" pattern="yyyy.MM.dd" />
          </div>
          <div class="review-text-box" id="review-text-${review.review_id}" data-text="${review.review_text}">
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

          <c:if test="${sessionScope.loginUser.member_idx == review.member_idx}">
            <div class="review-actions">
              <button type="button" class="edit-btn"
                onclick="location.href='${pageContext.request.contextPath}/review/edit?review_id=${review.review_id}'">
                수정
              </button>
              <button type="button" class="delete-btn" onclick="deleteReview(${review.review_id})">
                삭제
              </button>
            </div>
          </c:if>
        </div>

        <!-- 오른쪽: 이미지 영역 -->
        <c:set var="hasImage" value="${not empty review.review_image1 or not empty review.review_image2 or not empty review.review_image3}" />
		<c:if test="${hasImage}">
		  <div class="review-image-row">
		    <c:if test="${not empty review.review_image1}">
		      <img src="${pageContext.request.contextPath}/upload/reviews/${review.review_image1}"
		           class="review-img"
		           onclick="openImageInNewTab(this.src)" />
		    </c:if>
		    <c:if test="${not empty review.review_image2}">
		      <img src="${pageContext.request.contextPath}/upload/reviews/${review.review_image2}"
		           class="review-img"
		           onclick="openImageInNewTab(this.src)" />
		    </c:if>
		    <c:if test="${not empty review.review_image3}">
		      <img src="${pageContext.request.contextPath}/upload/reviews/${review.review_image3}"
		           class="review-img"
		           onclick="openImageInNewTab(this.src)" />
		    </c:if>
		  </div>
		</c:if>

      </div>
    </li>
  </c:forEach>
</ul>

  <!-- 🔸 페이징 영역 -->
  <div class="pagination">
    <c:if test="${criteria.prev}">
      <a href="${pageContext.request.contextPath}/book/view?book_id=${book.book_id}&sort=${reviewSort}&page=${criteria.startPage - 1}">&laquo;</a>
    </c:if>
    <c:forEach begin="${criteria.startPage}" end="${criteria.endPage}" var="p">
      <a href="${pageContext.request.contextPath}/book/view?book_id=${book.book_id}&sort=${reviewSort}&page=${p}"
         class="${criteria.page == p ? 'active' : ''}">${p}</a>
    </c:forEach>
    <c:if test="${criteria.next}">
      <a href="${pageContext.request.contextPath}/book/view?book_id=${book.book_id}&sort=${reviewSort}&page=${criteria.endPage + 1}">&raquo;</a>
    </c:if>
  </div>

</div> <!-- review-section 닫기 -->


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
  // ✅ 구매 버튼 스크립트
  function goBuy(bookId) {
    const isLoggedIn = '${not empty sessionScope.loginUser}';
    if (isLoggedIn === 'true') {
      location.href = '${pageContext.request.contextPath}/payment?book_id=' + bookId;
    } else {
      if (confirm('로그인이 필요합니다. 로그인 하시겠습니까?')) {
        location.href = '/member/login';
      }
    }
  }

  let isWishlisted = false; // 기본값: false

  // ✅ 페이지 로딩 시 찜 여부 체크
  window.addEventListener("load", function () {
    checkWishlistStatus();
  });

  // ✅ 서버에 찜 여부 요청
  function checkWishlistStatus() {
	console.log('📌 checkWishlistStatus() 실행됨');
    const bookId = "${book.book_id}";

    fetch('/wishlist/check', {
    	  method: 'POST',
    	  headers: { 'Content-Type': 'application/json' },
    	  body: JSON.stringify({ book_id: bookId })
    	})
    .then(res => res.json())
    .then(data => {
      if (data.status === 'ok') {
        isWishlisted = data.isWishlisted;
        updateHeartIcon(); // 초기 하트 상태 세팅
      }
    })
    .catch(err => console.error("찜 상태 확인 실패", err));
  }

  // ✅ 찜 등록/해제 토글 처리
  function toggleWishlist() {
    const bookId = "${book.book_id}";
    const isLoggedIn = ${not empty sessionScope.loginUser};
    if (!isLoggedIn){
      if (confirm("찜 기능은 로그인 후 이용 가능합니다. 로그인 하시겠습니까?")) {
        location.href = "/member/login";
      }
      return;
    }

    const url = isWishlisted ? '/wishlist/delete' : '/wishlist/add';

    fetch(url, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ book_id: bookId })
    })
    .then(res => res.json())
    .then(data => {
      if (data.status === 'added') {
        isWishlisted = true;
        showWishlistAlert("찜 목록에 추가되었습니다.");
      } else if (data.status === 'deleted') {
        isWishlisted = false;
        showWishlistAlert("찜이 해제되었습니다.");
      }
      updateHeartIcon(); // 상태에 따라 하트 이미지 갱신
    })
    .catch(err => {
      console.error("찜 등록/해제 실패", err);
      showWishlistAlert("처리 중 오류가 발생했습니다.");
    });
  }

  // ✅ 하트 이미지 교체
  function updateHeartIcon() {
  const icon = document.getElementById("wishlistIcon");
  const path = "${pageContext.request.contextPath}/resources/img/icon/";
  const src = isWishlisted ? path + "heart-red.png" : path + "heart-gray.png";
  icon.src = src;
  console.log("💖 현재 하트 상태:", isWishlisted ? "빨강" : "회색");
  }

  // ✅ 알림 메시지 보여주기
  function showWishlistAlert(msg) {
    const el = document.getElementById("wishlistAlert");
    el.innerText = msg;
    el.style.display = "block";
    setTimeout(() => {
      el.style.display = "none";
    }, 2000);
  }

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


    function openImageInNewTab(src) {
      window.open(src, '_blank');
    }
   
</script>


<%-- 4. 하단 푸터를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>
