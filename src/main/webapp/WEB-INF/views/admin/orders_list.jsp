<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="include/layout_head.jsp" %>
<%@ include file="include/header.jsp" %>
<%@ include file="include/sidebar.jsp" %>

<main class="main-content">
    <h2>📦 관리자 주문 목록</h2>
     
	<!-- 검색 필터 폼 -->
    <form id="filter-form" class="filter-form" method="get" action="${pageContext.request.contextPath}/admin/orders_list">
        <input type="text" name="member_id" placeholder="회원 ID" value="${cri.member_id}" />

        <select name="payment_status">
            <option value="">결제 상태 (전체)</option>
            <c:forEach var="status" items="${paymentStatusList}">
                <option value="${status}" ${cri.payment_status eq status ? 'selected' : ''}>${status}</option>
            </c:forEach>
        </select>

        <select name="delivery_status">
            <option value="">배송 상태 (전체)</option>
            <c:forEach var="status" items="${deliveryStatusList}">
                <option value="${status}" ${cri.delivery_status eq status ? 'selected' : ''}>${status}</option>
            </c:forEach>
        </select>

        <button type="submit" class="btn-primary">검색</button>
        <a href="${pageContext.request.contextPath}/admin/orders_list" class="btn-secondary">초기화</a>
    </form>

    <table class="detail-table">
        <thead>
            <tr>
                <th>주문번호</th>
                <th>회원 ID</th>
                <th>대표 상품</th>
                <th>총 금액</th>
                <th>결제 상태</th>
                <th>배송 상태</th>
                <th>주문일</th>
                <th>상세보기</th>
                <th>운송장</th>
            </tr>
        </thead>
        <tbody>
            <c:if test="${empty orderList}">
                <tr>
                    <td colspan="8" class="no-data">주문 내역이 없습니다.</td>
                </tr>
            </c:if>
            <c:forEach var="order" items="${orderList}">
                <tr>
                    <td>${order.order_id}</td>
                    <td>${order.member_id}</td>
                    <td>${order.book_title}</td>
                    <td><fmt:formatNumber value="${order.total_price}" type="currency"/></td>
                    <td>
					  <c:choose>
					    <c:when test="${order.status eq '결제완료'}">
					      <span class="status-paid">결제완료</span>
					    </c:when>
					    <c:when test="${order.status eq '결제취소'}">
					      <span class="status-failed">결제취소</span>
					    </c:when>
					    <c:otherwise>
					      <span class="status-pending">${order.status}</span>
					    </c:otherwise>
					  </c:choose>
					</td>
                   <td>
						  <select class="delivery-status-select" data-order-id="${order.order_id}">
						    <c:forEach var="status" items="${deliveryStatusList}">
						      <option value="${status}" <c:if test="${order.delivery_status eq status}">selected</c:if>>${status}</option>
						    </c:forEach>
						  </select>
						</td>
                    <td><fmt:formatDate value="${order.order_date}" pattern="yyyy-MM-dd"/></td>
                   <td>
					  <a href="${pageContext.request.contextPath}/admin/orders/detail?order_id=${order.order_id}" class="btn-detail">보기</a>
				   </td>
						<td>
						  <c:choose>
						    <c:when test="${not empty order.delivery.tracking_number}">
						      <button type="button"
						              class="btn-update"
						              onclick="openTrackingModal(${order.order_id}, '${fn:escapeXml(order.delivery.tracking_number)}')">
						        수정
						      </button>
						      <div>${order.delivery.tracking_number}</div>
						    </c:when>
						    <c:otherwise>
						      <button type="button"
						              class="btn-register"
						              onclick="openTrackingModal(${order.order_id}, '')">
						        등록
						      </button>
						    </c:otherwise>
						  </c:choose>
						</td>
	              </tr>
            </c:forEach>
        </tbody>
    </table>

    <div class="pagination">
        <c:if test="${cri.prev}">
            <a href="${pageContext.request.contextPath}/admin/orders_list?page=${cri.startPage - 1}&member_id=${cri.member_id}&payment_status=${cri.payment_status}&delivery_status=${cri.delivery_status}">«</a>
        </c:if>
        <c:forEach var="num" begin="${cri.startPage}" end="${cri.endPage}">
            <a href="${pageContext.request.contextPath}/admin/orders_list?page=${num}&member_id=${cri.member_id}&payment_status=${cri.payment_status}&delivery_status=${cri.delivery_status}"
               class="${cri.page eq num ? 'active' : ''}">${num}</a>
        </c:forEach>
        <c:if test="${cri.next}">
            <a href="${pageContext.request.contextPath}/admin/orders_list?page=${cri.endPage + 1}&member_id=${cri.member_id}&payment_status=${cri.payment_status}&delivery_status=${cri.delivery_status}">»</a>
        </c:if>
    </div>
</main>

<!-- 운송장 등록 모달 -->
<div id="trackingModal" class="modal" style="display:none;">
  <div class="modal-content">
    <span class="close" onclick="closeTrackingModal()">&times;</span>
    <h3>📦 운송장 번호 등록</h3>
    <form id="trackingForm">
      <input type="hidden" name="order_id" id="modal_order_id" />
      <label>택배사</label>
      <input type="text" value="우체국택배" readonly />
      <label>운송장 번호</label>
      <input type="text" name="tracking_number" id="tracking_number" placeholder="운송장 번호 입력" required />
      <button type="submit" class="btn btn-success">등록</button>
    </form>
  </div>
</div>

<script>

document.addEventListener('DOMContentLoaded', function () {
    console.log("📦 JS 로딩 완료!");

    var selects = document.querySelectorAll('.delivery-status-select');
    console.log("✅ 발견된 드롭다운 수:", selects.length);

    selects.forEach(function (select) {
        select.addEventListener('change', function (event) {
        	 console.log("🖱 드롭다운 'change' 이벤트 발생함!");

            var selectElement = event.target;
            var orderId = selectElement.getAttribute('data-order-id');
            var newStatus = selectElement.value;

            if (!confirm('주문번호 [' + orderId + ']의 배송 상태를 \'' + newStatus + '\'으로 변경하시겠습니까?')) {
                window.location.reload();
                return;
            }

            var url = '${pageContext.request.contextPath}/admin/orders/updateDeliveryStatus';
            var data = {
                order_id: orderId,
                delivery_status_code: newStatus
            };

            console.log("🚀 서버에 요청 보냄:", data);

            fetch(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            })
            .then(function (response) {
                if (!response.ok) {
                    throw new Error('서버 응답 오류: ' + response.status + ' ' + response.statusText);
                }
                return response.text();
            })
            .then(function (result) {
                console.log("🎯 서버 응답:", result);

                if (result === 'SUCCESS') {
                    alert('배송 상태가 성공적으로 변경되었습니다.');
                    selectElement.value = newStatus;
                } else {
                    alert('배송 상태 변경에 실패했습니다: ' + result);
                }
            })
            .catch(function (error) {
                console.error('❌ 오류 발생:', error);
                alert('오류가 발생하여 배송 상태를 변경할 수 없습니다.');
                window.location.reload();
            });
        });
    });
});
const ctx = "${pageContext.request.contextPath}";

// 🚚 운송장 모달 관련 처리
function openTrackingModal(orderId, trackingNumber) {
	console.log("🚚 모달 오픈", orderId, trackingNumber);  // ✅ 이거 추가
    document.getElementById("modal_order_id").value = orderId;
    document.getElementById("tracking_number").value = trackingNumber || "";
    document.getElementById("trackingModal").style.display = "flex";
}

function closeTrackingModal() {
    document.getElementById("trackingModal").style.display = "none";
}

// 등록 버튼 submit
document.getElementById("trackingForm").addEventListener("submit", function (e) {
    e.preventDefault();

    const order_id = document.getElementById("modal_order_id").value;
    const tracking_number = document.getElementById("tracking_number").value;

    fetch(ctx + "/admin/updateTracking", {  // 🔥 수정
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({ order_id, tracking_number })
    })
    .then(res => res.json())
    .then(data => {
        if (data.success) {
            alert("✅ 운송장 번호 등록 완료!");
            closeTrackingModal();
            location.reload();
        } else {
            alert("🚫 등록 실패: " + (data.message || "다시 시도해주세요."));
        }
    })
    .catch(err => {
        console.error("❌ 에러 발생:", err);
        alert("오류가 발생했습니다.");
    });
});
</script>


<script>
  // 🚨 오류 방지용: 함수가 없으면 실행 안 함
  if (typeof drawStatusChart === 'function') {
      drawStatusChart();
  }
</script>

<script>
  // 🚨 오류 방지용: 함수가 없으면 실행 안 함
  if (typeof drawStatusChart === 'function') {
      drawStatusChart();
  }
</script>

<style>

/* ====== 기본 ====== */
.main-content {
  padding: 20px;
  font-family: 'Noto Sans KR', sans-serif;
}
.main-content h2 {
  font-size: 20px;
  margin-bottom: 15px;
  font-weight: 600;
}

/* ====== 필터 ====== */
.filter-form {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  padding: 15px;
  background-color: #f8f9fa;
  border-radius: 8px;
  margin-bottom: 20px;
  align-items: center;
}
.filter-form input[type="text"],
.filter-form select {
  padding: 8px;
  border: 1px solid #ccc;
  border-radius: 4px;
  min-width: 150px;
}

/* ====== 버튼 공통 ====== */
.btn-primary, .btn-secondary {
  padding: 8px 15px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  text-decoration: none;
  font-size: 14px;
  font-weight: 500;
  transition: background-color 0.2s ease-in-out;
}
.btn-primary {
  background-color: #007bff;
  color: white;
}
.btn-primary:hover {
  background-color: #0056b3;
}
.btn-secondary {
  background-color: #6c757d;
  color: white;
}
.btn-secondary:hover {
  background-color: #5a6268;
}

/* ====== 상세 테이블 ====== */
.detail-table {
  width: 100%;
  border-collapse: collapse;
  margin-bottom: 20px;
  font-size: 14px;
  table-layout: fixed;
}
.detail-table th, .detail-table td {
  border: 1px solid #ddd;
  padding: 12px;
  text-align: center;
  vertical-align: middle;
}
.detail-table th {
  background-color: #f2f2f2;
  font-weight: 600;
}
.detail-table tbody tr:nth-child(odd) {
  background-color: #f9f9f9;
}
.detail-table .no-data {
  padding: 40px;
  color: #777;
  font-size: 16px;
}

/* ====== 운송장 등록/수정 버튼 ====== */
.detail-table td .btn-register {
  background-color: #17a2b8;
  color: white;
  padding: 5px 12px;
  border: none;
  border-radius: 20px;
  font-size: 13px;
  cursor: pointer;
}
.detail-table td .btn-register:hover {
  background-color: #138496;
}
.detail-table td .btn-update {
  background-color: #ffc107;
  color: #212529;
  padding: 5px 12px;
  border: none;
  border-radius: 20px;
  font-size: 13px;
  cursor: pointer;
}
.detail-table td .btn-update:hover {
  background-color: #e0a800;
}

/* ====== 보기 버튼 ====== */
.btn-detail {
  background-color: #6c757d;
  color: white;
  padding: 5px 10px;
  font-size: 12px;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  transition: background-color 0.2s;
}
.btn-detail:hover {
  background-color: #5a6268;
}

/* ====== 결제 상태 색상 ====== */
.status-paid {
  color: #28a745;
  font-weight: bold;
}
.status-failed {
  color: #dc3545;
  font-weight: bold;
}
.status-pending {
  color: #343a40;
  font-weight: bold;
}

/* ====== 운송장 셀 ====== */
.detail-table td.tracking {
  max-width: 200px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

/* ====== 페이징 ====== */
.pagination {
  display: flex;
  justify-content: center;
  margin-top: 24px;
  gap: 6px;
}
.pagination a {
  display: flex;
  justify-content: center;
  align-items: center;
  min-width: 32px;
  height: 32px;
  padding: 0 10px;
  color: #007bff;
  border: 1px solid #dee2e6;
  border-radius: 4px;
  text-decoration: none;
  font-size: 14px;
  transition: all 0.2s ease-in-out;
}
.pagination a.active {
  background-color: #007bff;
  color: white;
  border-color: #007bff;
  font-weight: bold;
}
.pagination a:hover:not(.active) {
  background-color: #e9ecef;
  border-color: #adb5bd;
}

/* ====== 모달 ====== */
.modal {
  display: none;
  justify-content: center;
  align-items: center;
  background-color: transparent !important;
  z-index: 9999 !important;
}
.modal-content {
  display: block !important;
  opacity: 1 !important;
  visibility: visible !important;
  position: relative !important;
  left: auto !important;
  top: auto !important;
  pointer-events: auto !important;
}
.modal-content .close {
  position: absolute;
  top: 12px;
  right: 15px;
  font-size: 24px;
  font-weight: bold;
  color: #999;
  cursor: pointer;
}
.modal-content .close:hover {
  color: #333;
}
</style>


