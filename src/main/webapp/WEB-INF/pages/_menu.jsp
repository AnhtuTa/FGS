<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false" %>
<c:set var="ls" value="${sessionScope.localeString}" />

<link href="https://fonts.googleapis.com/css?family=Muli" rel="stylesheet">
	
<div style="border: 1px solid #ccc; padding: 5px; margin-bottom: 20px; text-align: center;">
	<a href="${pageContext.request.contextPath}/${ls}/home">Home</a> &nbsp;|&nbsp;
	<a href="${pageContext.request.contextPath}/${ls}/user_info">User Info</a> &nbsp;|&nbsp; 
	<a href="${pageContext.request.contextPath}/${ls}/admin">Admin</a> &nbsp;|&nbsp;

	<c:if test="${pageContext.request.userPrincipal.name == null}">
		<a href="${pageContext.request.contextPath}/${ls}/login">Login</a> &nbsp;|&nbsp;
    	<a href="${pageContext.request.contextPath}/${ls}/register">Register</a> &nbsp;|&nbsp;
	</c:if>

	<c:if test="${pageContext.request.userPrincipal.name != null}">
    	<a href="${pageContext.request.contextPath}/logout">Logout</a> &nbsp;|&nbsp;
	</c:if>

	<a href="${pageContext.request.contextPath}/${ls}/post" title="Đăng tin thuê nhà">Đăng tin</a> &nbsp;|&nbsp;
	<a href="${pageContext.request.contextPath}/${ls}/forum" title="Cộng đồng đăng tin thuê nhà">Forum</a> &nbsp;|&nbsp;
	<%
		String currentURI = (String) request.getSession().getAttribute("currentURI");
		String engURI, vieURI;
		if(currentURI.startsWith("/vi/") || currentURI.startsWith("/en/")) {
			engURI = "/en/" + currentURI.substring(4);
			vieURI = "/vi/" + currentURI.substring(4);
		} else {
			engURI = "/en" + currentURI;
			vieURI = "/vi" + currentURI;
		}
	%>
	<a href="<%=engURI%>" style="vertical-align: middle;"><img class="icon_language" src="/img/en_flag30.png"></a> &nbsp;|&nbsp;
	<a href="<%=vieURI%>" style="vertical-align: middle;"><img class="icon_language" src="/img/vn_flag30.png"></a> &nbsp;|&nbsp;
</div>