<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ page isELIgnored="false" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title><spring:message code="label.js_required" /></title>
    <link rel="shortcut icon" href="/img/favicon.png">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <link rel='stylesheet' href="/css/style.css">
    <style type="text/css">
        .div_no_JS_wrapper {
            text-align: center;
            border: 1px solid;
            width: 400px;
            margin: auto;
        }
        .div_no_JS {
            background: #2196F3;
            padding: 20px;
            color: #fff;
            text-align: left;
        }
        .div_no_JS .a_no_JS {
            font-weight: bold;
            color: #fff;
        }
        .a_btn {
            background: #fff;
            padding: 5px;
        }
        .a_btn:hover {
            text-decoration: none;
            background: #e8e8e8;
        }
    </style>
</head>

<body>
<div class="body_wrapper">
    <jsp:include page="_menu.jsp" />
    <div class="page_wrapper" id="div_parent">
        <div id="div_child" class="div_no_JS_wrapper">
            <h3 style="padding: 10px; margin: 0;"><spring:message code="label.js_required" /></h3>
            <div class="div_no_JS">
                <spring:message code="label.this_page_doesnt_work_without_js" />. <spring:message code="label.here_are_the" />
                <a class="a_no_JS" href="https://www.enable-javascript.com/" target="_blank">
                    <spring:message code="label.instructions_enable_js" /></a>.

                <div style="margin-top: 20px;">
                    <a href="${sessionScope.currentURI}" class="a_btn"><spring:message code="label.reload_page" /></a>
                </div>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    var parent = document.getElementById("div_parent");
    var child = document.getElementById("div_child");
    parent.removeChild(child);
    history.go(-1);
</script>
</body>

</html>