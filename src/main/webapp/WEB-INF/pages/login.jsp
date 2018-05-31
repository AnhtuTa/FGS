<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page isELIgnored="false" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<html>
<head>
	<title>Login</title>
    <link rel='stylesheet' href="/css/style.css">
	<style type="text/css">
		.my_error {
			color: red;
		}
	</style>
</head>
<body onload="document.f.username.focus()">
	<jsp:include page="_menu.jsp" />

	<h1><spring:message code="label.login.title" /></h1>

	<!-- /login?error=true -->
	<c:if test="${param.error == 'true'}">
		<div class="my_error">
			Login Failed!!!<br /> Reason :
			${sessionScope.SPRING_SECURITY_LAST_EXCEPTION.message}
			<%-- Hoặc có thể viết: ${sessionScope["SPRING_SECURITY_LAST_EXCEPTION"].message} --%>
		</div>
	</c:if>

	<form name='f'
		action="${pageContext.request.contextPath}/j_spring_security_check"
		method='POST'>
		<table>
			<tr>
				<td><spring:message code="label.username" /></td>
				<td><input type='text' name='username' value=''></td>
			</tr>
			<tr>
				<td><spring:message code="label.password" /></td>
				<td><input type='password' name='password' /></td>
			</tr>
			<tr>
				<td><input name="submit" type="submit" value="<spring:message code="label.login.submit" />" /></td>
			</tr>
		</table>
	</form>
</body>
</html>