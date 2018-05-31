<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ page isELIgnored="false" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<div class="select_city_wrapper">
    <div class="div_select_city"><spring:message code="label.select_city" /> <span title="<spring:message code="label.this_field_is_required" />" class="span_required">*</span></div>
    <select class="select_city" name="city">
        <c:if test="${not empty provinceList}">
            <c:forEach items="${provinceList}" var="province">
                <option class="option_city" value="${province.id}">${province.name}</option>
            </c:forEach>
        </c:if>
    </select>
</div>

<div class="select_district_wrapper">
    <div class="div_select_district"><spring:message code="label.select_district" /> <span title="<spring:message code="label.this_field_is_required" />" class="span_required">*</span></div>
    <select class="select_district" name="district">
        <c:if test="${not empty districtList}">
            <c:forEach items="${districtList}" var="district">
                <option value="${district.id}">${district.prefix} ${district.name}</option>
            </c:forEach>
        </c:if>
    </select>
</div>
<div style="clear: both"></div>