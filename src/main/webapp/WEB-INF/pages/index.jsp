<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ page isELIgnored="false" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>home</title>
	<style type="text/css">
		.error {
			color: red;
		}
	</style>
</head>
<body>
	<jsp:include page="_menu.jsp" />
	<h2>Hello world!</h2>
	<h3>Welcome to finding guesthouse service system!</h3>
	<div>Message from controller: ${message}</div>
	<div>Message from i18n: <spring:message code="msg.hello_world" /> </div>
	<c:if test="${not empty USER_MUST_LOGOUT_FIRST}"><div class="error"><spring:message code="err.you_must_logout_first" /></div></c:if>
</body>
</html>