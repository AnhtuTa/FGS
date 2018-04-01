<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page isELIgnored="false" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<c:set var="ls" value="${sessionScope.localeString}" />
<html>
<head>
	<title>Login</title>
	<style type="text/css">
		.form_error {
			color: red;
		}
		.my_error {
			color: red;
		}
	</style>
</head>
<body onload="document.f.username.focus()">
	<jsp:include page="_menu.jsp" />

	<h1><spring:message code="label.register.title" /></h1>
	<c:if test="${requestScope.DUPLICATE_USER_OR_EMAIL != null}">
		<div class="my_error"><spring:message code="err.duplicate_user_or_email" /></div>
	</c:if>
	<form:form action="${pageContext.request.contextPath}/${ls}/register"
		method="POST" modelAttribute="myUser">
		<table>
			<tr>
				<td><spring:message code="label.username" /></td>
				<td><form:input path="username" />
					<form:errors path="username" cssClass="form_error" /></td>
			</tr>
			<tr>
				<td><spring:message code="label.email" /></td>
				<td><form:input path="email" />
					<form:errors path="email" cssClass="form_error" /></td>
			</tr>
			<tr>
				<td><spring:message code="label.password" /></td>
				<td><form:password path="password" />
					<form:errors path="password" cssClass="form_error" /></td>
			</tr>
			<tr>
				<td><spring:message code="label.fullname" /></td>
				<td><form:input path="fullname" />
					<form:errors path="fullname" cssClass="form_error" /></td>
			</tr>
			
			<tr>
				<td><input name="submit" type="submit" value="<spring:message code="label.register.submit" />" /></td>
			</tr>
		</table>
	</form:form>
</body>
</html>