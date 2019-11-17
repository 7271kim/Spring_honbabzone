/*!
 * @ Made by Kimseokjin 
 * @ 7271kim@naver.com
 * @ version 1.0.0
 * @ since 2018.11.11 
 */

;(function (win, $) {
    'use strict';

    if('undefined' === typeof win.honbabzone) {
        win.honbabzone = {};
    }

    if('undefined' === typeof win.honbabzone.common) {
        win.honbabzone.common = {};
    }

    var COMMON_UTILE = win.honbabzone.common;
    var namespace = win.honbabzone;

    namespace.navi = (function() {
        var $body = $('body');
        var $burger = $('.hambug-menu');
        var $dropDown = $('.drop-down');
        
        var setLayout = function(){
            dropDownMenu();
        };
        var bindEvents = function(){
        };
        
        var init = function(){
            if ( $body.length < 1 ) return;
            setLayout();
            bindEvents();
        };
        var dropDownMenu = function(){
            $burger.each(function(index){
                var $this = $(this);
                $this.on('click', function(e){
                e.preventDefault();
                $(this).toggleClass('right-go');
                $(this).find('.menu-trigger').toggleClass('active-4');
                if ($dropDown.hasClass('hide')) {
                $dropDown.removeClass('hide');
                    setTimeout(function () {
                        $dropDown.addClass('show');
                    }, 20);
                
                } else {
                    $dropDown.addClass('hide');
                    setTimeout(function () {
                        $dropDown.removeClass('show');
                        }, 20);
                    
                    }
                })
            });
        };
        
        return {
            init : init
        }
    })();
    
    namespace.navi.init();
    
})(window, window.jQuery);