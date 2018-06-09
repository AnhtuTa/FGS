<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page isELIgnored="false" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<c:set var="ls" value="${sessionScope.localeString}" />
<html>
<head>
	<title><spring:message code="label.register.title"/></title>
	<link rel="shortcut icon" href="/img/favicon.png">
	<link rel='stylesheet' href="/css/style.css">
	<link rel='stylesheet' href="/css/register.css">

</head>
<body onload="document.f.username.focus()">
<div class="body_wrapper">
	<jsp:include page="_menu.jsp" />

	<h1 class="h1_register"><spring:message code="label.register.title" /></h1>
	<c:if test="${requestScope.DUPLICATE_USER_OR_EMAIL != null}">
		<div class="my_error"><spring:message code="err.duplicate_user_or_email" /></div>
	</c:if>
	<c:if test="${requestScope.UNKNOWN_ERROR != null}">
		<div class="my_error"><spring:message code="err.unknown_error" /></div>
	</c:if>
	<form:form name="f" action="${pageContext.request.contextPath}/${ls}/register"
		method="POST" modelAttribute="myUser" cssClass="form_register">
		<table class="table_register">
			<tr>
				<td class="td_label"><spring:message code="label.username" /></td>
				<td class="td_input"><form:input path="username" /></td>
			</tr>
			<tr>
				<td></td>
				<td class="td_error"><form:errors path="username" cssClass="form_error" /></td>
			</tr>
			<tr>
				<td class="td_label"><spring:message code="label.email" /></td>
				<td class="td_input"><form:input path="email" /></td>
			</tr>
			<tr>
				<td></td>
				<td class="td_error"><form:errors path="email" cssClass="form_error" /></td>
			</tr>

			<tr>
				<td class="td_label"><spring:message code="label.password" /></td>
				<td class="td_input"><form:password path="password" /></td>
			</tr>
			<tr>
				<td></td>
				<td class="td_error"><form:errors path="password" cssClass="form_error" /></td>
			</tr>

			<tr>
				<td class="td_label"><spring:message code="label.confirm_password" /></td>
				<td class="td_input"><form:password path="confirmPassword" /></td>
			</tr>
			<tr>
				<td></td>
				<td class="td_error"><c:if test="${requestScope.PASSWORD_DOESNT_MATCH != null}">
						<span class="my_error"><spring:message code="msg.password_doesnt_match" /></span>
					</c:if></td>
			</tr>

			<tr>
				<td class="td_label"><spring:message code="label.fullname" /></td>
				<td class="td_input"><form:input path="fullname" /></td>
			</tr>
			<tr>
				<td></td>
				<td class="td_error"><form:errors path="fullname" cssClass="form_error" /></td>
			</tr>
		</table>
		<input name="submit" class="btn_submit" type="submit" value="<spring:message code="label.register.submit" />" />
	</form:form>
</div>
</body>
</html>