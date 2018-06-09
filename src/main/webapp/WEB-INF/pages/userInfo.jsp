<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page session="true"%>
<%@page isELIgnored="false" %>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<html>
<head>
	<title><spring:message code="label.link.user_info"/></title>
	<link rel="shortcut icon" href="/img/favicon.png">
	<link rel='stylesheet' href="/css/style.css">
</head>
<body>
<div class="body_wrapper">
	<jsp:include page="_menu.jsp" />
	<h1><spring:message code="msg.hello" /> ${sessionScope.userFullname }</h1>
</div>
</body>
</html>