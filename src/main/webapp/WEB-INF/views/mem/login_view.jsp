<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 상단 헤더 영역 해당은 jsp 구분으로 /로 한다면 root페이지인 webapp 하위를 바라본다!  -->
<jsp:include page="/WEB-INF/views/include/header.jsp" flush="true"></jsp:include>
<!-- 로그인이 필요한 경우  login-need 적용, 로그인이 되어있음 안되는 경우 login-no-need-->
<jsp:include page="/WEB-INF/views/include/login-no-need.jsp" flush="true"></jsp:include>
<jsp:include page="/WEB-INF/views/include/mem/header-include.jsp" flush="true"></jsp:include>
<jsp:include page="/WEB-INF/views/include/header-common.jsp" flush="true"></jsp:include>
<!-- 상단 헤더 영역 끝 -->
<script src="https://www.google.com/recaptcha/api.js"></script>
<div class="contents-container">
     <div class="contents-login">
        <form id="loginForm" name="loginForm" autocomplete="off" action="login.do" method="post" onsubmit="return loginSubmit();">
            <div class="logo"><label for="id" class="logo-label">로그인 신규</label></div>
            <div class="input_row" id="id_area">
                <span class="input_box">
                    <!-- label은 감출꺼임 스크린리더기는 일반적으로 form컨트롤에 진입하면 기본은 label을 읽는다 만약 label이없으면 title이나 aria-label을 읽는다 -->
                    <!-- aria-describedby 해당 id=err_empty_id에 해당하는 곳을 읽어줌 accesskey : alt + I로 바로 접근 가능하다. -->
                    <input type="text" id="id" name="id" aria-describedby="err_empty_id" accesskey="I" placeholder="아이디" maxlength="41" value="" class="init">
                </span>
                <div id="err_empty_id" class="error" role="alert">아이디를 입력해주세요.</div>
            </div>
            <div class="input_row" id="pw_area">
                <span class="input_box">
                    <label for="pw" id="label_pw_area" class="label blind">비밀번호</label>
                    <input type="password" id="pw" name="pw" aria-describedby="err_empty_pw" placeholder="비밀번호" maxlength="16" class="init">
                </span>
                <div class="ly_v2" id="err_capslock">
                    <p role="alert"><strong>Caps Lock</strong>이 켜져 있습니다.</p>
                </div>
                <div class="error" role="alert" id="err_empty_pw">비밀번호를 입력해주세요.</div>
            </div>
            <c:if test="${sessionScope.checkBotChk != null}">
            <div class="input_row" id="grecaptcha_area">
                <span class="input_box g-recaptcha" data-sitekey="6LfMi38UAAAAABOIIh9y9vL_5BXk0kEzG3yh9Fkm"></span>
                <div class="error" role="alert" id="err_grecaptcha">사람임을 인증하세요</div>
            </div>
            </c:if>
            <div class="input_row" id="submit_area">
                <span class="input_box">
                    <label for="login-submit" id="label_submit_area" class="label blind">로그인</label>
                    <input type="submit" id="login-submit" title="login" name="login-submit" class="submit float-left j-button" value="로그인" >
                    <a href="join_view.do" class="j-button">회원가입</a>
                    <a href="id_find_view.do" class="j-button ratio-50">ID찾기</a>
                    <a href="pw_find_view.do" class="j-button ratio-50">PW찾기</a>
                </span>
            </div>
        </form>
    </div>
</div>
<script type="text/javascript">
if('undefined' === typeof window.honbabzone) {
    window.honbabzone = {};
}
if('undefined' === typeof window.honbabzone.common) {
    window.honbabzone.common = {};
}
var COMMON_UTILE = window.honbabzone.common;


function loginSubmit() {
    var id = $("#id");
    var pw = $("#pw");
    var $errId = $("#err_empty_id");
    var $errPw = $("#err_empty_pw");
    var $recaptcha = $(".g-recaptcha");
    var $recaptchaErr = $("#err_grecaptcha");
    COMMON_UTILE.hide([$errPw , $errId , $recaptchaErr ]);
    if(id.val() == "") {
        COMMON_UTILE.show($errId);
        $("#id").focus();
        return false;
    } else if(pw.val() == "") {
        COMMON_UTILE.show($errPw);
        $("#pw").focus();
        return false;
    } else if( $recaptcha.length > 0 ) {
        if (grecaptcha.getResponse() == "" ) {
        	COMMON_UTILE.show($recaptchaErr);
            return false;
        }
    }
    return true;
}
</script>
<!-- footer영역 끝 -->
<!-- 
구지 개별 파일을 src로 넣어도 되지만 include방식을 채택하는 이유는 혹시나 모듈화된 js파일이 추가될 경우 include파일 안에만 추가하면 되기 때문에  
추후 개발의 편의를 위해 분기
-->
<jsp:include page="/WEB-INF/views/include/footer-common.jsp" flush="true"></jsp:include>
<jsp:include page="/WEB-INF/views/include/mem/footer-include.jsp" flush="true"></jsp:include>
<jsp:include page="/WEB-INF/views/include/footer.jsp" flush="true"></jsp:include>
<!-- footer영역 끝 -->