<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

  
  <script>

    /**
     * [수정] 올바른 addEventListener 사용법
     * window 객체에 'load' 이벤트가 발생했을 때(페이지 로딩 완료 시),
     * 뒤따라오는 콜백 함수(function)를 실행하도록 '등록'합니다.
     */
    window.addEventListener('load', function() {
    	<c:if test="${not empty msg}">
      Swal.fire({
        // 아이콘 종류: success, error, warning, info, question 중 하나
        // icon이 없으면 기본값 'info' 사용
        icon: '${icon != null ? icon : "info"}',

        // 메시지 출력
        // fn:escapeXml() 로 XSS 공격 방지 (특수문자 이스케이프 처리)
        // replaceAll("\n", "<br/>") 로 줄바꿈 문자 \n 을 HTML 줄바꿈 태그 <br/> 로 변환
        html: "${fn:escapeXml(msg)}".replaceAll("\\n", "<br/>"),

        // 확인 버튼 색상 커스텀
        confirmButtonColor: '#0056b3', // 가독성이 좋은 색으로 유지하는 것을 추천합니다.
        confirmButtonText: '확인'
      });
      </c:if>
    });
  </script>
