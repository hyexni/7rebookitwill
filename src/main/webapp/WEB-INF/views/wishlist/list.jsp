<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>
<%@ include file="/WEB-INF/views/include/header.jsp" %>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>

<div class="wishlist-container">
  <h2>내가 찜한 책 목록</h2>

  <c:choose>
    <c:when test="${empty wishlist}">
      <p>찜한 책이 없습니다.</p>
    </c:when>
    <c:otherwise>
	 	<ul class="wishlist-list">
		  <c:forEach var="item" items="${wishlist}">
		    <li class="wishlist-item" data-book-id="${item.book_id}">
		      <img class="product-img"
		           src="${pageContext.request.contextPath}/resources/img/product-img/${item.cover_image}"
		           alt="${item.book_title}" />
		      <div class="wishlist-info">
		        <h3 class="wishlist-title">
		          <a href="${pageContext.request.contextPath}/book/view?book_id=${item.book_id}">
		            ${item.book_title}
		          </a>
		        </h3>
		        <p class="wishlist-author">${item.author_name}</p>
		        <button class="remove-wishlist-btn">찜 삭제</button>
		      </div>
		    </li>
		  </c:forEach>
		</ul>
    </c:otherwise>
  </c:choose>
</div>

<script>
  document.querySelectorAll('.remove-wishlist-btn').forEach(button => {
    button.addEventListener('click', function () {
      const li = this.closest('li');
      const bookId = li.getAttribute('data-book-id');

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
          console.log("서버 응답 데이터:", data); // 디버깅용
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
  .wishlist-container {
    padding: 40px 20px;
    max-width: 1000px;
    margin: 0 auto;
    background-color: #fff;
  }

  .wishlist-list {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    gap: 30px;
    list-style: none;
    padding: 0;
    margin: 0;
  }

  .wishlist-item {
    border: 1px solid #ddd;
    border-radius: 10px;
    overflow: hidden;
    padding: 15px;
    background-color: #fafafa;
    display: flex;
    flex-direction: column;
    align-items: center;
    transition: box-shadow 0.2s;
  }

  .wishlist-item:hover {
    box-shadow: 0 6px 12px rgba(0,0,0,0.1);
  }

  .product-img {
    width: 100%;
    height: 300px;
    object-fit: cover;
    border-radius: 8px;
    margin-bottom: 10px;
  }

  .wishlist-info {
    text-align: center;
  }

  .wishlist-title a {
    font-size: 16px;
    font-weight: bold;
    color: #333;
    text-decoration: none;
  }

  .wishlist-title a:hover {
    color: #f59e0b;
  }

  .wishlist-author {
    font-size: 14px;
    color: #777;
    margin: 6px 0;
  }

  .remove-wishlist-btn {
    margin-top: 10px;
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
</style>


