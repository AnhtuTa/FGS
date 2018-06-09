<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ page isELIgnored="false" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<div class="select_city_wrapper">
    <div class="div_select_city"><spring:message code="label.select_city" /> <span title="<spring:message code="label.this_field_is_required" />" class="span_required">*</span></div>
    <select id="spinner_select_city" class="select_city" name="city" <c:if test="${disable_spinner_city != null}">disabled</c:if>>
        <c:if test="${not empty provinceList}">
            <c:forEach items="${provinceList}" var="province">
                <option class="option_city" value="${province.id}" <c:if test="${selected_city_id == province.id}">selected</c:if>>${province.name}</option>
            </c:forEach>
        </c:if>
    </select>
</div>

<div class="select_district_wrapper">
    <div class="div_select_district"><spring:message code="label.select_district" />
        <c:if test="${requireSelectDistrict != null}">
            <span title="<spring:message code="label.this_field_is_required" />" class="span_required">*</span>
        </c:if>
    </div>
    <select id="spinner_select_district" class="select_district" name="district" <c:if test="${requireSelectDistrict != null}">required</c:if> <c:if test="${disable_spinner_district != null}">disabled</c:if>>
        <c:if test="${not empty districtList}">
            <option value=""><spring:message code="label.none" /></option>
            <c:forEach items="${districtList}" var="district">
                <option value="${district.id}" <c:if test="${selected_district_id == district.id}">selected</c:if>>${district.prefix} ${district.name}</option>
            </c:forEach>
        </c:if>
    </select>
</div>
<div style="clear: both"></div>