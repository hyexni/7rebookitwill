<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>
<%@ include file="/WEB-INF/views/include/header.jsp" %>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>

<div class="wishlist-container">
  <h2 class="wishlist-heading">내가 찜한 책 목록</h2>

  <c:choose>
    <c:when test="${empty wishlist}">
      <p class="wishlist-empty">찜한 책이 없습니다.</p>
    </c:when>
    <c:otherwise>
      <div class="wishlist-grid">
        <c:forEach var="item" items="${wishlist}">
          <div class="wishlist-card" data-book-id="${item.book_id}">
            <img class="product-img"
                 src="${pageContext.request.contextPath}/resources/img/product-img/${item.cover_image}"
                 alt="${item.book_title}" />

            <div class="wishlist-title">
              <a href="${pageContext.request.contextPath}/book/view?book_id=${item.book_id}">
                ${item.book_title}
              </a>
            </div>

            <div class="wishlist-buttons">
              <button class="remove-wishlist-btn">찜 삭제</button>
              <button class="buy-btn"
                      onclick="location.href='${pageContext.request.contextPath}/payment?book_id=${item.book_id}'">
                구매하기
              </button>
            </div>
          </div>
        </c:forEach>
      </div>
      
      <!-- ✅ 페이지 번호 출력 부분 -->
		<div class="pagination">
		  <c:forEach begin="1" end="${totalPage}" var="i">
		    <a href="?page=${i}" class="${i == currentPage ? 'active' : ''}">${i}</a>
		  </c:forEach>
		</div>
      
    </c:otherwise>
  </c:choose>
</div>

<script>
document.querySelectorAll('.remove-wishlist-btn').forEach(button => {
    button.addEventListener('click', function () {
      const card = this.closest('.wishlist-card'); // ← 이 부분만 고친 거야!
      const bookId = card.getAttribute('data-book-id');

      fetch('/wishlist/delete', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ book_id: Number(bookId) }) // 숫자 변환 확실하게
      })
        .then(res => {
          if (!res.ok) {
            throw new Error('서버 응답 오류');
          }
          return res.json();
        })
        .then(data => {
          console.log("서버 응답 데이터:", data);
          if (data.status === 'deleted') {
            location.reload(); // ✅ 삭제 후 새로고침
          } else if (data.status === 'not_logged_in') {
            alert('로그인이 필요합니다.');
            window.location.href = '/member/login';
          } else {
            alert('삭제 실패. 다시 시도해주세요.');
          }
        })
        .catch(error => {
          console.error('에러 발생:', error);
          alert('네트워크 또는 서버 오류가 발생했습니다.');
        });
    });
  });
</script>

<style>
 
 /* ✅ 외곽 영역 */
.wishlist-container {
  padding: 40px 20px;
  margin-left: 240px; /* 사이드바 고려 */
}

.wishlist-heading {
  font-size: 24px;
  font-weight: bold;
  margin-bottom: 20px;
}

/* ✅ 카드들을 담는 영역 */
.wishlist-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
  gap: 30px;
}

/* ✅ 개별 카드 */
.wishlist-card {
  background-color: #fff;
  border: 1px solid #ddd;
  border-radius: 10px;
  box-shadow: 0 2px 6px rgba(0,0,0,0.05);
  padding: 16px;
  display: flex;
  flex-direction: column;
  align-items: center;
  transition: box-shadow 0.2s;
}

.wishlist-card:hover {
  box-shadow: 0 6px 12px rgba(0,0,0,0.1);
}

/* ✅ 책 이미지 */
.product-img {
  width: 100%;
  height: 300px;
  object-fit: cover;
  border-radius: 8px;
  margin-bottom: 12px;
}

/* ✅ 제목 */
.wishlist-title {
  font-size: 16px;
  font-weight: bold;
  margin: 10px 0;
  text-align: center;
}

.wishlist-title a {
  color: #333;
  text-decoration: none;
}

.wishlist-title a:hover {
  color: #f59e0b;
}

/* ✅ 버튼 정렬 */
.wishlist-buttons {
  display: flex;
  justify-content: center;
  gap: 10px;
  margin-top: auto;
}

/* ✅ 찜 삭제 버튼 */
.remove-wishlist-btn {
  background-color: #ff6b6b;
  color: #fff;
  border: none;
  padding: 6px 12px;
  font-size: 13px;
  border-radius: 5px;
  cursor: pointer;
}

.remove-wishlist-btn:hover {
  background-color: #e74c3c;
}

/* ✅ 구매 버튼 */
.buy-btn {
  background-color: #4CAF50;
  color: white;
  border: none;
  padding: 6px 12px;
  font-size: 13px;
  border-radius: 5px;
  cursor: pointer;
}

.buy-btn:hover {
  background-color: #388e3c;
}

/* ✅ 비어있을 때 안내 */
.wishlist-empty {
  color: #999;
  font-size: 16px;
  padding: 40px 0;
}
 
 .pagination {
  margin-top: 30px;
  text-align: center;
}

.pagination a {
  display: inline-block;
  padding: 6px 12px;
  margin: 0 4px;
  border: 1px solid #ccc;
  color: #333;
  border-radius: 4px;
  text-decoration: none;
}

.pagination a:hover {
  background-color: #f0f0f0;
}

.pagination a.active {
  background-color: #ffc107;
  color: white;
  font-weight: bold;
  border-color: #ffc107;
}
  
</style>


