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
     <div class="contents-join">
        <form id="join-form" name="join-form" autocomplete="off" action="pw_change.do" method="post" onsubmit="return loginSubmit();">
            <div class="logo"><h2 class="logo-label">PW변경</h2></div>
            <div class="input_row" id="pw_area">
                <h3 class='join-title'><label for="pw">비밀번호</label></h3>
                <span class="input_box">
                    <input type="password" id="pw" name="pw" aria-describedby="err_empty_pw" placeholder="비밀번호" maxlength="16" class="init">
                </span>
                <div class="ly_v2" id="err_capslock">
                    <p role="alert"><strong>Caps Lock</strong>이 켜져 있습니다.</p>
                </div>
                <div class="error" role="alert" id="err_empty_pw">비밀번호를 입력해주세요.</div>
                <div id="err_empty_pw_etc" class="error" role="alert"></div>
            </div>
            <div class="input_row" id="pw_check_area">
                 <h3 class='join-title'><label for="pw_ck">비밀번호확인</label></h3>
                <span class="input_box">
                    <label for="pw_ck" id="label_pw_check_area" class="label blind">비밀번호확인</label>
                    <input type="password" id="pw_ck" name="pw_ck" aria-describedby="err_empty_pw_ck" placeholder="비밀번호확인" maxlength="16" class="init">
                </span>
                <div class="ly_v2" id="err_capslock_ck">
                    <p role="alert"><strong>Caps Lock</strong>이 켜져 있습니다.</p>
                </div>
                <div class="error" role="alert" id="err_empty_pw_ck">비밀번호를 입력해주세요.</div>
                <div id="err_empty_pw_check_etc" class="error" role="alert"></div>
            </div>
            <div class="input_row" id="submit_area">
                <span class="input_box">
                    <label for="login-submit" id="label_submit_area" class="label blind">비밀번호 변경</label>
                    <input type="submit" id="login-submit" title="join" name="login-submit" class="submit float-left j-button" value="비밀번호 변경" >
                    <a href="login_view.do" class="j-button">로그인</a>
                </span>
            </div>
        </form>
    </div>
</div>
<script src="/js/mem/address-api.js"></script>
<script type="text/javascript">
$("#postcodify_search_button").postcodifyPopUp();

if('undefined' === typeof window.honbabzone) {
    window.honbabzone = {};
}
if('undefined' === typeof window.honbabzone.common) {
    window.honbabzone.common = {};
}
var COMMON_UTILE = window.honbabzone.common;

//opener관련 오류가 발생하는 경우 아래 주석을 해지하고, 사용자의 도메인정보를 입력합니다. ("팝업API 호출 소스"도 동일하게 적용시켜야 합니다.)
//document.domain = "abc.go.kr";
var $pw = $("#pw");
var $pw_ck = $("#pw_ck");
var $errPw = $("#err_empty_pw");
var $errPwEtc = $("#err_empty_pw_etc");
var $errPwCk = $("#err_empty_pw_ck");
var $errPwCkEtc = $("#err_empty_pw_check_etc");

var pwFlag = false;

$(document).ready(function() {
	 $('.contents-join').on( 'blur', '#pw', checkPw );
	 $('.contents-join').on( 'blur', '#pw_ck', checkPwCk );
});

function checkPw (e){
    pwFlag = false;
    var cnt =0;
    var $target = e.currentTarget != undefined ? $(e.currentTarget) : e;
    var value = $target.val();
    var mgs = '';
    
    COMMON_UTILE.hide([$errPw ,$errPwEtc ]);
    
    if(value == ''){
        COMMON_UTILE.show($errPw);
        return false;
    }
    
    /* 공백 확인 */
    if ( value.search(/\s/) > -1 ) {
        mgs = '스페이스바 사용은 불가능 합니다.';
        COMMON_UTILE.errShow($errPwEtc ,mgs);
        return false;
    }
    
    /* length확인 */
    if ( value.length < 8 ) {
        mgs = '비밀번호는 8글자 이상입니다.';
        COMMON_UTILE.errShow($errPwEtc ,mgs);
        return false;
    }
    
    /* length확인 */
    if ( value.length < 8 ) {
        mgs = '비밀번호는 8글자 이상입니다.';
        COMMON_UTILE.errShow($errPwEtc ,mgs);
        return false;
    }
    
    /* 반복된 글자 불가. */
    for( var i = 0; i < value.length; ++i) {
        if (value.charAt(0) == value.substring(i, i + 1))
            ++cnt;
    }
    if (cnt == value.length) {
        mgs = '중복된 글자의 비번은 불가능 합니다.';
        COMMON_UTILE.errShow($errPwEtc ,mgs);
        return false;
    }
    
    var isPW = /^[A-Za-z0-9`\-=\\\[\];',\./~!@#\$%\^&\*\(\)_\+|\{\}:"<>\?]{8,16}$/;
    if (!isPW.test(value)) {
        mgs = '영문 숫자 조합의 특수기호를 사용한 8글자 - 16글자 이하의 비번이여야 합니다';
        COMMON_UTILE.errShow($errPwEtc ,mgs);
        return false;
    }

    
    pwFlag = true;
    return true;
}

function checkPwCk (e){
    pwFlag = false;
    
    var $target = e.currentTarget != undefined ? $(e.currentTarget) : e;
    var value = $target.val();
    var mgs = '';
    COMMON_UTILE.hide([$errPwCk, $errPwCkEtc]);
    if(value == ''){
        COMMON_UTILE.show($errPwCk);
        return false;
    }
    if(value != $pw.val()){
        mgs = '비번이 서로 다릅니다.';
        COMMON_UTILE.errShow($errPwCkEtc  ,mgs);
        return false;
    }
    pwFlag = true;
    return true;
}



function loginSubmit() {
    COMMON_UTILE.hide([$errPw,$errPwEtc,$errPwCk,$errPwCkEtc]);
    if(  !pwFlag  ){
    	checkPw($pw);
        checkPwCk($pw_ck);
        return false;
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