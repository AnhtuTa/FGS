<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ page isELIgnored="false" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title><spring:message code="label.title.post" /></title>
    <link rel="shortcut icon" href="/img/favicon.png">
    <!-- <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css"> -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <link rel='stylesheet' href="/css/style.css">
    <link rel='stylesheet' href="/css/post.css">
    <style type="text/css">
    	
    </style>
</head>

<body>
<div class="body_wrapper">
    <jsp:include page="_menu.jsp" />
    <h3>Phần post sẽ đăng tin thuê nhà và cả khách sạn nữa. Nhưng do thời gian có hạn nên ko đủ time
    để làm phần đăng tin khách sạn!</h3>
    <form action="" method="POST" enctype="multipart/form-data" id="fileUploadForm">
        <jsp:include page="select_city_district.jsp" />

        <div class="div_street"><spring:message code="label.house_number_and_street" />
            <span title="<spring:message code="label.this_field_is_required" />" class="span_required">*</span>
        </div>
        <input class="input_street" type="text" name="street" placeholder="<spring:message code="label.example" />: 497 Nguyễn Trãi">

        <div class="div_price"><spring:message code="label.price" /> (VNĐ)
            <span title="<spring:message code="label.this_field_is_required" />" class="span_required">*</span>
        </div>
        <input class="input_price" type="text" name="price" placeholder="<spring:message code="label.price_should_be_reasonable" />">

        <div class="div_area"><spring:message code="label.area" /> (m<sup>2</sup>)
            <span title="<spring:message code="label.this_field_is_required" />" class="span_required">*</span>
        </div>
        <input class="input_area" type="text" name="area" placeholder="<spring:message code="label.example" />: 60">

        <%-- <div class="div_writer_name"><spring:message code="label.writer_name" /></div>
        <input class="input_writer_name" style="background: #ebeced;" type="text" value="${sessionScope.userFullname}" disabled> --%>

        <div class="div_post_title"><spring:message code="label.post_title" />
            <span title="<spring:message code="label.this_field_is_required" />" class="span_required">*</span>
        </div>
        <input class="input_post_title" type="text" name="area" placeholder="<spring:message code="label.title_should_be_noteworthy" />">

        <div class="div_post_content"><spring:message code="label.post_content" />
            <span title="<spring:message code="label.this_field_is_required" />" class="span_required">*</span>
        </div>
        <textarea class="text_area_content" rows="10" cols="25" placeholder="<spring:message code="label.introduce_your_hostel" />"></textarea>

        <div class="div_select_photos"><spring:message code="label.select_photos" /></div>
        <div>
            <div id="images_wrapper"></div>
            <button class="btn_upload_file" type="button" onclick="chooseFile();">
                <span class="span_camera fa fa-camera"></span>
                <i class="i_plus">+</i>
            </button>
		    <div id="select_file_wrapper">
		    	<input style="opacity: 0;height: 0;width: 0;" type="file" name="file_upload" id="input_file" accept="image/*" onchange="fire_ajax_submit()"/>
		    </div>
        </div>
        
        <hr class="hr_1"/>
        
        <div class="div_contact_wrapper">
            <div class="contact_me"><spring:message code="label.contact_info" /></div>
            <input class="contact_phone" type="text" name="phone" placeholder="<spring:message code="label.contact_phone" />">
            <input class="contact_email" type="text" name="email" placeholder="<spring:message code="label.contact_email" />">
            <input class="contact_address" type="text" name="address" placeholder="<spring:message code="label.contact_address" />">
        </div>

        <button class="btn" type="submit" id="btnSubmit" value="post"><spring:message code="label.post" /></button>
    </form>
</div>
</body>
<script type="text/javascript">
	var STR_REMOVE_THIS_IMAGE = '<spring:message code="label.title.remove_this_image" />';

</script>
<script src="/js/select_city_district.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/js/post.js"></script>
</html>