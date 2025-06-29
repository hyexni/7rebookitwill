<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> <%-- JSTL functions 라이브러리 추가 --%>

<%-- 1. 페이지 기본 골격과 공통 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>


<style>
    /* ================================================================ */
    /* 페이지 전체 레이아웃 설정 */
    /* ================================================================ */
    html {
        height: 100%;
    }
    body {
        min-height: 100%;
        display: flex;
        flex-direction: column;
        color: #343a40;
        
            }

    /* ▼▼▼▼▼▼▼▼▼▼▼▼▼▼ 여기가 가장 중요한 수정 부분입니다 ▼▼▼▼▼▼▼▼▼▼▼▼▼▼ */
    main {
        flex: 1; /* footer를 하단에 고정하는 역할 */
        display: flex; /* 자식 요소(사이드바, 콘텐츠)를 가로로 배치 */
        justify-content: flex-start; /* 자식 요소들을 왼쪽으로 정렬! */
         align-items: stretch;  
         min-height: 0; 
    }
    /* ▲▲▲▲▲▲▲▲▲▲▲▲▲▲ 이 코드가 왼쪽 정렬을 수행합니다 ▲▲▲▲▲▲▲▲▲▲▲▲▲▲ */

    /* 콘텐츠 컨테이너 스타일 */
    .terms-container {
        max-width: 1200px;
        height: 1500px;
        /* auto 대신 고정된 여백을 주어 정렬을 직접 제어합니다. */
        margin: 20px 10px; 
        /* 부모(main)가 flex-grow로 늘어나는 자식을 제어할 것이므로 여기선 너비 100%를 줍니다. */
            background-color: #ffffff;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            overflow-y: auto; /* [수정] 내용이 길어질 경우 이 컨테이너에만 세로 스크롤 생성 */
        padding: 20px; /* 내부 여백을 추가하여 스크롤바와 내용이 겹치지 않게 함 */
        }
        h1 {
            font-size: 28px;
            font-weight: bold;
         
            margin-bottom: 20px;
            color: #343a40;
        }
        h2 {
            font-size: 20px;
            font-weight: bold;
            margin-top: 30px;
            margin-bottom: 10px;
            padding-bottom: 5px;
            border-bottom: 2px solid #e9ecef;
            color: #495057;
        }
        p, li {
            font-size: 15px;
            color: #495057;
            text-align: justify;
        }
        ol {
            padding-left: 20px;
        }
        ol li {
            margin-bottom: 8px;
        }
        .effective-date {
          
            margin-bottom: 30px;
            font-size: 14px;
            color: #6c757d;
        }
        strong {
            color: #0056b3;
        }
    </style>


<%@include file="/WEB-INF/views/include/header.jsp" %> 
<%@include file="/WEB-INF/views/include/sidebar.jsp" %>
<%@ include file="/WEB-INF/views/include/alert.jsp" %>

<main>
<div class="terms-container">
         <h1>ReBook (리북) 개인정보처리방침</h1>
    <p class="effective-date">시행일: 2025년 6월 29일</p>

    <p><strong>주식회사 리북</strong>(이하 '회사')은 개인정보보호법에 따라 이용자의 개인정보 및 권익을 보호하고 개인정보와 관련한 이용자의 고충을 원활하게 처리할 수 있도록 다음과 같은 처리방침을 두고 있습니다.</p>

    <h2>제1조 (개인정보의 처리 목적)</h2>
    <p>회사는 다음의 목적을 위하여 개인정보를 처리합니다. 처리하고 있는 개인정보는 다음의 목적 이외의 용도로는 이용되지 않으며, 이용 목적이 변경되는 경우에는 개인정보보호법 제18조에 따라 별도의 동의를 받는 등 필요한 조치를 이행할 예정입니다.</p>
    <ol>
        <li><strong>홈페이지 회원 가입 및 관리:</strong> 회원 가입의사 확인, 회원제 서비스 제공에 따른 본인 식별·인증, 회원자격 유지·관리, 서비스 부정이용 방지, 각종 고지·통지 등을 목적으로 개인정보를 처리합니다.</li>
        <li><strong>재화 또는 서비스 제공:</strong> 물품배송, 서비스 제공, 계약서·청구서 발송, 콘텐츠 제공, 맞춤서비스 제공, 요금결제·정산 등을 목적으로 개인정보를 처리합니다.</li>
        <li><strong>마케팅 및 광고에의 활용:</strong> 신규 서비스(제품) 개발 및 맞춤 서비스 제공, 이벤트 및 광고성 정보 제공 및 참여기회 제공, 접속빈도 파악 또는 회원의 서비스 이용에 대한 통계 등을 목적으로 개인정보를 처리합니다.</li>
    </ol>

    <h2>제2조 (처리하는 개인정보 항목)</h2>
    <p>회사는 다음의 개인정보 항목을 처리하고 있습니다.</p>
    <ol>
        <li><strong>회원 가입 및 관리:</strong>
            <ul>
                <li>필수항목: 성명, 아이디, 비밀번호, 주소, 연락처 ,성별 </li>
                <li>선택항목: 이메일 주소,</li>
            </ul>
        </li>
        <li><strong>재화 또는 서비스 제공:</strong>
            <ul>
                <li>필수항목: 성명, 주소, 연락처, 이메일주소, 신용카드번호, 은행계좌정보 등 결제정보</li>
            </ul>
        </li>
        <li><strong>인터넷 서비스 이용과정에서 아래 개인정보 항목이 자동으로 생성되어 수집될 수 있습니다.</strong>
            <ul>
                <li>IP주소, 쿠키, MAC주소, 서비스 이용기록, 방문기록, 불량 이용기록 등</li>
            </ul>
        </li>
    </ol>

    <h2>제3조 (개인정보의 처리 및 보유 기간)</h2>
    <ol>
        <li>회사는 법령에 따른 개인정보 보유·이용기간 또는 정보주체로부터 개인정보를 수집 시에 동의 받은 개인정보 보유·이용기간 내에서 개인정보를 처리·보유합니다.</li>
        <li>각각의 개인정보 처리 및 보유 기간은 다음과 같습니다.
            <ol type="a">
                <li><strong>회원 가입 및 관리:</strong> 회원 탈퇴 시까지. 다만, 다음의 사유에 해당하는 경우에는 해당 사유 종료 시까지 보유합니다.
                    <ul>
                        <li>관계 법령 위반에 따른 수사·조사 등이 진행 중인 경우 해당 수사·조사 종료 시까지</li>
                        <li>홈페이지 이용에 따른 채권·채무관계 잔존 시 해당 채권·채무관계 정산 시까지</li>
                    </ul>
                </li>
                <li><strong>재화 또는 서비스 제공:</strong> 재화·서비스 공급완료 및 요금결제·정산 완료 시까지.</li>
            </ol>
        </li>
    </ol>
    
    <h2>제4조 (개인정보의 제3자 제공)</h2>
    <p>회사는 정보주체의 개인정보를 제1조(개인정보의 처리 목적)에서 명시한 범위 내에서만 처리하며, 정보주체의 동의, 법률의 특별한 규정 등 개인정보 보호법 제17조에 해당하는 경우에만 개인정보를 제3자에게 제공합니다.</p>
    
    <h2>제5조 (개인정보처리의 위탁)</h2>
    <ol>
        <li>회사는 원활한 개인정보 업무처리를 위하여 다음과 같이 개인정보 처리업무를 위탁하고 있습니다.
            <ul>
                <li><strong>결제 처리:</strong> [결제대행사(PG) 이름]</li>
                <li><strong>상품 배송:</strong> [택배사 이름]</li>
            </ul>
        </li>
        <li>회사는 위탁계약 체결 시 개인정보 보호법 제26조에 따라 위탁업무 수행목적 외 개인정보 처리금지, 기술적·관리적 보호조치, 재위탁 제한, 수탁자에 대한 관리·감독, 손해배상 등 책임에 관한 사항을 계약서 등 문서에 명시하고, 수탁자가 개인정보를 안전하게 처리하는지를 감독하고 있습니다.</li>
    </ol>
    
    <h2>제6조 (이용자의 권리·의무 및 행사방법)</h2>
    <p>이용자는 개인정보주체로서 회사에 대해 언제든지 다음 각 호의 개인정보 보호 관련 권리를 행사할 수 있습니다.</p>
    <ol>
        <li>개인정보 열람요구</li>
        <li>오류 등이 있을 경우 정정 요구</li>
        <li>삭제요구</li>
        <li>처리정지 요구</li>
    </ol>

    <h2>제7조 (개인정보 보호책임자)</h2>
    <ol>
        <li>회사는 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 정보주체의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다.
            <ul>
                <li><strong>개인정보 보호책임자</strong></li>
                <li>성명: [담당자 이름]</li>
                <li>직책: [담당자 직책]</li>
                <li>연락처: [전화번호], [이메일], [팩스번호]</li>
            </ul>
        </li>
        <li>이용자는 회사의 서비스를 이용하시면서 발생한 모든 개인정보 보호 관련 문의, 불만처리, 피해구제 등에 관한 사항을 개인정보 보호책임자 및 담당부서로 문의하실 수 있습니다.</li>
    </ol>

    <h2>제8조 (개인정보의 파기)</h2>
    <p>회사는 개인정보 보유기간의 경과, 처리목적 달성 등 개인정보가 불필요하게 되었을 때에는 지체없이 해당 개인정보를 파기합니다. 파기의 절차 및 방법은 다음과 같습니다.</p>
    <ol>
        <li><strong>파기절차:</strong> 파기 사유가 발생한 개인정보를 선정하고, 회사의 개인정보 보호책임자의 승인을 받아 개인정보를 파기합니다.</li>
        <li><strong>파기방법:</strong> 전자적 파일 형태로 기록·저장된 개인정보는 기록을 재생할 수 없도록 파기하며, 종이 문서에 기록·저장된 개인정보는 분쇄기로 분쇄하거나 소각하여 파기합니다.</li>
    </ol>

    <h2>제9조 (개인정보의 안전성 확보 조치)</h2>
    <p>회사는 개인정보의 안전성 확보를 위해 다음과 같은 조치를 취하고 있습니다.</p>
    <ol>
        <li><strong>관리적 조치:</strong> 내부관리계획 수립·시행, 정기적 직원 교육 등</li>
        <li><strong>기술적 조치:</strong> 개인정보처리시스템 등의 접근권한 관리, 접근통제시스템 설치, 고유식별정보 등의 암호화, 보안프로그램 설치</li>
        <li><strong>물리적 조치:</strong> 전산실, 자료보관실 등의 접근통제</li>
    </ol>
    
    <h3>부칙</h3>
    <p>이 개인정보처리방침은 2025년 6월 29일부터 적용됩니다.</p>

    </div>

</main>
  
<%-- 4. 하단 푸터를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>

