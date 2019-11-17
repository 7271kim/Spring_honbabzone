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

    namespace.main = (function() {
        var $body = $('body');
        var $youtubeVideo = $('.youtube-video');
        var videoDate =[];
        
        var setLayout = function(){
            $youtubeVideo.each(function(index){
                var $this = $(this);
                var thisVideData = $this.data('video-data');
                videoDate.push(thisVideData);
            })
            youTubePlayer.playVideo(videoDate);
        };
        var bindEvents = function(){
        };
        
        var init = function(){
            if ( $body.length < 1 ) return;
            setLayout();
            bindEvents();
        };
        var youTubePlayer = {
                playVideo: function(videoDate) {
                    if (typeof(YT) == 'undefined' || typeof(YT.Player) == 'undefined') {
                      window.onYouTubeIframeAPIReady = function() {
                          youTubePlayer.loadPlayer(videoDate);
                      };

                      $.getScript('//www.youtube.com/iframe_api');
                    } else {
                        youTubePlayer.loadPlayer(videoDate);
                    }
                  },
                  loadPlayer: function(videoDate) {
                      for(var i in videoDate){
                          var container = videoDate[i].divID;
                          var videoId   = videoDate[i].videoID;
                          var autoPlay  = videoDate[i].autoPlay =='true' ? 1 : 0;
                          var controls  = videoDate[i].controls =='true' ? 1 : 0;
                          new YT.Player(container, {
                              videoId: videoId,
                              width: 356,
                              height: 200,
                              playerVars: {
                                autoplay: autoPlay,
                                controls: controls,
                                modestbranding: 1,
                                rel: 0,
                                showInfo: 0
                              }
                          });
                      }
                  }
                };
        
        return {
            init : init
        }
    })();
    
    namespace.main.init();
    
})(window, window.jQuery);