<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page isELIgnored="false" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<html>
<head>
	<title><spring:message code="label.link.login"/></title>
	<link rel="shortcut icon" href="/img/favicon.png">
	<link rel='stylesheet' href="/css/style.css">
	<link rel='stylesheet' href="/css/register.css">
	<style type="text/css">
		.table_register td {
			padding-bottom: 10px;
		}
	</style>
</head>
<body onload="document.f.username.focus()">
<div class="body_wrapper">
	<jsp:include page="_menu.jsp" />

	<h1 class="h1_register"><spring:message code="label.login.title" /></h1>

	<!-- /login?error=true -->
	<c:if test="${param.error == 'true'}">
		<div class="my_error">
			<c:if test="${sessionScope.SPRING_SECURITY_LAST_EXCEPTION.message.contains('Username or password is incorrect')}">
				<spring:message code="err.login_fail" /><br />
				<spring:message code="err.username_or_pass_incorrect" />
			</c:if>
			<c:if test="${!sessionScope.SPRING_SECURITY_LAST_EXCEPTION.message.contains('Username or password is incorrect')}">
				${sessionScope.SPRING_SECURITY_LAST_EXCEPTION.message}
			</c:if>
			<%--${sessionScope.SPRING_SECURITY_LAST_EXCEPTION.message}--%>
			<%-- Hoặc có thể viết: ${sessionScope["SPRING_SECURITY_LAST_EXCEPTION"].message} --%>

			<%
				session.removeAttribute("SPRING_SECURITY_LAST_EXCEPTION");	//Xóa nó đi, nếu ko người dùng truy cập vào URL http://localhost:8080/login?error=true thì cứ thấy lỗi, mặc dù chả có lỗi gì
			%>
		</div>
	</c:if>

	<form name='f' class="form_register"
		action="${pageContext.request.contextPath}/j_spring_security_check"
		method='POST'>
		<table class="table_register">
			<tr>
				<td class="td_label"><spring:message code="label.username" /></td>
				<td class="td_input"><input type='text' name='username' value=''></td>
			</tr>
			<tr>
				<td class="td_label"><spring:message code="label.password" /></td>
				<td class="td_input"><input type='password' name='password' /></td>
			</tr>
		</table>
		<input name="submit" class="btn_submit" type="submit" value="<spring:message code="label.login.submit" />" />
	</form>
</div>
</body>
</html>