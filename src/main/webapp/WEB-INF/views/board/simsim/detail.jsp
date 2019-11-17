<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 상단 헤더 영역 해당은 jsp 구분으로 /로 한다면 root페이지인 webapp 하위를 바라본다!  -->
<jsp:include page="/WEB-INF/views/include/header.jsp" flush="true"></jsp:include>
<jsp:include page="/WEB-INF/views/include/login-need.jsp" flush="true"></jsp:include>
<jsp:include page="/WEB-INF/views/include/board/header-include.jsp" flush="true"></jsp:include>
<jsp:include page="/WEB-INF/views/include/header-common.jsp" flush="true"></jsp:include>
<jsp:include page="/WEB-INF/views/include/main/menu-include.jsp" flush="true"></jsp:include>

<script src="/js/editor/lib/tui-code-snippet/tui-code-snippet.js"></script>
<script src="/js/editor/lib/markdown-it/markdown-it.js"></script>
<script src="/js/editor/lib/highlightjs/highlight.pack.js"></script>


<link rel="stylesheet" href="/js/editor/lib/codemirror/codemirror.css">
<link rel="stylesheet" href="/js/editor/lib/highlightjs/github.css">
<link rel="stylesheet" href="/js/editor/dist/tui-editor-contents.css">

<script src="/js/editor/dist/tui-editor-Viewer.js"></script>

<!-- 상단 헤더 영역 끝 -->
<div class="container-sisim-detail">
    <div class="board-detail-upper">    
        <h2><a href="list.do" title="심심이 게시판으로 이동">심심이 게시판</a></h2>
    </div>
    <div class="board-detail-content">
        <div class="board-title-area">
            <div class="title-content">
                <p class="title">${detail.sTitle }</p>
            </div>
            <div class="view-content">
                <span class="writer"><a href="#">[ ${detail.id } ]</a> | <a href="#" title="친구신청" >친구신청</a> | <a href="#" title="쪽지보내기" >쪽지보내기</a></span>
                <span class="view">${detail.sJoinUpdate } | 조회 ${detail.readCount } | 스크랩 ${detail.script } | <a href="#">신고하기</a></span>
            </div>
            <div class="files-downLoad">
                 <c:forEach var="filenames" items="${filenames }">
                    <a href="download.do?seq=${detail.seq }&name=${filenames }" class="down-load-files" target="_blank"><img src="/img/board/fileDown.png">${filenames }</a>
                </c:forEach>
                
            </div>
        </div>
        <div class="board-detail-area">
            <div id="editSectionView"></div>
            <div class="share">
                <a href="#" id="board-favorite"><img src="/img/main/favorite.png"> 좋아요</a>
                <span class="share-text"> 공유하기</span>
                <a href="#" id="facebook" ><img src="/img/main/facebook.png"></a>
                <a href="#" id="twitter"><img src="/img/main/twitter.png"></a>
                <a href="#" id="google"><img src="/img/main/google.png"></a>
                <c:if test="${loginIdCk == detail.id || isAdminCk }">
                    <a href="update_view.do?seq=${detail.seq }&pageNum=${param.pageNum}&searchField=${param.searchField}&searchString=${param.searchString}"><img src="/img/board/update.png"></a>
                    <a href="javascript:void(0);" class="board-remove"><img src="/img/board/remove.png"></a>
                </c:if>
            </div>
        </div>
    </div>
    <div class="board-detail-bottom">
        <span class="count-text">${detail.childrenCount }개의 댓글이 있습니다.</span>
        <div class="comment-view">
            <ul>
            <c:forEach var="comments" items="${commentBeans }">
                <li>
                    <div class="comment-contents">
                        <img src="/img/main/people-profile.png"><span class="commont-writer">${comments.id }</span><span class="commont-text">${comments.sContent }</span>
                    </div>
                    <div class="comment-time"><button id="show-child" data-seq="${comments.seq }">답글[${comments.childrenCount }]</button> ${comments.sJoinUpdate } | <a href="#">신고하기</a></div>
                </li>
            </c:forEach>
            </ul>
            <button class="see-more" id="see-more">더 보기</button>
        </div>
        <div class="comment-write">
            <form action="commentWrite.do" method="post" id="comment-write-forms">
                <input type="hidden" name="sGroup" value="${detail.seq }">
                <input type="hidden" name=limitEnd id="limitEnd" value="${param.limitEnd !=null ? param.limitEnd : 5 }">
                <input type="hidden" name="seq" value="${detail.seq }">
                <input type="hidden" name="pageNum" value="${param.pageNum }">
                <input type="hidden" name="searchField" value="${param.searchField }">
                <input type="hidden" name="searchString" value="${param.searchString }">
                <textarea rows="3" cols="30" id="commont-text" name="sContent"></textarea>
                <input type="submit" class="comment-submit" value="등록">
            </form>
        </div>
    </div>
</div>
<script>
$(document).ready(function() {
    var contents = "${detail.sContent }".replace(/<br>/g,'\n');
    $('.container-sisim-detail').on( 'click', '#show-child', appendChild );
    $('.container-sisim-detail').on( 'click', '#see-more', seeMore );
    $('#editSectionView').tuiEditor({
        height: '300px',
        initialValue: contents
    });
    $('.btn-layerClose').on('click.removeBoard',removeBoard);
    
});

var removeBoard = function(e){
    var $targetValue = $(e.currentTarget).data('check');
    if($targetValue=='yes'){
       $('.btn-layerClose').off('click.removeBoard',removeBoard);
        location.href="remove.do?seq=${detail.seq}&pageNum=${param.pageNum }&searchField=${param.searchField }&searchString=${param.searchString }";
    } 
}
function seeMore(e){
    var $target = $(e.currentTarget);
    var $tarGetUl = $target.closest('.comment-view').find('ul');
    var liLength = $tarGetUl.find('li').length;
    
    var seq = ${param.seq};
    $.ajax({
        type: 'get',
        url: 'comment-more-get.do',
        data: {startLine: liLength, seq:seq},
        success: function (data) {
            var text='';
            if( data.length > 0){
                for( var index = 0 ; index < data.length ; index++ ){
                    var li=document.createElement('li');
                    text += 
                        '<li>'+
                            '<div class="comment-contents">'+
                                '<img src="/img/main/people-profile.png"><span class="commont-writer">'+data[index].id+'</span><span class="commont-text">'+data[index].sContent+'</span>'+
                            '</div>'+
                            '<div class="comment-time"><button id="show-child" data-seq="'+data[index].seq+'">답글[ '+data[index].childrenCount+' ]</button> '+data[index].sJoinUpdate+' | <a href="#">신고하기</a></div>'+
                        '</li>';
                }
                $tarGetUl.append(text);
                $('#comment-write-forms #limitEnd').val(liLength+data.length);
            }
        },
        error: function(request, status, error){
            console.log(error);
       }
    });
}


function appendChild(e){
    var $target = $(e.currentTarget);
    var seq = $target.data("seq");
    var $tarGetLi = $target.closest('li');
    var $remoeTarget = $tarGetLi.find('.re-comment');
    var $remoeTarget2 = $tarGetLi.find('.comment-write');
    $.ajax({
        type: 'post',
        url: 're-comment-check.do',
        data: {sGroup: seq},
        success: function (data) {
            
            if($remoeTarget.length>0){
                $remoeTarget.remove();
                $remoeTarget2.remove();
            }else{
                var text='';
                if( data.length > 0){
                    text = '<ul  class="re-comment">';
                    for( var index = 0 ; index < data.length ; index++ ){
                        var li=document.createElement('li');
                        text += 
                            '<li>'+
                            '<div class="comment-contents">'+
                                'L <img src="/img/main/people-profile.png"><span class="commont-writer">'+data[index].id+'</span><span class="commont-text">'+data[index].sContent+'</span>'+
                            '</div>'+
                            '<div class="comment-time"> '+data[index].sJoinUpdate+' | <a href="#">신고하기</a></div>'+
                            '</li>';
                    }
                    text += '</ul>';
                }
                if($remoeTarget2.length>0){
                    $remoeTarget2.remove();
                } else {
                    var limitLength = $('#comment-write-forms #limitEnd').val();
                    text += 
                        '<div class="comment-write">'+
                        '<form action="commentReWrite.do" method="post">'+
                            '<input type="hidden" name="sGroup" value="'+seq+'">'+
                            '<input type="hidden" name="seq" value="${detail.seq }">'+
                            '<input type="hidden" name=limitEnd id="limitEnd" value="'+limitLength+'">'+
                            '<input type="hidden" name="pageNum" value="${param.pageNum }">'+
                            '<input type="hidden" name="searchField" value="${param.searchField }">'+
                            '<input type="hidden" name="searchString" value="${param.searchString }">'+
                            '<textarea rows="3" cols="30" id="commont-text" name="sContent"></textarea>'+
                            '<input type="submit" class="comment-submit" value="등록">'+
                        '</form>'+
                        '</div>'
                }
                
                $tarGetLi.append(text);
            }
        },
        error: function(request, status, error){
            console.log(error);
       }
    });
}
</script>
<!-- footer영역 끝 -->
<!-- 
구지 개별 파일을 src로 넣어도 되지만 include방식을 채택하는 이유는 혹시나 모듈화된 js파일이 추가될 경우 include파일 안에만 추가하면 되기 때문에  
추후 개발의 편의를 위해 분기
-->
<jsp:include page="/WEB-INF/views/include/footer-common.jsp" flush="true"></jsp:include>
<jsp:include page="/WEB-INF/views/include/board/footer-include.jsp" flush="true"></jsp:include>
<jsp:include page="/WEB-INF/views/include/footer.jsp" flush="true"></jsp:include>
<!-- footer영역 끝 -->