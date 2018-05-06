<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ page isELIgnored="false" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>home</title>
    <!-- <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css"> -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <link rel='stylesheet' href="/css/style.css">
	<link rel='stylesheet' href="/css/font.css">

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
        }

        .form_wrapper {
            margin: 10px 0;
            background: #fff;
    		padding: 10px;
            box-shadow: -1px 1px 3px rgba(41,51,57,.25);
            border-radius: 3px;
        }

        .form_search {
            position: relative;
		    padding-right: 113px;
        }

        .form_search .hotel_name {
            width: 100%;
		    padding: 5px;
		    background: url(/img/search_20.png) no-repeat scroll 5px 4px;
		    border: 1px solid #b9b9b9;
		    border-radius: 2px;
		    padding-left: 30px;
		    font-weight: normal;
        }

        .form_search .btn_submit {
            position: absolute;
		    padding: 6px;
		    top: 0;
		    right: 0;
		    width: 72px;
		    border-radius: 2px;
		    background: #3879d9;
		    border: 1px solid #3879d9;
		    color: #fff;
		    font-weight: bold;
        }
        .form_search .btn_submit:hover {
		    background: #005acc;
        }

        .checked {
            color: orange;
        }

        .hotel_wrapper {
            border-radius: 3px;
            font-family: Arial;
            border: 1px solid #dbdbdb;
            margin-bottom: 5px;
            height: 130px;
            position: relative;
            box-shadow: -1px 1px 3px rgba(41,51,57,.25);
    		background: #fff;
        }

        .hotel_photo {
            text-align: center;
            display: inline-block;
            /*border: 2px solid red;*/
            vertical-align: top;
        }

        .hotel_details {
            width: 50%;
            display: inline-block;
            /*border: 2px solid blue;*/
            padding: 7px;
        }

        .hotel_name {
            font-size: 15px;
            font-weight: bold;
            margin-bottom: 2px;
        }

        .hotel_star {
            font-size: 13px;
            margin-bottom: 2px;
        }

        .hotel_address {
            font-size: 13px;
            margin-bottom: 2px;
        }

        .hotel_review {}

        .hotel_price {
            color: red;
            font-weight: bold;
            font-size: 20px;
            display: inline-block;
            /*border: 2px solid green;*/
            vertical-align: top;
            position: absolute;
            top: 40%;
        }

        .hotel_point {
            background: #09b511;
            color: #fff;
            padding: 7px;
            display: inline-block;
            border-radius: 50%;
            font-size: 13px;
            font-weight: bold;
            margin-top: 13px;
        }

        .total_rate {
            display: inline-block;
        }

        .vl {
            border-left: 1px solid #e3e3e3;
            position: absolute;
            left: 57%;
            margin-left: -3px;
            top: 10px;
            bottom: 10px;
        }

        .btn_option {
            background: #09b511;
            color: #fff;
            padding: 9px;
            border-radius: 5px;
            margin-top: 7px;
            cursor: pointer;
            width: 41%;
            text-align: center;
        }

        .hotel_route {
            float: left;
        }

        .hotel_reservation {
            float: right;
        }

        ::placeholder {
            color: #c1c1c1;
            opacity: 1;
            /* Firefox */
            font-weight: normal;
        }

        :-ms-input-placeholder {
            /* Internet Explorer 10-11 */
            color: #c1c1c1;
            font-weight: normal;
        }

        ::-ms-input-placeholder {
            /* Microsoft Edge */
            color: #c1c1c1;
            font-weight: normal;
        }
    </style>
</head>

<body>
    <div class="body_wrapper">
        <jsp:include page="_menu.jsp" />
        <c:if test="${not empty USER_MUST_LOGOUT_FIRST}">
            <div class="error">
                <spring:message code="err.you_must_logout_first" />
            </div>
        </c:if>

        <h2>Lấy dữ liệu từ nhiều website và tìm cho bạn kết quả phù hợp nhất
        </h2>

        <div class="form_wrapper">
            <div>Tên thành phố, địa điểm hoặc tên khách sạn (Tạm thời có 1 tab tìm ks trước, sau này thêm tab tìm nhà trọ)</div>
            <form class="form_search">
                <input type="text" class="hotel_name" name="hotel_name" placeholder="Ví dụ: Hà Nội" required>
                <input type="submit" class="btn_submit" value="Tìm">
            </form>
        </div>
		<a href="${pageContext.request.contextPath}/map?location=Hanoi">View map</a>
        <c:if test="${not empty hotelList}">
            <jsp:useBean id="fp" class="hello.util.FormatPrice"/>
            <c:forEach items="${hotelList}" var="hotel">
                <div class="hotel_wrapper">
                    <div class="hotel_photo">
                        <img style="max-width: 150px;max-height: 130px;" src="https://thedaoofdragonball.com/wp-content/uploads/2012/01/gokuism_church_of_goku.jpg">
                        <!-- this is photo -->
                    </div>
                    <div class="hotel_details">
                        <div class="hotel_name">${hotel.name}</div>
                        <div class="hotel_star">
                            <span class="fa fa-star checked"></span>
                            <span class="fa fa-star checked"></span>
                            <span class="fa fa-star checked"></span>
                            <span class="fa fa-star checked"></span>
                        </div>
                        <div class="hotel_address">Số 1 Đại Cồ Việt, Hai Bà Trưng, Hà Nội</div>
                        <div class="hotel_review">
                            <div class="hotel_point">${hotel.reviewPoint}</div>
                            <div class="total_rate">${hotel.numReviews} reviews</div>
                        </div>
                        <!-- <hr style="margin: 2px 0;"> -->
                        <!-- <div class="hotel_route btn_option" title="Tìm đường từ vị trí của bạn">Chỉ đường</div>
                        <div class="hotel_reservation btn_option" title="Đặt phòng luôn!"> Đặt phòng</div> -->
                    </div>

                    <div class="hotel_price">${hotel.priceString} VNĐ</div>
                </div>
            </c:forEach>
        </c:if>
    </div>
</body>

</html>