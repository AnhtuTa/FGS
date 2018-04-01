<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page session="false"%>
<%@page isELIgnored="false"%>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<html>
<head>
<title><spring:message code="msg.access_denied" /></title>
</head>
<body>
	<jsp:include page="_menu.jsp" />

	<h3 style="color: red;"><spring:message code="msg.you_dont_have_permission" /></h3>
</body>
</html>