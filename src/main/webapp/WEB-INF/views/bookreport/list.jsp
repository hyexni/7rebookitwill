<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 1. 페이지 기본 골격과 CSS/폰트 링크를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>
<style>

/* =============================== */
/* inquiry_detail.css (v2, 2025-06)*/
/* =============================== */

/* 기본 글꼴 & 색상 */
body {
  color: #212529;
  background:#fff;
}

/* ─────────── 페이지 래퍼 ─────────── */
.inquiry-detail {
  /* PC : 좌우 넉넉하게 1200px */
  max-width: 1200px;
  margin: 60px auto;
  padding: 0 40px;
}

/* 모바일 : 적당히 줄이기 */
@media (max-width: 768px) {
  .inquiry-detail {
    margin: 40px 10px;
    padding: 0 15px;
  }
}

/* ─────────── 타이틀 ─────────── */
.inquiry-detail h1 {
  font-size: 32px;          /* ⬆ 키웠음 */
  font-weight: 800;
  margin-bottom: 32px;
  border-bottom: 3px solid #eee;
  padding-bottom: 14px;
}

/* ─────────── 메타 정보 ─────────── */
.inquiry-meta {
  display: flex;
  flex-wrap: wrap;
  gap: 30px;
  font-size: 17px;          /* ⬆ */
  color: #555;
  margin-bottom: 28px;
}
.inquiry-meta div { flex: 1 1 240px; }

/* ─────────── 제목 & 본문 ─────────── */
.inquiry-title {
  font-size: 22px;          /* ⬆ */
  font-weight: 700;
  margin-bottom: 18px;
}
.inquiry-content {
  font-size: 18px;          /* ⬆ */
  line-height: 1.8;
  background: #f8f9fa;
  border-radius: 8px;
  padding: 24px;
  margin-bottom: 48px;
  white-space: pre-wrap;
}
.inquiry-body {
  background-color: #f8f9fa;
  padding: 20px;
  border-radius: 8px;
  font-size: 17px;
  line-height: 1.7;
  white-space: pre-wrap;
  margin-bottom: 40px;
}


/* ─────────── 관리자 답변 박스 ─────────── */
.reply-box {
  background: #f1f3f5;
  border-left: 6px solid #4c6ef5;
  border-radius: 8px;
  padding: 22px 24px;
  margin-bottom: 48px;
}
.reply-title {
  font-size: 20px;          /* ⬆ */
  font-weight: 700;
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 14px;
}
.reply-body {
  font-size: 20px;
  line-height: 1.7;
  white-space: pre-wrap;
  padding-top: 10px;
  padding-bottom: 10px;
}


.reply-date {
  font-size: 15px;
  color:#666;
  text-align: right;
  margin-top: 8px;
}

/* ─────────── 버튼 영역 ─────────── */
.button-box {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  flex-wrap: wrap;
}
.btn-back,
.btn-outline-warning,
.btn-outline-danger {
  font-size: 16px;
  padding: 10px 22px;
  border-radius: 6px;
  text-decoration: none;
  cursor: pointer;
  border: 1px solid transparent;         /* 항상 border 존재 */
  box-sizing: border-box;                /* ✅ padding + border 포함 */
  transition: all 0.2s ease;             /* 모든 속성 부드럽게 */
  font-weight: 500;                      /* hover 시 weight 튀는 것 방지 */
  line-height: 1.5;
  outline: none;                         /* ✅ 크기 튐 방지 */
}
.btn-back {
  background-color: #e9ecef;
  color: #333;
  border: 1px solid #e9ecef;
}
.btn-back:hover {
  background-color: #ced4da;
  color: #000;
  border: 1px solid #ced4da;
}

.btn-outline-warning {
  background-color: #fff;
  color: #f59f00;
  border: 1px solid #f59f00;
}
.btn-outline-warning:hover {
  background-color: #f59f00;
  color: #fff;
}

.btn-outline-danger {
  background-color: #fff;
  color: #ff4d4f;
  border: 1px solid #ff4d4f;
}
.btn-outline-danger:hover {
  background-color: #ff4d4f;
  color: #fff;
}


/* ─────────── 수정 폼 ─────────── */
#editForm {
  background:#fafafa;
  border:1px solid #eee;
  padding:24px;
  border-radius:8px;
}
#editForm label      { font-weight:600; margin-top:6px; }
#editForm .form-control { font-size:16px; }



</style>



<%-- 2. 상단 헤더를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/header.jsp" %> 

<%-- 3. 왼쪽 사이드바 메뉴를 불러옵니다. --%>
<%@ include file="/WEB-INF/views/include/sidebar.jsp" %>

<%-- 4. 여기서부터 '1:1 문의 목록' 페이지만의 고유한 컨텐츠가 시작됩니다. --%>

  <div class="inquiry-header">
    <h2><i class="fa fa-clipboard-list"></i>📋 나의 독후감 리스트</h2>
    <a href="/bookreport/write" class="btn-write">새글 등록</a>
  </div>

  <div class="table-wrapper">
    <table class="styled-table">
        <thead class="table-dark">
            <tr>
                <th>글번호</th>
                <th>제목</th>
                <th>도서명</th>
                <th>저자</th>
                <th>작성일</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="report" items="${reportList}">
                <tr style="cursor:pointer;" onclick="location.href='/bookreport/read?report_id=${report.report_id}'">
                    <td>${report.report_id}</td>
                    <td><c:out value="${report.report_title}"/></td>
                    <td><c:out value="${report.rbook_title}"/></td>
                    <td><c:out value="${report.author_name}"/></td>
                    <td>
                        <fmt:formatDate value="${report.report_regdate}" pattern="yyyy-MM-dd"/>
                    </td>
                </tr>
            </c:forEach>
             <c:if test="${empty reportList}">
                <tr>
                    <td colspan="4">작성된 독후감이 없습니다.</td>
                </tr>
            </c:if>
        </tbody>
    </table>

    <div class="d-flex justify-content-end mt-3">
        <a href="/bookreport/write" class="btn btn-primary">독후감 쓰기</a>
    </div>
</div>

</body>
</html>