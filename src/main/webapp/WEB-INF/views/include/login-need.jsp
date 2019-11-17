<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="com.honbabzone.tomcat.mem.controller.MemberController"%>
<%
String isLogin = (String)session.getAttribute("loginIdCk");
if( isLogin==null || isLogin.equals("") || isLogin.length() ==0 ){
%>
<script>
var text = encodeURI(encodeURIComponent("로그인이 필요합니다."));
location.href="/mem/redirect.do?msg="+text+"&url=/mem/login_view.do";
</script>
<%
}
%>