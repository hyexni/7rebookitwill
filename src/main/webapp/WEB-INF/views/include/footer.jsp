<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
            
            </div>
        </div>
        </div>
    <%-- 
    CSS 스타일 정의. 
    푸터 자체의 디자인과 Sticky Footer를 위한 전체 페이지 레이아웃 스타일이 포함되어 있습니다.
--%>
<style>
    /* --- 기본 설정 --- */
    html, body {
        height: 100%;
        margin: 0;
        padding: 0;       
    }

    /* --- Sticky Footer를 위한 핵심 페이지 레이아웃 --- */
    /* 이 스타일을 적용하려면 페이지가 <div class="page-wrapper">로 감싸져 있어야 합니다. */
    .page-wrapper {
        display: flex;
        flex-direction: column;
        min-height: 100vh; /* 뷰포트(화면)의 전체 높이를 최소 높이로 설정 */
    }

    /* 메인 콘텐츠 영역이 남은 공간을 모두 채우도록 설정 (가장 중요!) */
    main.content {
        flex: 1; 
    }
    
    
    /* --- 푸터 디자인 --- */
    footer {
        width: 100%;
        background-color: #404040; 
        border-top: 1px solid #e9ecef; /* 상단 구분선 */
        padding: 40px 0;
        margin-top: auto; /* Sticky Footer를 위해 추가 */
        color: #CCCCCC; /* 기본 텍스트 색상 */
        font-size: 14px;
        line-height: 1.6;
    }

    .footer-container {
        width: 1200px; /* 메인 콘텐츠 너비와 맞추세요 */
        margin: 0 auto;
        display: flex;
        justify-content: space-between; /* 정보와 링크를 양쪽으로 분리 */
        align-items: flex-start;
    }

    .footer-info {
        max-width: 70%;
    }

    .footer-logo {
        font-size: 24px;
        font-weight: bold;
        color: #CCCCCC; /* 로고 색상 */
        margin: 0 0 15px 0;
    }

    .footer-info p {
        margin: 5px 0;
    }

    .copyright {
        margin-top: 20px;
        font-size: 13px;
        color: #f5f7fa;
    }

    .footer-links {
        text-align: right;
    }

    .footer-links a {
        color: #f5f7fa;
        text-decoration: none;
        margin-left: 20px;
        font-size: 14px;
    }

    .footer-links a:hover {
        text-decoration: underline;
    }

    .footer-links a strong {
        font-weight: bold;
        color: #f5f7fa;
    }
</style>

<%-- 푸터 HTML 구조 --%>
<footer>
    <div class="footer-container">
        <div class="footer-info">
            <h3 class="footer-logo">ReBook</h3>
            <p class="copyright">
                주식회사 리북 | 대표: 홍길동 | 사업자등록번호: 123-45-67890 | 통신판매업신고번호: 제2025-서울강남-01234호<br>
                주소: 서울특별시 강남구 테헤란로 123, ReBook 타워 10층 (우편번호: 06123)<br>
                고객센터: 1588-0000 (평일 09:00 ~ 18:00) | E-mail: support@rebook.example.com
            </p>
            <p class="copyright">
                &copy; 2025 ReBook Corp. All Rights Reserved.
            </p>
        </div>
        <div class="footer-links">
            <a href="<c:url value='/terms'/>"><b>이용약관</b></a>
               <a href="<c:url value='/privacy'/>"><strong>개인정보처리방침</strong></a>
             <a href="<c:url value='/fnq'/>">자주묻는 질문(FAQ)</a>
        </div>
    </div>
</footer>

<%-- ================================================================== --%>
<%--        [신규 추가] 영수증 기반 추천 도서 팝업 기능 시작             --%>
<%-- ================================================================== --%>

<div id="recommend-modal" class="modal-overlay" style="display:none;">
    <div class="modal-content">
        <button id="modal-close" class="modal-close-btn" title="닫기">&times;</button>
        <h3>🧾 영수증 분석 완료! 회원님을 위한 추천 도서</h3>
        <p>최근 등록하신 영수증을 분석하여 AI가 추천하는 책들이에요!</p>
        <div id="modal-book-list" class="book-list-container">
            </div>
    </div>
</div>

<div id="reopen-recommend-btn" style="display:none;">
    🎁
</div>


<style>
    /* ... 기존 .modal-overlay, .modal-content 등 스타일은 그대로 ... */
    .modal-overlay {
        position: fixed; top: 0; left: 0; width: 100%; height: 100%;
        background-color: rgba(0, 0, 0, 0.6); display: flex; justify-content: center;
        align-items: center; z-index: 1050; opacity: 0; visibility: hidden;
        transition: opacity 0.3s ease, visibility 0.3s ease;
    }
    .modal-overlay.show { opacity: 1; visibility: visible; }
    .modal-content {
        background-color: #fff; padding: 25px 30px; border-radius: 10px; width: 90%;
        max-width: 750px; box-shadow: 0 5px 15px rgba(0,0,0,0.3); position: relative;
        transform: translateY(-50px); transition: transform 0.3s ease;
    }
    .modal-overlay.show .modal-content { transform: translateY(0); }
    .modal-close-btn {
        position: absolute; top: 10px; right: 15px; font-size: 28px; font-weight: bold;
        color: #aaa; border: none; background: none; cursor: pointer; line-height: 1;
    }
    .modal-close-btn:hover { color: #333; }
    .modal-content h3 { margin-top: 0; color: #333; }
    .modal-content p { color: #666; font-size: 15px; }
    .book-list-container {
        display: flex; justify-content: center; flex-wrap: wrap; gap: 20px; margin-top: 20px;
    }
    .modal-book-item {
        width: 150px; text-align: center; text-decoration: none; color: #333;
        transition: transform 0.2s ease;
    }
    .modal-book-item:hover { transform: translateY(-5px); }
    .modal-book-item img {
        width: 100%; height: 220px; object-fit: cover; border: 1px solid #eee;
        border-radius: 5px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    }
    .modal-book-item .title {
        font-weight: bold; margin-top: 8px; font-size: 14px; height: 2.8em;
        line-height: 1.4em; overflow: hidden; text-overflow: ellipsis;
        display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical;
    }

    /* [추가] 플로팅 버튼 CSS */
    #reopen-recommend-btn {
        position: fixed;
        bottom: 30px;
        right: 30px;
        width: 60px;
        height: 60px;
        background-color: #007bff; /* 메인 컬러 */
        color: white;
        border-radius: 50%; /* 동그란 모양 */
        display: flex;
        justify-content: center;
        align-items: center;
        font-size: 28px;
        box-shadow: 0 4px 10px rgba(0,0,0,0.2);
        cursor: pointer;
        z-index: 1040; /* 팝업창보다는 아래에 위치 */
        transition: transform 0.2s ease;
    }
    #reopen-recommend-btn:hover {
        transform: scale(1.1);
        background-color: #0056b3;
    }
</style>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        
        // [추가] 플로팅 버튼 요소를 미리 찾아둠
        const reopenBtn = document.getElementById('reopen-recommend-btn');

        const isLoggedIn = ('${not empty sessionScope.member_idx}');
        if (isLoggedIn !== 'true') {
            console.log("로그인하지 않은 사용자입니다. 팝업을 띄우지 않습니다.");
            return;
        }

        if (getCookie("recommendPopupShown_v1") === "true") {
            console.log("1시간 내에 이미 추천 팝업을 봤습니다.");
            // [참고] 팝업은 안 띄우지만, 플로팅 버튼은 항상 보이게 할 수 있습니다.
            // 필요하다면 아래 주석을 해제하세요.
            // reopenBtn.style.display = 'flex'; 
            return; 
        }

        fetch('${pageContext.request.contextPath}/recommend/api/receipt-for-popup')
            .then(response => {
                if (response.status === 401) { throw new Error('로그인이 필요합니다.'); }
                if (response.status === 204) { return null; }
                if (!response.ok) { throw new Error('데이터를 가져오는 데 실패했습니다.'); }
                return response.json();
            })
            .then(books => {
                if (!books || books.length === 0) {
                    console.log("팝업에 표시할 추천 도서가 없습니다.");
                    return;
                }

                const bookListContainer = document.getElementById('modal-book-list');
                bookListContainer.innerHTML = ''; 

                books.forEach(book => {
                    const bookLink = document.createElement('a');
                    bookLink.href = '${pageContext.request.contextPath}/book/view?book_id=' + book.bookId;
                    bookLink.className = 'modal-book-item';
                    const bookTitle = book.bookTitle || "제목 없음";
                    bookLink.innerHTML = `
                        <img src="${pageContext.request.contextPath}/resources/img/product-img/\${book.coverImage}" alt="\${bookTitle}">
                        <div class="title">\${bookTitle}</div>
                    `;
                    bookListContainer.appendChild(bookLink);
                });

                const modal = document.getElementById('recommend-modal');
                showModal(modal);
                
                // [추가] 플로팅 버튼도 함께 보여줌
                reopenBtn.style.display = 'flex';

                // [수정] 쿠키 만료 시간을 1일에서 1시간으로 변경합니다.
                // 1일 = 1, 1시간 = 1/24
                setCookie("recommendPopupShown_v1", "true", 1/24); 

            })
            .catch(error => {
                console.error('추천 도서 로딩 중 문제 발생:', error);
            });
    });

    // --- 이벤트 리스너 및 제어 함수 영역 ---
    const modal = document.getElementById('recommend-modal');
    const closeBtn = document.getElementById('modal-close');
    const reopenBtn = document.getElementById('reopen-recommend-btn');

    // 팝업을 보여주는 함수
    function showModal(modalElement) {
        modalElement.style.display = 'flex';
        setTimeout(() => modalElement.classList.add('show'), 10);
    }

    // 팝업을 닫는 함수
    function closeModal() {
        modal.classList.remove('show');
        setTimeout(() => modal.style.display = 'none', 300);
    }   
    
    // 닫기 버튼 클릭 이벤트
    closeBtn.addEventListener('click', closeModal);

    // 팝업 외부 클릭 이벤트
    modal.addEventListener('click', function(event) {
        if (event.target === modal) {
            closeModal();
        }
    });

    // 플로팅 버튼 클릭 이벤트: 팝업을 다시 보여줌
    reopenBtn.addEventListener('click', function() {
        showModal(modal);
    });

    // --- 쿠키 유틸리티 함수  ---
    function setCookie(name, value, days) {
        let expires = "";
        if (days) {
            const date = new Date();
            // days 값에 소수점이 있어도 정확하게 밀리초로 계산됩니다.
            date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
            expires = "; expires=" + date.toUTCString();
        }
        document.cookie = name + "=" + (value || "")  + expires + "; path=/";
    }

    function getCookie(name) {
        const nameEQ = name + "=";
        const ca = document.cookie.split(';');
        for(let i=0; i < ca.length; i++) {
            let c = ca[i];
            while (c.charAt(0) === ' ') c = c.substring(1, c.length);
            if (c.indexOf(nameEQ) === 0) return c.substring(nameEQ.length, c.length);
        }
        return null;
    }
</script>


</body>
</html>