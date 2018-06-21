<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page session="false"%>
<%@page isELIgnored="false"%>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<html>
<head>
	<title><spring:message code="label.404.title" /></title>
	<link rel="shortcut icon" href="/img/favicon.png">
	<link rel='stylesheet' href="/css/style.css">
	<link rel='stylesheet' href="/css/post.css">
	<style>
		.h3_page_not_found {
			color: red;
			text-align: center;
			font-size: 30px;
		}
		.div_return_home {
			text-align: center;
			font-size: 20px;
			margin: 10px 0;
		}
	</style>
</head>
<body>
	<jsp:include page="_menu.jsp" />

	<h3 class="h3_page_not_found"><spring:message code="msg.page_not_found" /></h3>
	<div class="div_return_home">
		<spring:message code="label.click" /> <a href="/home"><spring:message code="label.here" /></a> <spring:message code="label.to_return_home" />
	</div>
	<!-- <h3 style="text-align: center;">Nếu mày đang gặp bug thì nên comment cái custom error page này lại, có khi lại thấy bug :v</h3> -->
</body>
</html>