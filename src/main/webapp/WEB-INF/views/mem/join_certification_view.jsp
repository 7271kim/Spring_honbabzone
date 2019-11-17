<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 상단 헤더 영역 해당은 jsp 구분으로 /로 한다면 root페이지인 webapp 하위를 바라본다!  -->
<jsp:include page="/WEB-INF/views/include/header.jsp" flush="true"></jsp:include>
<!-- 로그인이 필요한 경우  login-need 적용, 로그인이 되어있음 안되는 경우 login-no-need-->
<jsp:include page="/WEB-INF/views/include/mem/header-include.jsp" flush="true"></jsp:include>
<jsp:include page="/WEB-INF/views/include/header-common.jsp" flush="true"></jsp:include>
<!-- 상단 헤더 영역 끝 -->
<%
String emailChk = (String)session.getAttribute("emailChk");
if( emailChk==null || emailChk.equals("") || emailChk.length() ==0 ){
%>
<script>
var text = encodeURI(encodeURIComponent("잘못된 접근입니다."));
location.href="/mem/redirect.do?msg="+text+"&url=/mem/login_view.do";
</script>
<%
}
%>
<div class="contents-container">
    <div class="contents-login">
        <p>Email 이메일인증을 하셔야 합니다.</p>
        <p><span id="time-min">00</span> : <span id="time-sec">00</span></p>
        <p>가입 이메일을 확인하세요<span class="count-down">${sessionScope.email}</span></p>
        <p><a class="common-button" href="/mem/login_view.do" title="go login">확인 완료</a></p>
    </div>
</div>
<script>
var emailCountDown = ${sessionScope.emailCountDown};
dailyMissionTimer( emailCountDown );
function dailyMissionTimer(duration) {
    
    //var timer = duration * 3600;
    var timer = duration;
    var hours, minutes, seconds;
    
    if ( timer == 0) {
        var text = encodeURI(encodeURIComponent("인증시간이지나 다시 로그인이 필요합니다."));
        location.href="/mem/login_view.do?msg="+text;
    }
    
    var interval = setInterval(function(){
        hours   = parseInt(timer / 3600, 10);
        minutes = parseInt(timer / 60 % 60, 10);
        seconds = parseInt(timer % 60, 10);
        
        hours   = hours < 10 ? "0" + hours : hours;
        minutes = minutes < 10 ? "0" + minutes : minutes;
        seconds = seconds < 10 ? "0" + seconds : seconds;
        
        $('#time-hour').text(hours);
        $('#time-min').text(minutes);
        $('#time-sec').text(seconds);

        if (--timer < 0) {
            timer = 0;
            clearInterval(interval);
            var text = encodeURI(encodeURIComponent("인증시간이지나 다시 로그인이 필요합니다."));
            location.href="/mem/login_view.do?msg="+text;
        }
    }, 1000);
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