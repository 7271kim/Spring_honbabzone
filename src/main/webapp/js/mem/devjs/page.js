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

    namespace.mem = (function() {
        var $body = $('body');
        var login_opts  = {
            wrap : '.contents-login',
            form : {
                formId  : '#loginForm',
                pw      : '#pw'
            }
        }
        
        var setLayout = function(){
            
        };
        var bindEvents = function(){
            $body.on('keyup.pw',login_opts.form.pw, COMMON_UTILE.checkShiftUp );
            $body.on('keydown.pw',login_opts.form.pw, COMMON_UTILE.checkShiftDown );
            $body.on('keypress.pw',login_opts.form.pw,COMMON_UTILE.capslockevt);
        };
        
        var init = function(){
            if ( $body.length < 1 ) return;
            
            setLayout();
            bindEvents();
        }
        
        return {
            init : init
        }
    })();
    
    namespace.mem.init();
    
})(window, window.jQuery);