<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 상단 헤더 영역 해당은 jsp 구분으로 /로 한다면 root페이지인 webapp 하위를 바라본다!  -->
<jsp:include page="/WEB-INF/views/include/header.jsp" flush="true"></jsp:include>
<jsp:include page="/WEB-INF/views/include/login-need.jsp" flush="true"></jsp:include>
<jsp:include page="/WEB-INF/views/include/board/header-include.jsp" flush="true"></jsp:include>
<jsp:include page="/WEB-INF/views/include/header-common.jsp" flush="true"></jsp:include>
<jsp:include page="/WEB-INF/views/include/main/menu-include.jsp" flush="true"></jsp:include>
<!-- 상단 헤더 영역 끝 -->
<div class="container-sisim">
    <div class="board-upper">
        <select id="show-gride">
            <option value="10" ${showGrid=="10" ? 'selected' : '' }>10개씩보기</option>
            <option value="20" ${showGrid=="20" ? 'selected' : '' }>20개씩보기</option>
            <option value="30" ${showGrid=="30" ? 'selected' : '' }>30개씩보기</option>
        </select>
        <a href="/board/simsim/list.do"><span class="normal-text">심심</span></a>
        <a href="write_view.do" class="button-write" >글쓰기</a>
    </div>
    <div class="board-wrap">
        <ul>
            <c:forEach var="board" items="${boadList }">
                <li ${sessionScope.loginIdCk == board.id || board.id=='admin'  ? 'class="is-my-contents"' :'' }>
                    <div class="thumb-area">
                        <a href="#" title="user-title"><img src="/img/main/people-profile.png" alt="my"></a>
                    </div>
                    <div class="detail-area">
                        <a href="detail.do?seq=${board.seq }&pageNum=${currnetPage}&searchField=${searchField}&searchString=${searchString}" title="user-detail" class="board-title"> ${board.sTitle }<span class="board-repl">[${board.childrenCount }]</span></a>
                        <span class="board-user">${board.id }</span><span class="board-date">${board.sJoindate }</span>
                    </div>
                    <div class="view-area">
                        <span class="board-read-count"><img src="/img/main/show.png"> ${board.readCount }</span><a href="#" class="board-favorite"><img src="/img/main/favorite.png"> 추천(${board.script})</a>
                    </div>
                </li>
            </c:forEach>
        </ul>
    </div>
    <div class="board-bottom">
        <c:if test="${paging.useStartArrow}">
            <a href="list.do?pageNum=${paging.startPage - 1}&searchField=${searchField}&searchString=${searchString}&showGrid=${showGrid}" class="page-before"></a>
        </c:if>
        <c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage }">
            <c:if test="${currnetPage==i }"> 
                <span class="isActive"> ${i } </span> 
            </c:if>
            <c:if test="${currnetPage != i }">
                <a href="list.do?pageNum=${i }&searchField=${searchField}&searchString=${searchString}&showGrid=${showGrid}">[${i }]</a>
            </c:if>
        </c:forEach>
        <c:if test="${paging.useEndArrow}">
            <a href="list.do?pageNum=${paging.endPage + 1}&searchField=${searchField}&searchString=${searchString}&showGrid=${showGrid} "  class="page-after"></a>
        </c:if>
        <a href="write_view.do" class="button-write" >글쓰기</a>
    </div>
    <div class="board-bottom-search">
        <select id="search-field" class="common-select">
            <option value="sTitle" ${searchField=="sTitle" ? 'selected' : '' }>제목</option>
            <option value="sTitleContents" ${searchField=="sTitleContents" ? 'selected' : '' }>제목+내용</option>
            <option value="sWriter" ${searchField=="sWriter" ? 'selected' : '' }>작성자</option>
        </select>
        <input type="text" id="search-text" onkeypress="return runScript(event);" class="common-input-txt" value="${searchString }">
        <input type="button" value="검색" id="search-submit" class="common-button-small">
    </div>
</div>
<script type="text/javascript">
if('undefined' === typeof window.honbabzone) {
    window.honbabzone = {};
}
if('undefined' === typeof window.honbabzone.common) {
    window.honbabzone.common = {};
}
var COMMON_UTILE = window.honbabzone.common;
var $showGride = $('#show-gride');
var $searchSubmit = $('#search-submit');

$showGride.on('change',function(e){
    var $target = $(e.currentTarget);
    location.href='list.do?pageNum=1&searchField=${searchField}&searchString=${searchString}&showGrid='+$target.val();
})
$searchSubmit.on('click',function(e){
    searchFn();
})

function runScript(e){
    if (e.keyCode == 13) {
        searchFn();
    }
}

function searchFn(){
    var $searchField = $('#search-field').val();
    var $searchText = $('#search-text').val();
    location.href='list.do?pageNum=1&searchField='+$searchField+'&searchString='+$searchText+'&showGrid=${showGrid}';
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