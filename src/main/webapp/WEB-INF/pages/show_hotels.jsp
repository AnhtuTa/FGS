<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ page isELIgnored="false" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<c:if test="${not empty hotelList}">
    <jsp:useBean id="fp" class="hello.util.FormatPrice"/>
    <c:forEach items="${hotelList}" var="hotel">
        <div class="hotel_wrapper" id="hotel_wrapper${hotel.id}">
            <div class="hotel_photo">
                <c:choose>
                    <c:when test='${hotel.avatar != null && hotel.avatar != ""}'>
                        <img style="height: 130px;width: 130px;" src="${hotel.avatar}"/>
                    </c:when>
                    <c:otherwise>
                        <img style="height: 130px;width: 130px;" src="/img/no_image.jpg"/>
                    </c:otherwise>
                </c:choose>

            </div>
            <div class="hotel_details">
                <div class="hotel_name">${hotel.name}</div>
                <div class="hotel_star">
                	<c:forEach begin = "1" end = "${hotel.star}">
                    	<span class="fa fa-star checked"></span>
                	</c:forEach>
                </div>
                <div class="hotel_address">
                	<c:if test="${hotel.street != null}">${hotel.street}, </c:if>
                	<c:if test="${hotel.district != null}">${hotel.district}, </c:if>
                	${hotel.city}
                </div>
                <div class="hotel_review">
                    <div class="hotel_point">${hotel.reviewPoint}</div>
                    <div class="total_rate">${hotel.numReviews} reviews</div>
                </div>
                <!-- <hr style="margin: 2px 0;"> -->
                <!-- <div class="hotel_route btn_option" title="Tìm đường từ vị trí của bạn">Chỉ đường</div>
                <div class="hotel_reservation btn_option" title="Đặt phòng luôn!"> Đặt phòng</div> -->
            </div>
            <div class="hotel_price">${fp.formatPrice(hotel.price)} VNĐ</div>
            <div class="hotel_slideout">
                <div id="tab_wrapper${hotel.id}" class="tab_wrapper">
                    <!-- Tab links: số lượng tab link = số lượng tab content -->
                    <div class="tablink_wrapper">
                        <button class="tablink active"><spring:message code="label.hotel.photo" /></button>
                        <button class="tablink"><spring:message code="label.hotel.info" /></button>
                        <button class="tablink"><spring:message code="label.hotel.review" /></button>
                        <%--<button class="tablink"><spring:message code="label.hotel.price" /></button>--%>

                        <div class="btn_close_wrapper" title="<spring:message code="label.title.close" />">
                            <img style="width: 25px;" src="/img/icon_close.png" />
                        </div>
                    </div>

                    <!-- Tab content -->
                    <div class="tabcontent tab-photo" style="display: block;"></div>
                    <div class="tabcontent tab-info"></div>
                    <div class="tabcontent tab-review"></div>
                    <%--<div class="tabcontent tab-price">--%>
                        <%--<h3>Hanoi</h3>--%>
                        <%--<p>Hanoi is the capital of Vietnam.</p>--%>
                    <%--</div>--%>
                </div>
            </div>
        </div>

    </c:forEach>
</c:if>