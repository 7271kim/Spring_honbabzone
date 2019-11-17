<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="/css/navi/page.css" type="text/css">
<section>
    <div class="main-navi">
        <div class="main-logo">
            <span class="hambug-menu">
                <a class="menu-trigger" href="javascript:void(0);">
                    <span></span>
                    <span></span>
                    <span class="nthtype-04"></span>
                </a>
            </span>
        <a href ="/main/main.do"><span>HON BAB ZONE</span></a> <a href ="/main/log-out.do" class="float-right"><img src="/img/main/log-out.svg"></a>
        </div>
        <form id="search-main" name="search-main" autocomplete="off" action="search-main.do" method="post" onsubmit="return loginSubmit();">
            <div class="input_row" id="search_txt_area">
                <span class="input_box">
                    <input type="text" id="search" name="search" aria-describedby="search_txt_area" accesskey="I" placeholder="검색어를 입력하세요" maxlength="100" value="">
                    <span class="submit-search"></span>
                </span>
                <div id="search_txt_area" class="blind">검색어 입력</div>
            </div>
        </form>
        <div class="drop-down hide">
            <div class="trasfrom-wrap">
                <div class="mypage-area">
                    <a href="/main/mypage.do" title="mypage"><img src="/img/main/people-profile.png"> <span>내 정보</span></a>
                </div>
                <ul>
                    <li><a href="/board/simsim/list.do" title="심심이 게시판">심 심 이</a><span class="arrow-right"></span></li>
                    <li><a href="/board/babzo.do" title="배고파 게시판">배 고 파</a><span class="arrow-right"></span></li>
                    <li><a href="/board/zinzi.do" title="진지충 게시판">진 지 충</a><span class="arrow-right"></span></li>
                    <li><a href="/board/zihwaja.do" title="지화자 게시판">지 화 자</a><span class="arrow-right"></span></li>
                    <li><a href="/board/zota.do" title="좋쿠나 게시판">좋 쿠 나</a><span class="arrow-right"></span></li>
                </ul>
            </div>
        </div>
    </div>
</section>
<script src="/js/navi/page.js"></script>
