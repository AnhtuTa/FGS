<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page session="false"%>
<%@page isELIgnored="false"%>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<html>
<head>
<title><spring:message code="label.404.title" /></title>
</head>
<body>
	<jsp:include page="_menu.jsp" />

	<h3 style="color: red;"><spring:message code="msg.page_not_found" /></h3>
	<h3>Nếu mày đang gặp bug thì nên comment cái custom error page này lại, có khi lại thấy bug :v</h3>
</body>
</html>