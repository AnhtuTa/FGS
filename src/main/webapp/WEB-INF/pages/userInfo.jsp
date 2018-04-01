<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page session="true"%>
<%@page isELIgnored="false" %>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<html>
<head>
<title>${title}</title>
</head>
<body>
	<jsp:include page="_menu.jsp" />
	<h1><spring:message code="msg.hello" /> ${sessionScope.userFullname }</h1>
</body>
</html>