<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>
<%@ include file="/WEB-INF/views/include/header.jsp" %>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>

<main class="main-content">
  <h2>🖍 내가 작성한 리뷰</h2>

  <c:choose>
    <c:when test="${empty reviewList}">
      <p>작성한 리뷰가 없습니다.</p>
    </c:when>
    <c:otherwise>
      <div class="my-review-list">
        <c:forEach var="review" items="${reviewList}">
          <div class="review-card">
            <div class="review-content-box">
              <!-- ✅ 왼쪽: 텍스트 영역 -->
              <div class="review-text-area">
                <h3>${review.book_title}</h3>

                <!-- 날짜 -->
                <p class="review-date">
                  작성일: <fmt:formatDate value="${review.review_date}" pattern="yyyy-MM-dd" />
                </p>

                <!-- 별점 -->
                <p class="review-score">
                  <c:forEach var="i" begin="1" end="${review.review_score}">⭐</c:forEach>
                  (${review.review_score}점)
                </p>

                <!-- 리뷰 내용 (더보기/접기) -->
               <c:choose>
				  <c:when test="${fn:length(review.review_text) > 100}">
				    <p class="review-text">
				      <span class="short-text">${fn:substring(review.review_text, 0, 100)}...</span>
				      <span class="full-text" style="display:none;">${review.review_text}</span>
				      <a href="#" class="toggle-text" onclick="toggleText(this); return false;">더보기</a>
				    </p>
				  </c:when>
				  <c:otherwise>
				    <p class="review-text">${review.review_text}</p>
				  </c:otherwise>
				</c:choose>

                <!-- 버튼 -->
                <div class="review-buttons">
                  <a href="${pageContext.request.contextPath}/review/edit?review_id=${review.review_id}" class="btn btn-edit">수정</a>

                  <form method="post" action="${pageContext.request.contextPath}/review/delete" style="display:inline;">
                    <input type="hidden" name="review_id" value="${review.review_id}">
                    <button type="submit" class="btn btn-delete" onclick="return confirm('정말 삭제하시겠습니까?')">삭제</button>
                  </form>

                  <a href="${pageContext.request.contextPath}/book/view?book_id=${review.book_id}" class="btn btn-detail">도서 보기</a>
                </div>
              </div>

              <!-- ✅ 오른쪽: 이미지 영역 -->
              <c:set var="hasImage" value="${not empty review.review_image1 or not empty review.review_image2 or not empty review.review_image3}" />
              <c:if test="${hasImage}">
                <div class="review-image-area">
                  <c:if test="${not empty review.review_image1}">
                    <img src="${pageContext.request.contextPath}/upload/reviews/${review.review_image1}" class="review-img" onclick="openImageInNewTab(this.src)" />
                  </c:if>
                  <c:if test="${not empty review.review_image2}">
                    <img src="${pageContext.request.contextPath}/upload/reviews/${review.review_image2}" class="review-img" onclick="openImageInNewTab(this.src)" />
                  </c:if>
                  <c:if test="${not empty review.review_image3}">
                    <img src="${pageContext.request.contextPath}/upload/reviews/${review.review_image3}" class="review-img" onclick="openImageInNewTab(this.src)" />
                  </c:if>
                </div>
              </c:if>
            </div>
          </div>
        </c:forEach>
      </div>
    </c:otherwise>
  </c:choose>
</main>

<div class="pagination">
  <c:if test="${cri.prev}">
    <a href="?page=${cri.startPage - 1}">«</a>
  </c:if>

  <c:forEach var="i" begin="${cri.startPage}" end="${cri.endPage}">
    <a href="?page=${i}" class="${cri.page == i ? 'active' : ''}">${i}</a>
  </c:forEach>

  <c:if test="${cri.next}">
    <a href="?page=${cri.endPage + 1}">»</a>
  </c:if>
</div>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>

<script>
  function toggleText(btn) {
    const container = btn.closest(".review-text");
    const shortText = container.querySelector(".short-text");
    const fullText = container.querySelector(".full-text");

    const isExpanded = fullText.style.display === "inline";
    shortText.style.display = isExpanded ? "inline" : "none";
    fullText.style.display = isExpanded ? "none" : "inline";
    btn.innerText = isExpanded ? "더보기" : "접기";
  }
</script>


<style>

/* 예쁜 카드 형태로 보기 좋게 */
.my-review-list {
  display: flex;
  flex-direction: column;
  gap: 20px;
}
.review-card {
  border: 1px solid #ddd;
  padding: 15px;
  border-radius: 10px;
  background-color: #fff;
}

.review-buttons {
  margin-top: 10px;
}
.btn {
  padding: 5px 10px;
  text-decoration: none;
  border-radius: 4px;
  font-size: 14px;
  display: inline-block;
}
.btn-edit {
  background-color: #f0ad4e;
  color: #fff;
}
.btn-delete {
  background-color: #d9534f;
  color: #fff;
  border: none;
  cursor: pointer;
}

.btn-detail {
  background-color: #337ab7;
  color: #fff;
  margin-left: 10px;
}

.review-content-box {
  display: flex;
  justify-content: space-between;
  gap: 20px;
}

.review-text-area {
  flex: 1;
}

.review-image-area {
  flex-shrink: 0;
  display: flex;
  flex-direction: column;
  gap: 10px;
  max-width: 120px;
}

.review-img {
  width: 100px;
  height: auto;
  border-radius: 5px;
  cursor: pointer;
}


</style>