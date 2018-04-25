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
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css">
	<link rel='stylesheet' href="/css/style.css">

	<style type="text/css">
		.error {
			color: red;
		}
		
		h2 {
			text-align: center;
		}
		
		.body_wrapper {
			max-width: 800px;
			margin: auto;
			padding: 10px;
		}
		
		.form_wrapper {
			margin-top: 20px;
		}
		
		.form_search {
			width: 100%;
			display: inline-block;
			text-align: center;
			position: relative;
		}
		
		.form_search .hotel_name {
			width: 94%;
			padding: 6px;
			position: absolute;
			left: 0;
			background: url(/img/search_20.png) no-repeat scroll 5px 7px;
			border: 1px solid #b9b9b9;
			border-radius: 2px;
			padding-left: 30px;
		}
		
		.form_search .btn_submit {
			position: absolute;
			padding: 6px;
			right: 0;
			border-radius: 2px;
			background: #5495ff;
			border: 1px solid #5495ff;
			color: #fff;
			font-weight: bold;
		}
	</style>
</head>
<body>
	<div class="body_wrapper">
		<jsp:include page="_menu.jsp" />
		<c:if test="${not empty USER_MUST_LOGOUT_FIRST}"><div class="error"><spring:message code="err.you_must_logout_first" /></div></c:if>
	
		<h2>Lấy dữ liệu từ nhiều website và tìm cho bạn kết quả phù hợp
			nhất</h2>

		<div class="form_wrapper">
			<div>Tên thành phố, địa điểm hoặc tên khách sạn (Tạm thời có 1 tab tìm ks trước, sau này thêm tab tìm nhà trọ)</div>
			<form class="form_search">
				<input type="text" class="hotel_name" name="hotel_name" placeholder="Ví dụ: Hà Nội" required>
				<input type="submit" class="btn_submit" name="btn_submit"
					value="Tìm">
			</form>
		</div>
		
		<c:if test="${not empty hotelList}">
			<c:forEach items="${hotelList}" var="hotel">
				<div>${hotel.name}</div>
			</c:forEach>
		</c:if>
	</div>
</body>
</html>