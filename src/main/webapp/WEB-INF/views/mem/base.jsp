<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 상단 헤더 영역 해당은 jsp 구분으로 /로 한다면 root페이지인 webapp 하위를 바라본다!  -->
<jsp:include page="/WEB-INF/views/include/header.jsp" flush="true"></jsp:include>
<!-- 로그인이 필요한 경우  login-need 적용, 로그인이 되어있음 안되는 경우 login-no-need-->
<jsp:include page="/WEB-INF/views/include/login-no-need.jsp" flush="true"></jsp:include>
<jsp:include page="/WEB-INF/views/include/mem/header-include.jsp" flush="true"></jsp:include>
<jsp:include page="/WEB-INF/views/include/header-common.jsp" flush="true"></jsp:include>
<!-- 상단 헤더 영역 끝 -->
<div class="contents-container">
     <div class="contents-login">
    </div>
</div>

<!-- footer영역 끝 -->
<!-- 
구지 개별 파일을 src로 넣어도 되지만 include방식을 채택하는 이유는 혹시나 모듈화된 js파일이 추가될 경우 include파일 안에만 추가하면 되기 때문에  
추후 개발의 편의를 위해 분기
-->
<jsp:include page="/WEB-INF/views/include/footer-common.jsp" flush="true"></jsp:include>
<jsp:include page="/WEB-INF/views/include/mem/footer-include.jsp" flush="true"></jsp:include>
<jsp:include page="/WEB-INF/views/include/footer.jsp" flush="true"></jsp:include>
<!-- footer영역 끝 -->