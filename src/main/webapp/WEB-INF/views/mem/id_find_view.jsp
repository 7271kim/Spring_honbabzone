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
        <form id="join-form" name="join-form" autocomplete="off" action="id_find.do" method="post" onsubmit="return loginSubmit();">
            <div class="logo"><h2 class="logo-label">ID 찾기</h2></div>
            <div class="input_row" id="email_area">
                <h3 class='join-title'><label for="email">E-mail</label></h3>
                <span class="input_box">
                    <label for="email" id="label_email_area" class="label blind">가입하실때 사용한 이메일을 확인하세요</label>
                    <input type="email" id="email" name="email" aria-describedby="err_email" placeholder="가입하실때 사용한 이메일 입력하세요" class="init">
                </span>
                <div class="error" role="alert" id="err_email">이메일을 양식에 맞게 입력해주세요.</div>
                <div id="err_empty_email_etc" class="error" role="alert"></div>
            </div>
            <div class="input_row" id="submit_area">
                <span class="input_box">
                    <label for="login-submit" id="label_submit_area" class="label blind">ID찾기</label>
                    <input type="submit" id="login-submit" title="join" name="login-submit" class="submit float-left j-button" value="ID찾기" >
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
var $email = $("#email");
var $errEmail = $("#err_email");
var $errEmailEtc = $("#err_empty_email_etc");

var emailFlag = false;

$(document).ready(function() {
    $('.contents-join').on( 'blur', '#email', checkEmail );
});

function checkEmail (e){
    emailFlag = false;
    
    var $target = e.currentTarget != undefined ? $(e.currentTarget) : e;
    var value = $target.val();
    var isEmail = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    var isHan = /[ㄱ-ㅎ가-힣]/g;
    var mgs = '';
    COMMON_UTILE.hide([$errEmail , $errEmailEtc ]);
    
    if(value == ''){
        COMMON_UTILE.show($errEmail);
        return false;
    }
    
    if (!isEmail.test(value) || isHan.test(value)) {
        mgs="이메일 주소를 확인하세요";
        COMMON_UTILE.errShow($errEmailEtc, mgs);
        return false;
    }
    
    emailFlag = true;
    return true;
}


function loginSubmit() {
    COMMON_UTILE.hide([$errEmail]);
    if(  !emailFlag  ){
        checkEmail($email);
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