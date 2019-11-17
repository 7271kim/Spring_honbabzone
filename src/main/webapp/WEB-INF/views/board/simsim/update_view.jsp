<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 상단 헤더 영역 해당은 jsp 구분으로 /로 한다면 root페이지인 webapp 하위를 바라본다!  -->
<jsp:include page="/WEB-INF/views/include/header.jsp" flush="true"></jsp:include>
<jsp:include page="/WEB-INF/views/include/login-need.jsp" flush="true"></jsp:include>
<jsp:include page="/WEB-INF/views/include/board/header-include.jsp" flush="true"></jsp:include>
<jsp:include page="/WEB-INF/views/include/board/board-editor.jsp" flush="true"></jsp:include>
<jsp:include page="/WEB-INF/views/include/header-common.jsp" flush="true"></jsp:include>
<jsp:include page="/WEB-INF/views/include/main/menu-include.jsp" flush="true"></jsp:include>
<!-- 상단 헤더 영역 끝 -->
<div class="container-sisim-write">
    <form action="update.do" method="post" enctype="multipart/form-data" id="write-form">
        <input type="hidden" name="sContent" id="sContent" />
        <input type="hidden" name="seqThis"  id="seqThis" value="${detail.seq }" />
        <input type="hidden" name="pageNum"  id="pageNum" value="${pageNum }" />
        <input type="hidden" name="searchField"  id="searchField" value="${searchField }" />
        <input type="hidden" name="searchString"  id="searchString" value="${searchString }" />
        
        <ul class="write-wrap">
            <li>
                <label for="first_name" class="label">제목을 입력하세요!</label>
                <input id="first_name" type="text" class="text-field" name="sTitle" value="${detail.sTitle }">
            </li>
            <!-- 파일첨부 -->
            <!-- multiple="multiple"를 사용하는 경우 여러개를 동시에 넣을 수 있다. -->
            <li>
                <div id="uploader" class="tui-file-uploader">
                    <input multiple="multiple" type="file" name="userfile[]" class="tui-input-file-real hide">
                    <div class="tui-file-uploader-header">
                        <span class="tui-file-upload-msg">파일을 첨부하세요</span>
                        <div class="tui-btn-area">
                            <button type="button" class="tui-btn tui-btn-cancel tui-is-disabled">Remove</button>
                            <label class="tui-btn tui-btn-upload">
                                <span class="tui-btn-txt">Add files</span>
                                <input multiple="multiple" type="file" name="tempFiles[]" class="tui-input-file">
                            </label>
                        </div>
                    </div>
                    <div class="tui-js-file-uploader-list hide tui-js-file-uploader-dropzone tui-file-uploader-area tui-has-scroll">
                        <div class="tui-dropzone-contents">
                            <span class="tui-dropzone-msg">Drop files here.</span>
                        </div>
                        <table class="tui-file-uploader-tbl">
                            <caption><span>File Uploader List</span></caption>
                            <colgroup><col width="0"><col width="0"><col width="0">
                            </colgroup>
                            <thead class="tui-form-header">
                                <tr>
                                    <th scope="col" width="0" style="border-right: 0px;">
                                        <div class="tui-checkbox">
                                            <span class="tui-ico-check">
                                                <input type="checkbox">
                                            </span>
                                        </div>
                                    </th>
                                    <th scope="col" width="0">File Name</th>
                                    <th scope="col" width="0" style="border-right: 0px;">File Size</th>
                                </tr>
                            </thead>
                            <tbody class="tui-form-body tui-js-file-uploader-list-items"></tbody>
                        </table>
                    </div>
                    <div class="tui-file-uploader-info">
                        <span class="tui-info-txt">Selected <em class="tui-spec"><span id="checkedItemCount">0</span> files</em> (<span id="checkedItemSize">0 KB</span>)</span>
                        <span class="tui-info-txt">Total <span id="itemTotalSize">0 KB</span></span>
                    </div>
                </div>
            </li>
            <!-- 파일첨부 -->
            <li>
                <div><div id="editSection" data-content="${detail.sContent }"></div></div>
            </li>
        </ul>
        <input type="button" value="수정하기" class="btn-from-sbmit" />
    </form>
</div>
<!-- footer영역 끝 -->
<jsp:include page="/WEB-INF/views/include/footer-common.jsp" flush="true"></jsp:include>
<jsp:include page="/WEB-INF/views/include/board/footer-include.jsp" flush="true"></jsp:include>
<jsp:include page="/WEB-INF/views/include/footer.jsp" flush="true"></jsp:include>
<!-- footer영역 끝 -->