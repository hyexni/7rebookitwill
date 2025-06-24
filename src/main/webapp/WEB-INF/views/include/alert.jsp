<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!--
  msg가 비어있지 않을 때만 알림창 스크립트를 실행합니다.
  컨트롤러에서 flash attribute로 보낸 msg와 icon을 받아서 처리합니다.
-->
<c:if test="${not empty msg}">
  <!-- SweetAlert2 라이브러리 CDN 불러오기 -->
  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
  <script>
    window.onload = function() {
      Swal.fire({
        // 아이콘 종류: success, error, warning, info, question 중 하나
        // icon이 없으면 기본값 'info' 사용
        icon: '${icon != null ? icon : "info"}',

        // 메시지 출력
        // fn:escapeXml() 로 XSS 공격 방지 (특수문자 이스케이프 처리)
        // replaceAll("\n", "<br/>") 로 줄바꿈 문자 \n 을 HTML 줄바꿈 태그 <br/> 로 변환
         html: "${fn:escapeXml(msg)}".replaceAll("\\n", "<br/>"),

        // 확인 버튼 색상 커스텀
        confirmButtonColor: '#f4a261'
      });
    };
  </script>
</c:if>