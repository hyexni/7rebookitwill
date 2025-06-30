<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 1. 페이지 기본 골격과 공통 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="include/layout_head.jsp" %>
<%-- [추가] Chart.js 라이브러리. layout_head.jsp에 없다면 여기에 추가합니다. --%>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.2.0/dist/chartjs-plugin-datalabels.min.js"></script>

<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@ include file="include/header.jsp" %> 

<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@ include file="include/sidebar.jsp" %> 

<%-- 
=========================================================================
    [핵심] 관리자 포인트 내역 페이지 전용 스타일 정의
=========================================================================
--%>
<style>
    /* 이 스타일은 다른 페이지에 영향을 주지 않도록, 
      모든 선택자 앞에 고유 클래스인 .admin-point-containerssss 를 붙여 범위를 제한합니다. 
    */

    .admin-point-containerssss h1 {
        font-size: 26px;
        font-weight: 700;
        color: #212529;
        margin-top: 0;
        margin-bottom: 30px;
        text-align: center;
    }

    /* [추가] 차트 섹션 스타일 */
    .admin-point-containerssss .chart2-section {
        display: flex;
        //flex-wrap: wrap; /* 화면이 작아지면 줄바꿈 처리 */ 
         justify-content: space-around;
         gap: 30px;  
       margin-bottom: 40px;  
        padding: 25px 20px; 
        background-color: #f8f9fa;
        border-radius: 8px;
        border: 1px solid #e9ecef;
    }
    .admin-point-containerssss .chart2-wrapper {
        width: 45%;
        min-width: 300px; /* 최소 너비 지정 */
        max-width: 400px;
    }
    .admin-point-containerssss .chart2-wrapper h3 {
        text-align: center;
        font-size: 18px;
        font-weight: 600;
        color: #343a40;
        margin-bottom: 15px;
    }

    /* 검색 폼 */
    .admin-point-containerssss .search-form {
        margin-bottom: 30px;
        padding: 20px;
        background-color: #f1f3f5;
        border-radius: 6px;
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 10px;
    }
    .admin-point-containerssss .search-form select,
    .admin-point-containerssss .search-form input[type="text"] {
        padding: 9px 12px;
        border: 1px solid #dee2e6;
        border-radius: 4px;
        font-size: 15px;
        transition: border-color 0.2s, box-shadow 0.2s;
    }
    .admin-point-containerssss .search-form select:focus,
    .admin-point-containerssss .search-form input[type="text"]:focus {
        outline: none;
        border-color: #4c6ef5;
        box-shadow: 0 0 0 2px rgba(76, 110, 245, 0.2);
    }
    .admin-point-containerssss .search-form input[type="submit"] {
        padding: 9px 25px;
        font-size: 15px;
        font-weight: 500;
        color: #fff;
        background-color: #4c6ef5;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        transition: background-color 0.2s;
    }
    .admin-point-containerssss .search-form input[type="submit"]:hover {
        background-color: #364fc7;
    }

    /* 테이블 */
    .admin-point-containerssss table {
        width: 100%;
        border-collapse: collapse;
        font-size: 15px;
    }
    .admin-point-containerssss thead {
        background-color: #f8f9fa;
    }
    .admin-point-containerssss th, 
    .admin-point-containerssss td {
        padding: 14px 10px;
        text-align: center;
        border-bottom: 1px solid #dee2e6;
    }
    .admin-point-containerssss th {
        color: #495057;
        font-weight: 500;
        vertical-align: middle;
    }
    .admin-point-containerssss tbody tr:hover {
        background-color: #f1f3f5;
    }

    /* 정렬 기능 시각적 표현 (화살표) */
    .admin-point-containerssss th a {
        text-decoration: none;
        color: inherit;
        display: inline-block;
        position: relative;
        padding-right: 15px;
    }
    .admin-point-containerssss th.asc a::after,
    .admin-point-containerssss th.desc a::after {
        content: '';
        position: absolute;
        right: 0;
        top: 50%;
        transform: translateY(-50%);
        font-size: 10px;
        color: #4c6ef5;
    }
    .admin-point-containerssss th.asc a::after {
        content: '▲';
    }
    .admin-point-containerssss th.desc a::after {
        content: '▼';
    }

    /* 내역 없을 때 메시지 */
    .admin-point-containerssss .no-records {
        text-align: center;
        padding: 60px 20px;
        color: #868e96;
    }

    /* 페이지네이션 */
    .admin-point-containerssss .pagination {
        margin-top: 30px;
        text-align: center;
    }
    .admin-point-containerssss .pagination a {
        display: inline-block;
        width: 36px;
        height: 36px;
        line-height: 36px;
        margin: 0 4px;
        text-align: center;
        text-decoration: none;
        color: #495057;
        background-color: #fff;
        border: 1px solid #dee2e6;
        border-radius: 4px;
        transition: all 0.2s;
    }
    .admin-point-containerssss .pagination a:hover {
        background-color: #f1f3f5;
        border-color: #4c6ef5;
        color: #4c6ef5;
    }
    .admin-point-containrerssss .pagination a.active {
        background-color: #4c6ef5;
        border-color: #4c6ef5;
        color: #fff;
        font-weight: 500;
        cursor: default;
    }

	.grantPointBtn {
	font-size : 20px 
	}
	
	/* [추가] 포인트 지급하기 버튼 스타일 */
#grantPointBtn {
    display: inline-block;
    padding: 10px 25px; /* 버튼 크기 */
    background-color: #20c997; /* 버튼 배경색 (산뜻한 녹색) */
    color: white; /* 글자색 */
    font-size: 16px; /* 폰트 크기 (인라인 스타일 대신 CSS로 관리) */
    font-weight: 600; /* 폰트 굵기 */
    text-align: center;
    text-decoration: none; /* 링크 밑줄 제거 */
    border-radius: 5px; /* 버튼 모서리 둥글게 */
    transition: background-color 0.2s ease-in-out; /* 부드러운 전환 효과 */
    box-shadow: 0 2px 4px rgba(0,0,0,0.1); /* 약간의 그림자 효과 */
}

/* 버튼에 마우스를 올렸을 때 스타일 */
#grantPointBtn:hover {
    background-color: #12b886; /* 살짝 어두운 색으로 변경 */
    color: white;
</style>


<%-- 공통 레이아웃의 메인 콘텐츠 영역 (예시) --%>
<main class="main2-content">
    <%-- 이 페이지의 모든 콘텐츠를 감싸는 고유한 컨테이너 클래스 추가 --%>
    <div class="admin-point-containerssss">
        <h1>💰 고객 포인트 전체 내역</h1>

        <%-- ========================================================================= --%>
        <%--                  [추가] 월간 포인트 통계 차트 섹션                      --%>
        <%-- ========================================================================= --%>
         <div class="search-form">
            
            <%-- 컨트롤러가 @GetMapping("/admin/pointHistory") 라면 이 코드를, --%>
            <%-- @GetMapping("/admin/point-history") 라면 이전 답변의 코드를 사용하세요. --%>
            <form action="<c:url value='/admin/pointHistory'/>" method="get">
                <select name="searchType">
                    <option value="member_id" ${pageMaker.cri.searchType == 'member_id' ? 'selected' : ''}>회원 아이디</option>
                    <option value="change_reason" ${pageMaker.cri.searchType == 'change_reason' ? 'selected' : ''}>변경 사유</option>
                    <option value="point_status" ${pageMaker.cri.searchType == 'point_status' ? 'selected' : ''}>상태</option>
                </select>
                <input type="text" name="keyword" value="${pageMaker.cri.keyword}" placeholder="검색어를 입력하세요">
                <input type="submit" value="검색">
            </form>

				<a href="<c:url value='/admin/add' />" id="grantPointBtn" style="font-size:20px">✨ 포인트 지급하기</a>
        </div>
        
        
        
        
        <div class="chart2-section">
            <div class="chart2-wrapper">
                <h3>📈 이번 달 적립 항목별 분석</h3>
                <canvas id="monthlyAccrualChart"></canvas>
            </div>
            <div class="chart2-wrapper">
                <h3>📊 이번 달 적립/사용 분석</h3>
                <canvas id="monthlyUsageChart"></canvas>
            </div>
        </div>

       
        <table>
            <thead>
                <tr>
                    <th class="${pageMaker.cri.sortColumn == 'point_id' ? pageMaker.cri.sortOrder : ''}">
                        <a href="<c:url value='/admin/pointHistory${pageMaker.cri.sortUrl("point_id")}' />">내역번호</a>
                    </th>
                    <th class="${pageMaker.cri.sortColumn == 'member_id' ? pageMaker.cri.sortOrder : ''}">
                        <a href="<c:url value='/admin/pointHistory${pageMaker.cri.sortUrl("member_id")}' />">회원 아이디</a>
                    </th>
                    <th class="${pageMaker.cri.sortColumn == 'change_date' ? pageMaker.cri.sortOrder : ''}">
                        <a href="<c:url value='/admin/pointHistory${pageMaker.cri.sortUrl("change_date")}' />">변경일시</a>
                    </th>
                    <th>변경 사유</th>
                    <th>변경 포인트</th>
                    <th>적용 후 포인트</th>
                    <th>상태</th>
                </tr>
            </thead>
              <tbody>
                <c:choose>
                    <c:when test="${not empty historyList}">
                        <c:forEach var="history" items="${historyList}">
                            <tr>
                                <td>${history.point_id}</td>
                                <td>${history.member_id}</td>
                                <td><fmt:formatDate value="${history.change_date}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                                <td>${history.change_reason}</td>
                                <td><fmt:formatNumber value="${history.change_amount}" pattern="+ #,##0;- #,##0"/></td>
                                <td><fmt:formatNumber value="${history.point_amount}" pattern="#,###"/> P</td>
                                <td>${history.point_status}</td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="7" class="no-records">포인트 내역이 없습니다.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>

        <div class="pagination">
            <c:if test="${pageMaker.prev}">
                <a href="<c:url value='/admin/pointHistory${pageMaker.cri.pageUrl(pageMaker.startPage - 1)}'/>">&laquo;</a>
            </c:if>

            <c:forEach begin="${pageMaker.startPage}" end="${pageMaker.endPage}" var="pageNum">
                <a href="<c:url value='/admin/pointHistory${pageMaker.cri.pageUrl(pageNum)}'/>" class="${pageMaker.cri.page == pageNum ? 'active' : ''}">${pageNum}</a>
            </c:forEach>

            <c:if test="${pageMaker.next}">
                <a href="<c:url value='/admin/pointHistory${pageMaker.cri.pageUrl(pageMaker.endPage + 1)}'/>">&raquo;</a>
            </c:if>
        </div>
    </div> <%-- /.admin-point-containerssss --%>
</main> <%-- /.main2-content --%>

<%-- 4. 하단 푸터를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/footer.jsp" %>


<%-- ========================================================================= --%>
<%--                [최종 수정] 차트 생성을 위한 JavaScript 코드                 --%>
<%-- ========================================================================= --%>
<script>
document.addEventListener('DOMContentLoaded', function() {
    
    // [추가] 데이터 라벨 플러그인을 전역으로 등록합니다.
    // 이 코드는 한 번만 실행하면 됩니다.
    Chart.register(ChartDataLabels);

    // Controller에서 넘겨준 통계 데이터를 JavaScript 변수로 받습니다.
    const accrualData = {
        '신규가입': ${empty accrualStats['신규 회원가입 축하'] ? 0 : accrualStats['신규 회원가입 축하']},
        '영수증적립': ${empty accrualStats['영수증 인증 적립'] ? 0 : accrualStats['영수증 인증 적립']},
        '구매적립': ${empty accrualStats['결제 적립금'] ? 0 : accrualStats['결제 적립금']}
    };

    const usageData = {
        '적립': ${empty usageStats['적립'] ? 0 : usageStats['적립']},
        '사용': ${empty usageStats['사용'] ? 0 : usageStats['사용']}
    };
    
    const isAllZero = (dataObject) => Object.values(dataObject).every(value => value === 0);

    // 1. 월간 적립 항목별 분석 차트 (원형)
    const accrualCtx = document.getElementById('monthlyAccrualChart');
    if (isAllZero(accrualData)) {
        accrualCtx.style.display = 'none';
        const noDataMsg = document.createElement('div');
        noDataMsg.textContent = '이번 달 적립 내역이 없습니다.';
        noDataMsg.style.textAlign = 'center';
        noDataMsg.style.padding = '50px 20px';
        noDataMsg.style.color = '#868e96';
        accrualCtx.parentNode.appendChild(noDataMsg);
    } else {
        new Chart(accrualCtx, {
            type: 'pie',
            data: {
                labels: Object.keys(accrualData),
                datasets: [{
                    label: '포인트',
                    data: Object.values(accrualData),
                    backgroundColor: ['rgba(75, 192, 192, 0.7)', 'rgba(54, 162, 235, 0.7)', 'rgba(255, 206, 86, 0.7)'],
                    borderColor: '#fff',
                    borderWidth: 2
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { position: 'bottom' },
                    tooltip: { callbacks: { label: function(context) { let label = context.label || ''; if (label) { label += ': '; } if (context.parsed !== null) { label += new Intl.NumberFormat('ko-KR').format(context.parsed) + ' P'; } return label; } } },
                    
                    // [추가] 데이터 라벨 플러그인 설정
                    datalabels: {
                        // 숫자의 형식을 정합니다 (예: 1000 -> 1,000)
                        formatter: (value, context) => {
                            return new Intl.NumberFormat('ko-KR').format(value)+ ' P';
                        },
                        color: '#ffffff', // 라벨 색상
                        font: {
                            weight: 'bold', // 폰트 굵기
                            size: 14 // 폰트 크기
                        }
                    }
                }
            }
        });
    }

    // 2. 월간 적립/사용 분석 차트 (도넛)
    const usageCtx = document.getElementById('monthlyUsageChart');
    if(isAllZero(usageData)) {
        usageCtx.style.display = 'none';
        const noDataMsg = document.createElement('div');
        noDataMsg.textContent = '이번 달 포인트 변동 내역이 없습니다.';
        noDataMsg.style.textAlign = 'center';
        noDataMsg.style.padding = '50px 20px';
        noDataMsg.style.color = '#868e96';
        usageCtx.parentNode.appendChild(noDataMsg);
    } else {
         new Chart(usageCtx, {
            type: 'doughnut',
            data: {
                labels: Object.keys(usageData),
                datasets: [{
                    label: '포인트',
                    data: Object.values(usageData),
                    backgroundColor: ['rgba(76, 110, 245, 0.7)', 'rgba(255, 99, 132, 0.7)'],
                    borderColor: '#fff',
                    borderWidth: 2
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { position: 'bottom' },
                    tooltip: { callbacks: { label: function(context) { let label = context.label || ''; if (label) { label += ': '; } if (context.parsed !== null) { label += new Intl.NumberFormat('ko-KR').format(context.parsed) + ' P'; } return label; } } },

                    // [추가] 데이터 라벨 플러그인 설정
                    datalabels: {
                        formatter: (value, context) => {
                            return new Intl.NumberFormat('ko-KR').format(value) + ' P';
                        },
                        color: '#ffffff',
                        font: {
                            weight: 'bold',
                            size: 14
                        }
                    }
                }
            }
        });
    }
});
</script>