<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Redirect</title>
<link rel="stylesheet" href="/css/common.css" type="text/css">
<script type="text/javascript" src="/js/jquery-3-3-1.js"></script>
<script src="/js/common.js"></script>
</head>
<body>
<div class="dim-layer">
    <div class="dimBg"></div>
    <div id="layer" class="pop-layer">
        <div class="pop-container">
            <div class="pop-conts">
                <!--content //-->
                <p class="ctxt mb20"></p>
                <div class="btn-r">
                    <a href="#" class="btn-layerClose">닫기</a>
                </div>
                <!--// content-->
            </div>
        </div>
    </div>
</div>
<c:if test="${msg != null || param.msg !=null }">
    <script>
        var message = '${msg}' || '${param.msg}';
        var returnUrl = '${url}'|| '${param.url}';
    
        layer_popup();
        function layer_popup( ){
            var $target = $('body').find('.dim-layer'); 
            var msg = decodeURI(decodeURIComponent(message));
            $target.find('.ctxt.mb20').html(msg);
            $target.css('display','block');
            var $el = $($target.find('#layer'));        //레이어의 id를 $el 변수에 저장
            var isDim = $el.prev().hasClass('dimBg');   //dimmed 레이어를 감지하기 위한 boolean 변수

            isDim ? $('.dim-layer').fadeIn() : $el.fadeIn();

            var $elWidth = $el.outerWidth(),
                $elHeight = $el.outerHeight(),
                docWidth = $(document).width(),
                docHeight = $(document).height();

            // 화면의 중앙에 레이어를 띄운다.
            if ($elHeight < docHeight || $elWidth < docWidth) {
                $el.css({
                    marginTop: -$elHeight /2,
                    marginLeft: -$elWidth/2
                })
            } else {
                $el.css({top: 0, left: 0});
            }

            $el.find('a.btn-layerClose').click(function(){
                isDim ? $('.dim-layer').fadeOut() : $el.fadeOut(); // 닫기 버튼을 클릭하면 레이어가 닫힌다.
                
                if (message && returnUrl) {
                    document.location.href = returnUrl;
                } else if (message && !returnUrl) {
                    history.back();
                } else if (!message && returnUrl) {
                    document.location.href = returnUrl;
                }
                
                return false;
            });

            $('.layer .dimBg').click(function(){
                $('.dim-layer').fadeOut();
                return false;
            });
        }
        
    </script>
</c:if>

</body>
</html>