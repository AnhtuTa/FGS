<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false" %>
<c:set var="ls" value="${sessionScope.localeString}" />
<div style="border: 1px solid #ccc; padding: 5px; margin-bottom: 20px;">
	<a href="${pageContext.request.contextPath}/${ls}/home">Home</a> | &nbsp;
	<a href="${pageContext.request.contextPath}/${ls}/user_info">User Info</a> | &nbsp; 
	<a href="${pageContext.request.contextPath}/${ls}/admin">Admin</a> | &nbsp;

	<c:if test="${pageContext.request.userPrincipal.name == null}">
		<a href="${pageContext.request.contextPath}/${ls}/login">Login</a> | &nbsp;
    	<a href="${pageContext.request.contextPath}/${ls}/register">Register</a> | &nbsp;
	</c:if>
	
	<c:if test="${pageContext.request.userPrincipal.name != null}">
    	<a href="${pageContext.request.contextPath}/logout">Logout</a> | &nbsp;
	</c:if>

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
	<a href="<%=engURI%>"><img class="icon_language" src="/img/en_flag30.png"></a> | &nbsp;
	<a href="<%=vieURI%>"><img class="icon_language" src="/img/vn_flag30.png"></a> | &nbsp;
</div>