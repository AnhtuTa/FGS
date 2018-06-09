<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ page isELIgnored="false" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<c:if test="${not empty postList}">
    <jsp:useBean id="fp" class="hello.util.FormatPrice"/>
    <c:forEach items="${postList}" var="post">
        <div class="post_wrapper" id="post_wrapper${post.id}">
            <div class="post_avatar">
                <c:choose>
                    <c:when test='${post.avatar != null && post.avatar != ""}'>
                        <img style="height: 130px;width: 130px;" src="${post.avatar}"/>
                    </c:when>
                    <c:otherwise>
                        <img style="height: 130px;width: 130px;" src="/img/no_image.jpg"/>
                    </c:otherwise>
                </c:choose>

            </div>
            <div class="post_info">
                <div class="post_title">${post.name}</div>
                <div class="post_address">${post.street}, ${post.district}, ${post.city}</div>
                <div class="post_area_price">
                    ${post.area} m<sup>2</sup> <span style="color: #2196F3">|</span>
                    <span style="color: red; font-weight: bold">${fp.formatPrice(post.price)} VNĐ/<spring:message code="label.month" /></span>
                </div>
                <%--<div class="post_content">--%>
                    <%--${post.description}--%>
                <%--</div>--%>
                <div class="view_details" onclick="getPostDetails(this, ${post.id})"><spring:message code="label.view_details" /></div>
            </div>
            <div style="clear: both"></div>
            <div class="post_time">
                <c:if test="${sessionScope.localeString == 'en'}">${post.getFormattedTimeUS()}</c:if>
                <c:if test="${sessionScope.localeString == 'vi'}">${post.getFormattedTimeVN()}</c:if>
            </div>
        </div>

    </c:forEach>
</c:if>