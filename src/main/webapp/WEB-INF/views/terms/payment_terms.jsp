<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/WEB-INF/views/include/layout_head.jsp" %>
<%@ include file="/WEB-INF/views/include/header.jsp" %>

<div class="container" style="padding: 40px;">
  <h2>📄 결제 약관</h2>
  <hr>

  <p>본 결제 약관은 이용자가 본 웹사이트에서 결제를 진행함에 있어 반드시 숙지해야 할 조건을 포함합니다.</p>

  <h4>1. 결제 수단</h4>
  <ul>
    <li>신용/체크카드, 카카오페이 중 선택 가능합니다.</li>
    <li>모든 결제는 안전한 결제 시스템을 통해 처리됩니다.</li>
  </ul>

  <h4>2. 포인트 사용</h4>
  <ul>
    <li>보유 포인트 내에서 결제 금액 일부 또는 전액을 사용할 수 있습니다.</li>
    <li>포인트는 환불되지 않으며, 타인에게 양도할 수 없습니다.</li>
  </ul>

  <h4>3. 환불 및 취소</h4>
  <ul>
    <li>결제 후 7일 이내에는 배송 전이라면 전액 환불 가능합니다.</li>
    <li>배송 후 환불은 도서 상태 확인 후 처리되며 왕복 배송비가 차감될 수 있습니다.</li>
  </ul>

  <h4>4. 기타</h4>
  <ul>
    <li>결제 전 반드시 수량, 금액, 배송 정보를 확인해 주세요.</li>
    <li>결제 완료 후에는 시스템상 자동으로 주문이 처리됩니다.</li>
  </ul>

  <p>본 약관에 동의하시면 결제를 진행해 주세요.</p>

  <button onclick="window.close()" class="btn btn-primary">닫기</button>
</div>

<%@ include file="/WEB-INF/views/include/footer.jsp" %>
