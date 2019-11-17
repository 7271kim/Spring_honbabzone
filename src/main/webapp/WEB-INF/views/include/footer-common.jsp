<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="dim-layer">
    <div class="dimBg"></div>
    <div id="layer" class="pop-layer">
        <div class="pop-container">
            <div class="pop-conts">
                <!--content //-->
                <p class="ctxt mb20"></p>
                <div class="btn-r">
                    <a href="#" class="btn-layerClose" data-check="yes">확인</a>
                    <a href="#" class="btn-layerClose" data-check="no">닫기</a>
                </div>
                <!--// content-->
            </div>
        </div>
    </div>
</div>
<c:if test="${param.msg != null }">
    <script>
        layer_popup();
        function layer_popup( ){
            var $target = $('body').find('.dim-layer'); 
            var msg = decodeURI(decodeURIComponent('${param.msg}'));
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
                return false;
            });

            $('.layer .dimBg').click(function(){
                $('.dim-layer').fadeOut();
                return false;
            });
        }
        
    </script>
</c:if>
<script src="/js/common.js"></script>

