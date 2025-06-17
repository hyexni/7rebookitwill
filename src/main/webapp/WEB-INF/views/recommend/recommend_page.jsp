<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
    
<!-- 템플릿 해더 추가 -->
<!-- ./  상대주소 ./views <=> /webapp/WEB-INF/views -->
<!-- ../ 절대주소 상위폴더로 이동-->



<%@include file="../include/header.jsp" %>

<!-- 로그인 안 된 경우 -->
<c:if test="${needLogin}">
  <div style="padding: 30px; text-align: center;">
    <h3>⚠ 로그인한 사용자만 이용할 수 있는 기능입니다.</h3>
    <a href="${pageContext.request.contextPath}/member/login">[ 로그인 하러가기 ]</a>
  </div>
</c:if>

<!-- 로그인 된 경우 -->
<c:if test="${!needLogin}">
  <div style="padding: 40px;">

	
    <h2 style="margin-bottom: 20px;">📚 나만을 위한 도서 추천</h2>
    
    <script>
  		console.log("▶ session member_idx:", "${sessionScope.member_idx}");
	</script>
    
    <!-- 드롭다운 (정렬 기능) -->
    <%@ include file="sort.jsp" %>

    <hr style="margin: 30px 0;">

	<!-- 🛒 구매 기반 추천 include -->
    <h3>🛒 구매 도서 기반 추천 (/recommend/purchase.jsp)</h3>
    <%@ include file="purchase.jsp" %>

    <hr style="margin: 30px 0;">

    <!-- 💖 찜 기반 추천 include -->
    <h3>💖 찜 도서 기반 추천 (/recommend/wishlist.jsp)</h3>
    <%@ include file="wishlist.jsp" %>

	</div>
</c:if>


</body>
</html>


<%-- <%@include file="../include/footer.jsp" %>  --%>

