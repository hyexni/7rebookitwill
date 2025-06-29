<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- 1. 페이지 기본 골격과 공통 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>

<style>
    /* ================================================================ */
    /* 페이지 전체 레이아웃 (기존 구조 유지) */
    /* ================================================================ */
    html, body {
        height: 100%;
        margin: 0;
    }
    body {
        min-height: 100%;
        display: flex;
        flex-direction: column;
        color: #343a40;
    }
    main {
        flex: 1;
        display: flex;
        /* 내용이 길어질 때를 대비한 스크롤 처리 */
        overflow: hidden;
    }

    /* ================================================================ */
    /* FAQ 페이지 전용 스타일 */
    /* ================================================================ */
    .faq-container {
        flex-grow: 1; /* 남은 가로 공간을 모두 차지 */
        overflow-y: auto; /* 내용이 길어지면 이 영역만 스크롤 */
        padding: 30px;
        background-color: #fff;
    }
    .faq-container h1 {
        font-size: 28px;
        font-weight: bold;
        margin-bottom: 30px;
        color: #343a40;
        padding-bottom: 15px;
        border-bottom: 2px solid #343a40;
    }
    .faq-container h2 {
        font-size: 22px;
        font-weight: 500;
        margin-top: 40px;
        margin-bottom: 20px;
        color: #0056b3;
    }

    /* 각 FAQ 아이템 스타일 */
    .faq-item {
        border-bottom: 1px solid #e9ecef;
    }

    /* 질문(Question) 영역 스타일 */
    .faq-question {
        padding: 18px 10px;
        cursor: pointer;
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-size: 16px;
        font-weight: 500;
        transition: background-color 0.2s;
    }
    .faq-question:hover {
        background-color: #f8f9fa;
    }
    
    /* 토글 아이콘 (+, -) 스타일 */
    .faq-toggle-icon {
        font-size: 24px;
        font-weight: 300;
        color: #888;
        transition: transform 0.3s ease-out;
    }
    
    /* 답변(Answer) 영역 스타일 */
    .faq-answer {
        background-color: #f8f9fa;
        /* display: none; */ /* JS로 제어하지만, 부드러운 효과를 위해 max-height 사용 */
        max-height: 0; /* 기본적으로 답변을 숨김 */
        overflow: hidden;
        transition: max-height 0.4s ease-in-out, padding 0.4s ease-in-out; /* 부드러운 열림/닫힘 효과 */
    }
    .faq-answer p {
        padding: 20px;
        margin: 0;
        font-size: 15px;
        line-height: 1.6;
        color: #495057;
    }

    /* === 활성화 상태 스타일 (JS로 .active 클래스 추가 시 적용) === */
    .faq-item.active .faq-question {
        color: #0056b3;
        font-weight: bold;
    }
    .faq-item.active .faq-answer {
        max-height: 500px; /* 답변이 나타날 충분한 높이 (내용에 따라 조절) */
    }
    .faq-item.active .faq-toggle-icon {
        transform: rotate(45deg); /* '+' 아이콘을 'x' 모양으로 회전 */
        color: #0056b3;
    }
</style>


<%@include file="/WEB-INF/views/include/header.jsp" %>
<%@include file="/WEB-INF/views/include/sidebar.jsp" %>
<%@ include file="/WEB-INF/views/include/alert.jsp" %>

<main>
    <div class="faq-container">
        <h1>자주 묻는 질문 (FAQ)</h1>

        <h2>✅회원</h2>
        <div class="faq-item">
            <div class="faq-question">
                <span>회원가입은 어떻게 하나요?</span>
                <span class="faq-toggle-icon">+</span>
            </div>
            <div class="faq-answer">
                <p>
                    ReBook 쇼핑몰 상단의 '회원가입' 메뉴를 통해 가입하실 수 있습니다. 약관 동의 및 간단한 정보 입력을 통해 가입이 완료되며, 가입 즉시 다양한 혜택을 받으실 수 있습니다.
                </p>
            </div>
        </div>
        <div class="faq-item">
            <div class="faq-question">
                <span>아이디/비밀번호를 잊어버렸어요.</span>
                <span class="faq-toggle-icon">+</span>
            </div>
            <div class="faq-answer">
                <p>
                    로그인 페이지 하단의 '아이디 찾기', '비밀번호 찾기' 기능을 이용해 주세요. 가입 시 등록한 이메일 주소 또는 휴대폰 번호 인증을 통해 아이디 확인 및 비밀번호 재설정이 가능합니다.
                </p>
            </div>
        </div>

        <h2>✅주문/결제</h2>
        <div class="faq-item">
            <div class="faq-question">
                <span>어떤 결제 수단을 사용할 수 있나요?</span>
                <span class="faq-toggle-icon">+</span>
            </div>
            <div class="faq-answer">
                <p>
                    신용카드, 체크카드, 실시간 계좌이체, 무통장 입금, 휴대폰 소액결제 등 다양한 결제 수단을 지원하고 있습니다. 자세한 내용은 결제 페이지에서 확인하실 수 있습니다.
                </p>
            </div>
        </div>
        <div class="faq-item">
            <div class="faq-question">
                <span>주문 내역은 어디서 확인하나요?</span>
                <span class="faq-toggle-icon">+</span>
            </div>
            <div class="faq-answer">
                <p>
                    로그인 후 '마이페이지 > 주문/배송 조회' 메뉴에서 최근 주문 내역 및 현재 처리 상태를 확인하실 수 있습니다. 비회원으로 주문하신 경우, 주문 시 발급받은 주문번호로 조회가 가능합니다.
                </p>
            </div>
        </div>
        
        <h2>✅ 배송</h2>
        <div class="faq-item">
            <div class="faq-question">
                <span>배송 기간은 얼마나 걸리나요?</span>
                <span class="faq-toggle-icon">+</span>
            </div>
            <div class="faq-answer">
                <p>
                    평일 오후 3시 이전 결제 완료 건은 당일 출고를 원칙으로 합니다. 배송은 출고일로부터 보통 1~3일(영업일 기준) 소요되나, 택배사 사정이나 지역에 따라 다소 지연될 수 있습니다.
                </p>
            </div>
        </div>
        <div class="faq-item">
            <div class="faq-question">
                <span>배송비는 얼마인가요?</span>
                <span class="faq-toggle-icon">+</span>
            </div>
            <div class="faq-answer">
                <p>
                    기본 배송비는 3,000원이며, 50,000원 이상 구매 시 무료 배송 혜택을 드립니다. 제주 및 도서/산간 지역은 별도의 추가 운임이 발생할 수 있습니다.
                </p>
            </div>
        </div>

        <h2>✅교환/반품/환불</h2>
        <div class="faq-item">
            <div class="faq-question">
                <span>상품을 교환하거나 반품하고 싶어요.</span>
                <span class="faq-toggle-icon">+</span>
            </div>
            <div class="faq-answer">
                <p>
                    상품 수령일로부터 7일 이내에 '마이페이지' 또는 고객센터를 통해 교환/반품 신청이 가능합니다. 단, 상품의 택(tag)이나 포장이 훼손되었거나 사용 흔적이 있는 경우에는 처리가 어려울 수 있습니다. 고객님의 단순 변심에 의한 교환/반품 시에는 왕복 배송비가 부과됩니다.
                </p>
            </div>
        </div>
        <div class="faq-item">
            <div class="faq-question">
                <span>환불은 어떻게 진행되나요?</span>
                <span class="faq-toggle-icon">+</span>
            </div>
            <div class="faq-answer">
                <p>
                    반품하신 상품이 저희 쪽에 도착하여 검수가 완료되면 환불 절차가 진행됩니다. 신용카드는 카드사 영업일 기준 3~5일 후 승인 취소를 확인하실 수 있으며, 무통장 입금의 경우 신청하신 계좌로 1~2일 내에 환불됩니다.
                </p>
            </div>
        </div>

    </div>
</main>
  
<%-- 4. 하단 푸터를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>

<%-- 아코디언 기능을 위한 JavaScript --%>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        // 모든 .faq-question 요소를 선택합니다.
        const faqQuestions = document.querySelectorAll('.faq-question');

        // 각 질문에 대해 클릭 이벤트를 추가합니다.
        faqQuestions.forEach(question => {
            question.addEventListener('click', function () {
                // 클릭된 질문의 부모 .faq-item 요소를 찾습니다.
                const faqItem = this.parentElement;
                
                // 클릭된 아이템에 'active' 클래스를 토글(추가/제거)합니다.
                // CSS에서 .active 상태에 따라 답변을 보여주거나 숨깁니다.
                faqItem.classList.toggle('active');
            });
        });
    });
</script>