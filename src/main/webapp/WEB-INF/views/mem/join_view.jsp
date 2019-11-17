<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- 상단 헤더 영역 해당은 jsp 구분으로 /로 한다면 root페이지인 webapp 하위를 바라본다!  -->
<jsp:include page="/WEB-INF/views/include/header.jsp" flush="true"></jsp:include>
<!-- 로그인이 필요한 경우  login-need 적용, 로그인이 되어있음 안되는 경우 login-no-need-->
<jsp:include page="/WEB-INF/views/include/login-no-need.jsp" flush="true"></jsp:include>
<jsp:include page="/WEB-INF/views/include/mem/header-include.jsp" flush="true"></jsp:include>
<jsp:include page="/WEB-INF/views/include/header-common.jsp" flush="true"></jsp:include>
<!-- 상단 헤더 영역 끝 -->
<div class="contents-container">
     <div class="contents-join">
        <!-- onsubmit 이슈 : 안에 button이 하나라도 있으면 submit함수가 실행되는 이슈가 존재 버튼을 사용하고 싶을 시 type="button"을 적어주거나 input 타입 중 botton을 사용    -->
        <!-- form 접근성 관련 http://nuli.navercorp.com/sharing/blog/post/1132737 -->
        <form id="join-form" name="join-form" autocomplete="off" action="join.do" method="post" onsubmit="return loginSubmit();">
            <input type="hidden" name="hpnumber" id="hpnumber">
            <input type="hidden" name="address" id="address">
            <!-- 꼭 전체 소문자로 해야 bean에서 잘 받는다 -->
            
            <div class="logo"><h2 class="logo-label">회원가입</h2></div>
            <div class="input_row" id="id_area">
                <h3 class='join-title'><label for="id">아이디</label></h3>
                <span class="input_box">
                    <!-- label은 감출꺼임 스크린리더기는 일반적으로 form컨트롤에 진입하면 기본은 label을 읽는다 만약 label이없으면 title이나 aria-label을 읽는다 -->
                    <!-- aria-describedby 해당 id=err_empty_id에 해당하는 곳을 읽어줌 accesskey : alt + I로 바로 접근 가능하다. -->
                    <input type="text" id="id" name="id" aria-describedby="err_empty_id" accesskey="I" placeholder="아이디" maxlength="41" value="" class="init">
                </span>
                <div id="err_empty_id" class="error" role="alert">아이디를 입력해주세요.</div>
                <div id="err_empty_id_etc" class="error" role="alert"></div>
            </div>
            <div class="input_row" id="name_area">
                <h3 class='join-title'><label for="name">이름</label></h3>
                <span class="input_box">
                    <input type="text" id="name" name="name" aria-describedby="err_empty_name" placeholder="이름" maxlength="41" value="" class="init">
                </span>
                <div id="err_empty_name" class="error" role="alert">이름을 입력해주세요</div>
            </div>
            <div class="input_row" id="gender_area">
                <h3 class='join-title'><label id="gender-title">성별</label></h3>
                <!-- aria-labelledby은 해당 id를 찾아읽음 -->
                <div role="radiogroup" aria-labelledby="gender-title" class="radio-group">
                    <span class="input_box">
                        <label for="man"><input type="radio" id="man" name="gender" value="man" title="남자" checked="checked" ><span class="radio-btn"></span>남자</label>
                        <label for="woman"><input type="radio" id="woman" name="gender" value="woman" title="여자"><span class="radio-btn"></span>여자</label>
                    </span>
                </div>
            </div>
            <div class="input_row" id="pw_area">
                <h3 class='join-title'><label for="pw">비밀번호</label></h3>
                <span class="input_box">
                    <input type="password" id="pw" name="pw" aria-describedby="err_empty_pw" placeholder="비밀번호" maxlength="16" class="init">
                </span>
                <div class="ly_v2" id="err_capslock">
                    <p role="alert"><strong>Caps Lock</strong>이 켜져 있습니다.</p>
                </div>
                <div class="error" role="alert" id="err_empty_pw">비밀번호를 입력해주세요.</div>
                <div id="err_empty_pw_etc" class="error" role="alert"></div>
            </div>
            <div class="input_row" id="pw_check_area">
                 <h3 class='join-title'><label for="pw_ck">비밀번호확인</label></h3>
                <span class="input_box">
                    <label for="pw_ck" id="label_pw_check_area" class="label blind">비밀번호확인</label>
                    <input type="password" id="pw_ck" name="pw_ck" aria-describedby="err_empty_pw_ck" placeholder="비밀번호확인" maxlength="16" class="init">
                </span>
                <div class="ly_v2" id="err_capslock_ck">
                    <p role="alert"><strong>Caps Lock</strong>이 켜져 있습니다.</p>
                </div>
                <div class="error" role="alert" id="err_empty_pw_ck">비밀번호를 입력해주세요.</div>
                <div id="err_empty_pw_check_etc" class="error" role="alert"></div>
            </div>
            <div class="input_row" id="email_area">
                <h3 class='join-title'><label for="email">이메일</label></h3>
                <span class="input_box">
                    <label for="email" id="label_email_area" class="label blind">E-mail</label>
                    <input type="email" id="email" name="email" aria-describedby="err_email" placeholder="이메일을 입력해주세요" class="init">
                </span>
                <div class="error" role="alert" id="err_email">이메일을 양식에 맞게 입력해주세요.</div>
                <div id="err_empty_email_etc" class="error" role="alert"></div>
            </div>
            <div class="input_row" id="adress_area" role="group" aria-labelledby="address-group">
                <h3 class='join-title' id="address-group">주소입력
                    <input type="button" name="postcodify_search_button" id="postcodify_search_button" title="주소검색" value="검색">
                </h3>
                <span class="input_box">
                    <label for="postcode5">우편번호</label>
                    <input type="text" id= "postcode5" name="postcode5" class="postcodify_postcode5 init" value="" />
                </span>
                <span class="input_box">
                    <label for="address-first">주소</label>
                    <input type="text" name="address-first" id="address-first" class="postcodify_address init" value="" />
                </span>
                <span class="input_box">
                     <label for="address-detail">상세주소</label>
                     <input type="text" name="address-detail" id="address-detail" class="postcodify_details init" value="" />
                </span>
                <span class="input_box">
                    <label for="address-extra">기타주소</label>
                    <input type="text" name="address-extra" id="address-extra" class="postcodify_extra_info init" value="" />
                </span>
            </div>
            <div class="input_row" id="phone_area">
                <h3 class="join-title"><label for="phone-first">핸드폰 번호</label></h3>
                <div class="input_box country_code">
                    <select id="nationNo" name="nationNo" class="sel" aria-label="전화번호 입력">
                        <option value="233"> 가나 +233 </option>
                        <option value="241"> 가봉 +241 </option>
                        <option value="592"> 가이아나 +592 </option>
                        <option value="220"> 감비아 +220 </option>
                        <option value="502"> 과테말라 +502 </option>
                        <option value="1671"> 괌 +1 671 </option>
                        <option value="1473"> 그레나다 +1 473 </option>
                        <option value="30"> 그리스 +30 </option>
                        <option value="224"> 기니 +224 </option>
                        <option value="245"> 기니비사우 +245 </option>
                        <option value="264"> 나미비아 +264 </option>
                        <option value="674"> 나우루 +674 </option>
                        <option value="234"> 나이지리아 +234 </option>
                        <option value="672"> 남극,오스트레일리아의외 +672 </option>
                        <option value="27"> 남아프리카공화국 +27 </option>
                        <option value="31"> 네덜란드 +31 </option>
                        <option value="599"> 네덜란드령보네르 +599 </option>
                        <option value="297"> 네덜란드령아루바 +297 </option>
                        <option value="977"> 네팔 +977 </option>
                        <option value="47"> 노르웨이 +47 </option>
                        <option value="64"> 뉴질랜드 +64 </option>
                        <option value="683"> 뉴질랜드령니우에 +683 </option>
                        <option value="690"> 뉴질랜드령토켈라우제도 +690 </option>
                        <option value="227"> 니제르 +227 </option>
                        <option value="505"> 니카라과 +505 </option>
                        <option value="82" selected> 대한민국 +82 </option>
                        <option value="45"> 덴마크 +45 </option>
                        <option value="299"> 덴마크령그린란드 +299 </option>
                        <option value="298"> 덴마크령페로제도 +298 </option>
                        <option value="1809"> 도미니카공화국 +1 809 </option>
                        <option value="1829"> 도미니카공화국 2 +1 829 </option>
                        <option value="1849"> 도미니카공화국 3 +1 849 </option>
                        <option value="49"> 독일 +49 </option>
                        <option value="670"> 동티모르 +670 </option>
                        <option value="856"> 라오스 +856 </option>
                        <option value="231"> 라이베리아 +231 </option>
                        <option value="371"> 라트비아 +371 </option>
                        <option value="7"> 러시아/카자흐스탄 +7 </option>
                        <option value="961"> 레바논 +961 </option>
                        <option value="266"> 레소토 +266 </option>
                        <option value="40"> 루마니아 +40 </option>
                        <option value="352"> 룩셈부르크 +352 </option>
                        <option value="250"> 르완다 +250 </option>
                        <option value="218"> 리비아 +218 </option>
                        <option value="370"> 리투아니아 +370 </option>
                        <option value="423"> 리히텐슈타인 +423 </option>
                        <option value="261"> 마다가스카르 +261 </option>
                        <option value="692"> 마셜제도공화국 +692 </option>
                        <option value="691"> 마이크로네시아연방 +691 </option>
                        <option value="853"> 마카오 +853 </option>
                        <option value="389"> 마케도니아공화국 +389 </option>
                        <option value="265"> 말라위 +265 </option>
                        <option value="60"> 말레이시아 +60 </option>
                        <option value="223"> 말리 +223 </option>
                        <option value="52"> 멕시코 +52 </option>
                        <option value="377"> 모나코 +377 </option>
                        <option value="212"> 모로코 +212 </option>
                        <option value="230"> 모리셔스 +230 </option>
                        <option value="222"> 모리타니아 +222 </option>
                        <option value="258"> 모잠비크 +258 </option>
                        <option value="382"> 몬테네그로 +382 </option>
                        <option value="373"> 몰도바 +373 </option>
                        <option value="960"> 몰디브 +960 </option>
                        <option value="356"> 몰타 +356 </option>
                        <option value="976"> 몽골 +976 </option>
                        <option value="1"> 미국/캐나다 +1 </option>
                        <option value="1670"> 미국령북마리아나제도 +1 670 </option>
                        <option value="95"> 미얀마 +95 </option>
                        <option value="678"> 바누아투 +678 </option>
                        <option value="973"> 바레인 +973 </option>
                        <option value="1246"> 바베이도스 +1 246 </option>
                        <option value="1242"> 바하마 +1 242 </option>
                        <option value="880"> 방글라데시 +880 </option>
                        <option value="229"> 베냉 +229 </option>
                        <option value="58"> 베네수엘라 +58 </option>
                        <option value="84"> 베트남 +84 </option>
                        <option value="32"> 벨기에 +32 </option>
                        <option value="375"> 벨라루스 +375 </option>
                        <option value="501"> 벨리즈 +501 </option>
                        <option value="387"> 보스니아헤르체고비나 +387 </option>
                        <option value="267"> 보츠와나 +267 </option>
                        <option value="591"> 볼리비아 +591 </option>
                        <option value="257"> 부룬디 +257 </option>
                        <option value="226"> 부르키나파소 +226 </option>
                        <option value="975"> 부탄 +975 </option>
                        <option value="359"> 불가리아 +359 </option>
                        <option value="55"> 브라질 +55 </option>
                        <option value="673"> 브루나이 +673 </option>
                        <option value="685"> 사모아 +685 </option>
                        <option value="966"> 사우디아라비아 +966 </option>
                        <option value="378"> 산마리노 +378 </option>
                        <option value="239"> 상투메프린시페 +239 </option>
                        <option value="221"> 세네갈 +221 </option>
                        <option value="381"> 세르비아 +381 </option>
                        <option value="248"> 세이셀 +248 </option>
                        <option value="1784"> 세인트빈센트그레나딘 +1 784 </option>
                        <option value="252"> 소말리아 +252 </option>
                        <option value="677"> 솔로몬제도 +677 </option>
                        <option value="249"> 수단 +249 </option>
                        <option value="597"> 수리남 +597 </option>
                        <option value="94"> 스리랑카 +94 </option>
                        <option value="268"> 스와질랜드 +268 </option>
                        <option value="46"> 스웨덴 +46 </option>
                        <option value="41"> 스위스 +41 </option>
                        <option value="34"> 스페인 +34 </option>
                        <option value="421"> 슬로바키아 +421 </option>
                        <option value="386"> 슬로베니아 +386 </option>
                        <option value="963"> 시리아 +963 </option>
                        <option value="232"> 시에라리온 +232 </option>
                        <option value="65"> 싱가포르 +65 </option>
                        <option value="971"> 아랍에미리트 +971 </option>
                        <option value="374"> 아르메니아 +374 </option>
                        <option value="54"> 아르헨티나 +54 </option>
                        <option value="1684"> 아메리칸사모아 +1 684 </option>
                        <option value="354"> 아이슬란드 +354 </option>
                        <option value="509"> 아이티 +509 </option>
                        <option value="353"> 아일랜드 +353 </option>
                        <option value="994"> 아제르바이잔 +994 </option>
                        <option value="93"> 아프가니스탄 +93 </option>
                        <option value="376"> 안도라 +376 </option>
                        <option value="355"> 알바니아 +355 </option>
                        <option value="213"> 알제리 +213 </option>
                        <option value="244"> 앙골라 +244 </option>
                        <option value="251"> 에디오피아 +251 </option>
                        <option value="291"> 에리트레아 +291 </option>
                        <option value="372"> 에스토니아 +372 </option>
                        <option value="593"> 에콰도르 +593 </option>
                        <option value="503"> 엘살바도르 +503 </option>
                        <option value="44"> 영국 +44 </option>
                        <option value="290"> 영국령세인트헬레나 +290 </option>
                        <option value="246"> 영국령인도양지역 +246 </option>
                        <option value="350"> 영국령지브롤터 +350 </option>
                        <option value="500"> 영국령포클랜드제도 +500 </option>
                        <option value="967"> 예멘 +967 </option>
                        <option value="968"> 오만 +968 </option>
                        <option value="43"> 오스트리아 +43 </option>
                        <option value="504"> 온두라스 +504 </option>
                        <option value="962"> 요르단 +962 </option>
                        <option value="256"> 우간다 +256 </option>
                        <option value="598"> 우루과이 +598 </option>
                        <option value="998"> 우즈베키스탄 +998 </option>
                        <option value="380"> 우크라이나 +380 </option>
                        <option value="964"> 이라크 +964 </option>
                        <option value="98"> 이란 +98 </option>
                        <option value="972"> 이스라엘 +972 </option>
                        <option value="20"> 이집트 +20 </option>
                        <option value="39"> 이탈리아 +39 </option>
                        <option value="91"> 인도 +91 </option>
                        <option value="62"> 인도네시아 +62 </option>
                        <option value="81"> 일본 +81 </option>
                        <option value="1876"> 자메이카 +1 876 </option>
                        <option value="260"> 잠비아 +260 </option>
                        <option value="240"> 적도기니 +240 </option>
                        <option value="995"> 조지아 +995 </option>
                        <option value="86"> 중국 +86 </option>
                        <option value="236"> 중앙아프리카공화국 +236 </option>
                        <option value="253"> 지부티 +253 </option>
                        <option value="263"> 짐바브웨 +263 </option>
                        <option value="235"> 차드 +235 </option>
                        <option value="420"> 체코 +420 </option>
                        <option value="56"> 칠레 +56 </option>
                        <option value="237"> 카메룬 +237 </option>
                        <option value="238"> 카보베르데 +238 </option>
                        <option value="974"> 카타르 +974 </option>
                        <option value="855"> 캄보디아왕국 +855 </option>
                        <option value="254"> 케냐 +254 </option>
                        <option value="269"> 코모로,마요트 +269 </option>
                        <option value="506"> 코스타리카 +506 </option>
                        <option value="225"> 코트디부아르 +225 </option>
                        <option value="57"> 콜롬비아 +57 </option>
                        <option value="242"> 콩고 +242 </option>
                        <option value="243"> 콩고민주공화국 +243 </option>
                        <option value="53"> 쿠바 +53 </option>
                        <option value="965"> 쿠웨이트 +965 </option>
                        <option value="682"> 쿡제도 +682 </option>
                        <option value="385"> 크로아티아 +385 </option>
                        <option value="996"> 키르기스스탄 +996 </option>
                        <option value="686"> 키리바시 +686 </option>
                        <option value="357"> 키프로스 +357 </option>
                        <option value="886"> 타이완 +886 </option>
                        <option value="992"> 타지키스탄 +992 </option>
                        <option value="255"> 탄자니아 +255 </option>
                        <option value="66"> 태국 +66 </option>
                        <option value="90"> 터키 +90 </option>
                        <option value="228"> 토고 +228 </option>
                        <option value="676"> 통가 +676 </option>
                        <option value="993"> 투르크메니스탄 +993 </option>
                        <option value="216"> 튀니지 +216 </option>
                        <option value="1868"> 트리니다드토바고 +1 868 </option>
                        <option value="507"> 파나마 +507 </option>
                        <option value="595"> 파라과이 +595 </option>
                        <option value="92"> 파키스탄 +92 </option>
                        <option value="675"> 파푸아뉴기니 +675 </option>
                        <option value="680"> 팔라우 +680 </option>
                        <option value="970"> 팔레스타인 +970 </option>
                        <option value="51"> 페루 +51 </option>
                        <option value="351"> 포르투갈 +351 </option>
                        <option value="48"> 폴란드 +48 </option>
                        <option value="1787"> 푸에르토리코 +1 787 </option>
                        <option value="33"> 프랑스 +33 </option>
                        <option value="590"> 프랑스령과들루프 +590 </option>
                        <option value="594"> 프랑스령기아나 +594 </option>
                        <option value="687"> 프랑스령뉴칼레도니아 +687 </option>
                        <option value="262"> 프랑스령레위니옹 +262 </option>
                        <option value="596"> 프랑스령마르티니크 +596 </option>
                        <option value="508"> 프랑스령생피에르미클롱 +508 </option>
                        <option value="681"> 프랑스령월리스푸투나제 +681 </option>
                        <option value="689"> 프랑스령폴리네시아 +689 </option>
                        <option value="679"> 피지 +679 </option>
                        <option value="358"> 핀란드 +358 </option>
                        <option value="63"> 필리핀 +63 </option>
                        <option value="36"> 헝가리 +36 </option>
                        <option value="61"> 호주 +61 </option>
                        <option value="852"> 홍콩 +852 </option>
                    </select>
                    </div>
                <div class="phone-wrap">
                    <div class="first">
                        <span class="input_box">
                            <select id="phone-first" name="phone-first" aria-label="폰 첫재 자리" class="sel">
                                <option value="0010" selected>010</option> 
                                <option value="0011">011</option> 
                                <option value="0016">016</option> 
                                <option value="0017">017</option> 
                                <option value="0018">018</option> 
                                <option value="0019">019</option> 
                            </select>
                        </span>
                    </div>
                    <div class="second">
                        <span class="input_box">
                            <input type="text" id="phone-second" placeholder="0000" aria-label="폰 줄쨰자리" maxlength="4" class="init">
                        </span>
                    </div>
                    <div class="third">
                        <span class="input_box">
                            <input type="text" id="phone-third" placeholder="0000" aria-label="폰 마지막자리" maxlength="4" class="init">
                        </span>
                    </div>
                </div>
                <div class="error" role="alert" id="err_phone">폰 번호를 정확히 입력하세요</div>
            </div>
            <div class="input_row" id="chek_area">
                <span class="input_box">
                    <label for="agree-info">
                        <!-- 포커스 요서에 포커스 빼기 tabindex="-1" => 스페이스 바로 선택이 안됨 -->
                        <input type="checkbox" id="agree-info" name="agree-info" aria-describedby="err_empty_chek" class="focus-move">
                        <!-- 포커스 없는 요소에 포커스  tabindex="0"-->
                        <span class="check-btn" ></span>개인정보제공 동의[필수]
                    </label>
                </span>
                <div id="err_empty_chek" class="error" role="alert">개인정보제공에 동의하셔야 합니다.</div>
            </div>
            <div class="input_row" id="marketing_area">
                <span class="input_box">
                    <label for ="agree-use">
                        <input type="checkbox" id="agree-use" name="agree-use" title="마케팅 수신 동의" class="focus-move">
                        <span class="check-btn"></span>마케팅 수신 동의[선택]
                    </label>
                </span>
            </div>
            <div class="input_row" id="submit_area">
                <span class="input_box">
                    <label for="login-submit" id="label_submit_area" class="label blind">회원가입</label>
                    <input type="submit" id="login-submit" title="join" name="login-submit" class="submit float-left j-button" value="회원가입" >
                    <a href="login_view.do" class="j-button">로그인</a>
                </span>
            </div>
        </form>
    </div>
</div>
<script src="/js/mem/address-api.js"></script>
<script type="text/javascript">
$("#postcodify_search_button").postcodifyPopUp();

if('undefined' === typeof window.honbabzone) {
    window.honbabzone = {};
}
if('undefined' === typeof window.honbabzone.common) {
    window.honbabzone.common = {};
}
var COMMON_UTILE = window.honbabzone.common;

//opener관련 오류가 발생하는 경우 아래 주석을 해지하고, 사용자의 도메인정보를 입력합니다. ("팝업API 호출 소스"도 동일하게 적용시켜야 합니다.)
//document.domain = "abc.go.kr";
var $id = $("#id");
var $pw = $("#pw");
var $name = $("#name");
var $pw_ck = $("#pw_ck");
var $email = $("#email");
var $nationNo = $("#nationNo");
var $phoneFirst = $("#phone-first");
var $phoneSecond = $("#phone-second");
var $phoneThird = $("#phone-third");
var $agreeInfo = $("#agree-info");
var $postcode5 = $("#postcode5");
var $addressFirst = $("#address-first");
var $addressDetail = $("#address-detail");
var $addressExtra = $("#address-extra");

var $errId = $("#err_empty_id");
var $errIdEtc = $("#err_empty_id_etc");
var $errPw = $("#err_empty_pw");
var $errPwEtc = $("#err_empty_pw_etc");
var $errPwCk = $("#err_empty_pw_ck");
var $errPwCkEtc = $("#err_empty_pw_check_etc");
var $errName = $("#err_empty_name");
var $errEmail = $("#err_email");
var $errEmailEtc = $("#err_empty_email_etc");
var $errPhone = $("#err_phone");
var $errEmpty = $("#err_empty_chek");

var idFlag = false;
var pwFlag = false;
var emailFlag = false;
var phoneFlag = false;
var agreeFlag = false;

$(document).ready(function() {
    $('.contents-join').on( 'blur', '#id', checkId );
    $('.contents-join').on( 'blur', '#pw', checkPw );
    $('.contents-join').on( 'blur', '#pw_ck', checkPwCk );
    $('.contents-join').on( 'blur', '#email', checkEmail );
    $('.contents-join').on( 'blur', '#phone-first, #phone-second, #phone-third', checkPhone );
    $('.contents-join').on( 'blur', '#agree-info', checkAgree );
    
    // 체크박스 포커스 관련
    $('.contents-join').on( 'focus', '.focus-move', function(e){
        var $target = $(e.currentTarget);
        $target.next().addClass('focus');
    }).on('blur','.focus-move',function(e){
        var $target = $(e.currentTarget);
        $target.next().removeClass('focus');
    });
});

function checkId (e){
    idFlag = false;
    var $target = e.currentTarget != undefined ? $(e.currentTarget) : e;
    var value = $target.val();
    var isID = /^[a-z0-9][a-z0-9_\-]{4,19}$/;
    var mgs = '';
    COMMON_UTILE.hide([$errId,$errIdEtc]);
    
    if(value == ''){
        COMMON_UTILE.show($errId);
        return false;
    }
    if( !isID.test(value) ){
        mgs = '5~20자의 영문 소문자, 숫자와 특수기호(_),(-)만 사용 가능합니다.';
        COMMON_UTILE.errShow($errIdEtc,mgs);
        return false;
    }
    
    $.ajax({
        type: 'post',
        dataType: 'text',
        url: 'id-check.do',
        data: {id: value},
        success: function (data) {
            if( data != 'ok' ) {
            	mgs = data;
                COMMON_UTILE.errShow($errIdEtc,mgs);
                //return false;
            }
        }
    });
    
    idFlag = true;
    return true;
}

function checkPw (e){
    pwFlag = false;
    var cnt =0;
    var $target = e.currentTarget != undefined ? $(e.currentTarget) : e;
    var value = $target.val();
    var mgs = '';
    
    COMMON_UTILE.hide([$errPw ,$errPwEtc ]);
    
    if(value == ''){
        COMMON_UTILE.show($errPw);
        return false;
    }
    
    /* 공백 확인 */
    if ( value.search(/\s/) > -1 ) {
        mgs = '스페이스바 사용은 불가능 합니다.';
        COMMON_UTILE.errShow($errPwEtc ,mgs);
        return false;
    }
    
    /* length확인 */
    if ( value.length < 8 ) {
        mgs = '비밀번호는 8글자 이상입니다.';
        COMMON_UTILE.errShow($errPwEtc ,mgs);
        return false;
    }
    
    /* length확인 */
    if ( value.length < 8 ) {
        mgs = '비밀번호는 8글자 이상입니다.';
        COMMON_UTILE.errShow($errPwEtc ,mgs);
        return false;
    }
    
    /* 반복된 글자 불가. */
    for( var i = 0; i < value.length; ++i) {
        if (value.charAt(0) == value.substring(i, i + 1))
            ++cnt;
    }
    if (cnt == value.length) {
        mgs = '중복된 글자의 비번은 불가능 합니다.';
        COMMON_UTILE.errShow($errPwEtc ,mgs);
        return false;
    }
    
    var isPW = /^[A-Za-z0-9`\-=\\\[\];',\./~!@#\$%\^&\*\(\)_\+|\{\}:"<>\?]{8,16}$/;
    if (!isPW.test(value)) {
        mgs = '영문 숫자 조합의 특수기호를 사용한 8글자 - 16글자 이하의 비번이여야 합니다';
        COMMON_UTILE.errShow($errPwEtc ,mgs);
        return false;
    }

    
    pwFlag = true;
    return true;
}

function checkPwCk (e){
    pwFlag = false;
    
    var $target = e.currentTarget != undefined ? $(e.currentTarget) : e;
    var value = $target.val();
    var mgs = '';
    COMMON_UTILE.hide([$errPwCk, $errPwCkEtc]);
    if(value == ''){
        COMMON_UTILE.show($errPwCk);
        return false;
    }
    if(value != $pw.val()){
        mgs = '비번이 서로 다릅니다.';
        COMMON_UTILE.errShow($errPwCkEtc  ,mgs);
        return false;
    }
    pwFlag = true;
    return true;
}

function checkEmail (e){
    emailFlag = false;
    
    var $target = e.currentTarget != undefined ? $(e.currentTarget) : e;
    var value = $target.val();
    var isEmail = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    var isHan = /[ㄱ-ㅎ가-힣]/g;
    var mgs = '';
    COMMON_UTILE.hide([$errEmail , $errEmailEtc ]);
    
    if(value == ''){
        COMMON_UTILE.show($errEmail);
        return false;
    }
    
    if (!isEmail.test(value) || isHan.test(value)) {
        mgs="이메일 주소를 확인하세요";
        COMMON_UTILE.errShow($errEmailEtc, mgs);
        return false;
    }
    
    $.ajax({
        type: 'post',
        dataType: 'text',
        url: 'email-check.do',
        data: {email: value},
        success: function (data) {
            if( data != 'ok' ) {
                mgs = data;
                COMMON_UTILE.errShow($errEmailEtc,mgs);
                return false;
            }
        }
    });
    
    
    emailFlag = true;
    return true;
}

function checkPhone (e){
    phoneFlag = false;
    
    var $target = e.currentTarget != undefined ? $(e.currentTarget) : e;
    var value = $target.val();
    var isNumber = /^[0-9]{3,4}$/;
    var mgs = '';
    COMMON_UTILE.hide([ $errPhone ]);
    
    if(value == ''){
        mgs="번호를 입력하세요";
        COMMON_UTILE.errShow($errPhone, mgs);
        return false;
    }
    
    if ( !isNumber.test(value) ) {
        mgs="핸드폰 번호 양식을 확인하세요";
        COMMON_UTILE.errShow($errPhone, mgs);
        return false;
    }
    
    phoneFlag = true;
    
    return true;
}

function checkAgree (e){
    agreeFlag = false;
    
    var $target = e.currentTarget != undefined ? $(e.currentTarget) : e;
    var isChecked = $target.is(':checked');
    var msg;
    COMMON_UTILE.hide([ $errEmpty ]);
    if(!isChecked){
        mgs="필수정보는 동의하셔야 합니다.";
        COMMON_UTILE.errShow($errEmpty , mgs);
        return false;
    }
    
    
    agreeFlag = true;
    return true;
}


function loginSubmit() {
    COMMON_UTILE.hide([$errId,$errIdEtc,$errPw,$errPwEtc,$errPwCk,$errPwCkEtc,$errName,$errEmail,$errEmailEtc,$errPhone,$errEmpty]);
    if( !idFlag || !pwFlag || !emailFlag || !phoneFlag || !agreeFlag ){
        checkId($id);
        checkPw($pw);
        checkPwCk($pw_ck);
        checkEmail($email);
        checkPhone($phoneFirst);
        checkPhone($phoneSecond);
        checkPhone($phoneThird);
        checkAgree($agreeInfo );
        return false;
    }
    
    $('#hpnumber').val($nationNo.val()+' '+$phoneFirst.val()+$phoneSecond.val()+$phoneThird.val());
    $('#address').val($postcode5.val() +' '+$addressFirst.val() + ' '+$addressDetail.val() + ' ' + $addressExtra.val());
    
    return true;
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