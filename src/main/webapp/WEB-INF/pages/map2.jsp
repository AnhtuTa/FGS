<%@page import="hello.util.FormatPrice"%>
<%@page import="java.util.List"%>
<%@page import="hello.model.Hotel"%>
<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ page isELIgnored="false" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta name="viewport" content="initial-scale=1.0, user-scalable=no">
	<meta charset="utf-8">
	<title>map</title>
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
	<link rel='stylesheet' href="/css/style.css">
	<link rel="stylesheet" href="/css/info_window.css" />
	<link rel="stylesheet" href="/css/popup.css" />
</head>

<body>
    <jsp:include page="_menu.jsp" />
	<div class="map_wrapper">	<!-- Chú ý: thằng này overflow: hidden -->
		<div id="map"></div>
		<jsp:useBean id="fp" class="hello.util.FormatPrice"/>  
		<c:forEach items="${hotelIdPriceList}" var="htIdPrice">
			<c:if test="${htIdPrice.latitude != null}">
				<div id="hotel${htIdPrice.id}" class="hotel-popup" onclick="clickToPopup(${htIdPrice.id})" title="<spring:message code="label.map.click_for_more_details" />">
					${fp.formatPrice(htIdPrice.price)}đ
				</div>
			</c:if>
		</c:forEach>
	</div>
	
<script type="text/javascript" src="/js/jquery.js"></script>
<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAKzKoLguTtClfCpuh4jjFLmvig9jtPqoY"></script>
<script type="text/javascript" src="/js/map.js"></script>
<script type="text/javascript" src="/js/fgs.js"></script>
<script type="text/javascript">
var map;<c:forEach items="${hotelIdPriceList}" var="htIdPrice"><c:if test="${htIdPrice.latitude != null}">
var popup${htIdPrice.id};</c:if></c:forEach>

var Popup;
var infoWindowContent;
var infoWindow;

function setInfoWindowContent(hotelName, hotelStar, hotelPrice, reviewPoint, numReviews, avatar, hotelAddress) {
    if(avatar == null) avatar = "https://thedaoofdragonball.com/wp-content/uploads/2012/01/gokuism_church_of_goku.jpg";
    if(hotelAddress == null) hotelAddress = "Địa chỉ đang bị rỗng!"
	infoWindowContent =
        '<div class="hotel_wrapper">' +
        '<div class="hotel_name">' + hotelName + '</div>' +
        '<div class="hotel_photo_wrapper">' +
        '<img class="hotel_photo" src="' + avatar + '">' +
        '</div>' +
        '<div class="hotel_star">';

    for (var i = 1; i <= hotelStar; i++) {
        infoWindowContent += '<span class="fa fa-star checked"></span>';
    }

    infoWindowContent += '<div class="hotel_price">' + hotelPrice + '</div>' +
        '</div>' +
        '<div class="hotel_review">' +
        '<div class="hotel_point">' + reviewPoint + '</div>' +
        '<div class="total_rate">' + numReviews + ' rates</div>' +
        '</div>' +
        '<div style="clear: both"></div>' +
        '<!-- <hr style="margin: 2px 0;"> -->' +
        '<div class="hotel_route btn_option"><spring:message code="label.map.route" /></div>' +
        '<div class="hotel_reservation btn_option"><spring:message code="label.map.reservation" /></div>' +
        '</div>';
}

/** Initializes the map and the custom popup. */
function initMap() {
    definePopupClass();

    map = new google.maps.Map(document.getElementById('map'), {
        center: { lat: 21.035419, lng: 105.844087 },
        zoom: 14,
    });
    map.addListener("click", function () {
        if (infoWindow != null) infoWindow.close();
    });

    //========= popup ============//
    <c:forEach items="${hotelIdPriceList}" var="htIdPrice">
    	<c:if test="${htIdPrice.latitude != null}">
			popup${htIdPrice.id} = new Popup(
		        new google.maps.LatLng(${htIdPrice.latitude}, ${htIdPrice.longitude}),
		        document.getElementById("hotel${htIdPrice.id}")
		    );
			popup${htIdPrice.id}.setMap(map);
		</c:if>
	</c:forEach>
	
    //Cần tạo mới đối tượng infoWindow, quên mẹ mất để làm gì :'(, chắc là để ko bị lỗi undefined
    setInfoWindowContent();
    infoWindow = new google.maps.InfoWindow({ content: infoWindowContent });
    infoWindow.setPosition(new google.maps.LatLng(-33.9, 151.1));

}

function clickToPopup(htId) {
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
		if (this.readyState == 4 && this.status == 200) {
			showInfoWindow(this);
		}
	};
    //xhttp.open("GET", "/rest/hotel/" + htId, true);
    xhttp.open("GET", "/graphql?query=%0Aquery%20%7B%0A%20%20hotel(id%3A" + htId + ")%20%7B%0A%20%20%20%20id%0A%20%20%20%20name%0A%20%20%20%20star%0A%20%20%20%20avatar%0A%20%20%20%20street%0A%20%20%20%20district%0A%20%20%20%20city%0A%20%20%20%20latitude%0A%20%20%20%20longitude%0A%20%20%20%20hotel_url%0A%20%20%20%20review_point%0A%20%20%20%20num_reviews%0A%20%20%20%20price%0A%20%20%7D%0A%7D%0A", true);
    xhttp.send();
}

function showInfoWindow(xhttp) {
	var responseString = xhttp.responseText;
	var responseJSON = JSON.parse(responseString);
	var hotel = responseJSON.data.hotel;
	
	//console.log(responseJSON);
	
	var lat = hotel.latitude;
	var lng = hotel.longitude;
	var street = hotel.street;
	var district = hotel.district;
	var city = hotel.city;
	var avatar = hotel.avatar;
	var hotelUrl = hotel.hotel_url;
	var reviewPoint = hotel.review_point;
	var numReviews = hotel.num_reviews;
	var star = hotel.star;
	var name = hotel.name;
	var price = addDotsToNumber(hotel.price) + "đ";
	
	lat = Number(lat);// - 0.0016;
    lng = Number(lng);// + 0.0142;
    //console.log("lat = " + lat, "lng = " + lng);

    setInfoWindowContent(name, star, price, reviewPoint, numReviews, avatar, street + ", " + district + ", " + city);
    
    if (infoWindow != null) infoWindow.close();
    infoWindow = new google.maps.InfoWindow({ content: infoWindowContent });
    infoWindow.setPosition(new google.maps.LatLng(lat, lng));
    
    infoWindow.open(map);
    customizeInfoWindow();
}

function customizeInfoWindow() {
	console.log("customizeInfoWindow()");
    
    // Reference to the DIV that wraps the bottom of infoWindow
    var iwOuter = $('.gm-style-iw');
    
    //Dịch chuyển info window sang bên phải cái hotel popup
    iwOuter.attr('style', function (index, currentvalue) { return currentvalue + 'top: 34px !important; left: 165px !important;' });
    
    //cho thằng cha kích thước = 0, nếu ko nó sẽ đè lên các hotel popup khác
    setTimeout(function() {
    	//Nếu chạy lệnh này luôn thì ko đc, phải chờ 1 tý!
    	iwOuter.parent().attr('style', function (index, currentvalue) { return currentvalue + 'width: 0 !important; heigh: 0 !important;' });
    }, 100);
    
    //CHÚ Ý: thằng ở trên và thằng dưới đây là KHÁC NHAU (1)
    //var iwOuter2 = document.getElementsByClassName("gm-style-iw")[0];
    //console.log(iwOuter2);

    /* Since this div is in a position prior to .gm-div style-iw.
     * We use jQuery and create a iwBackground variable,
     * and took advantage of the existing reference .gm-style-iw for the previous div with .prev().
    */
    var iwBackground = iwOuter.prev();
    //console.log("prev:")
    //console.log(iwBackground);

    // Removes background shadow DIV
    //iwBackground.children(':nth-child(2)').css({ 'display': 'none' });

    // Removes white background DIV
    //iwBackground.children(':nth-child(4)').css({ 'display': 'none' });

    // Remove hình tam giác và bóng của nó
    //iwBackground.children(':nth-child(1)').css({ 'display': 'none' });
    //iwBackground.children(':nth-child(3)').css({ 'display': 'none' });

    //4 lệnh trên tương ứng với 1 lệnh sau:
    iwBackground.css({ 'display': 'none' });
    //Nếu dùng JS thuần:
    //iwBackground['0'].style.display = 'none';
    //do chú ý (1) nên phải dùng iwBackground['0']  mới được!

    // Moves the infoWindow 115px to the right.
    //iwOuter.parent().parent().css({ left: '115px' });

    // Moves the shadow of the arrow 76px to the left margin.
    // ko cần thiết vì nó bị display: none rồi (chắc vậy :v)
    iwBackground.children(':nth-child(1)').attr('style', function (i, s) { return s + 'left: 76px !important;' });

    // Moves the arrow 76px to the left margin.
    // ko cần thiết vì nó bị display: none rồi (chắc vậy :v)
    iwBackground.children(':nth-child(3)').attr('style', function (i, s) { return s + 'left: 76px !important;' });

    // Changes the desired tail shadow color.
    iwBackground.children(':nth-child(3)').find('div').children().css({ 'box-shadow': 'rgba(72, 181, 233, 0.6) 0px 1px 6px', 'z-index': '1' });

    // Reference to the div that groups the close button elements.
    var iwCloseBtn = iwOuter.next();

    // Apply the desired effect to the close button
    //iwCloseBtn.css({ opacity: '1', right: '38px', top: '3px', border: '7px solid #09b511', 'border-radius': '13px', 'box-shadow': '0 0 5px #09b511' });
    iwCloseBtn.css({
    	display: 'none',
    	width: '13px',
        height: '13px',
        overflow: 'hidden',
        position: 'absolute',
        right: '-370px',
        top: '38px',
        cursor: 'pointer',
        opacity: '1'});

    // If the content of infoWindow not exceed the set maximum height, then the gradient is removed.
    if ($('.iw-content').height() < 140) {
        $('.iw-bottom-gradient').css({ display: 'none' });
    }

    // The API automatically applies 0.7 opacity to the button after the mouseout event. This function reverses this event to the desired value.
    iwCloseBtn.mouseover(function () {
        $(this).css({opacity: '1', border: '2px solid #Fff'});
    });
    iwCloseBtn.mouseout(function () {
        $(this).css({opacity: '1', border: '0'});
    });
}

google.maps.event.addDomListener(window, 'load', initMap);
/* setTimeout(function() {
	initMap();
}, 500); */
	
</script>
</body>

</html>