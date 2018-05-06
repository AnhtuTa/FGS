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
	<link rel="stylesheet" href="/css/hotel_popup.css" />
</head>

<body>
	<div class="map_wrapper">	<!-- Chú ý: thằng này overflow: hidden -->
		<div id="map"></div>
		<%
			@SuppressWarnings("unchecked")
			Map<Long, Hotel> htMap = (Map<Long, Hotel>) request.getAttribute("hotelMap");
			@SuppressWarnings("unchecked")
			List<Long> htIdList = (List<Long>) request.getAttribute("hotelIdList");
			FormatPrice fp = new FormatPrice();
			
			String hotelName;
			float hotelPrice;
			String lat, lng;
		%>
		
		<%
			for(Long htId : htIdList) {
				%>
				<div id="hotel<%=htId %>" class="hotel-popup" onclick="clickToPopup(this)"
					hotel_name="<%=htMap.get(htId).getName() %>" lat="<%=htMap.get(htId).getLatitude() %>" 
					lng="<%=htMap.get(htId).getLongitude() %>" star="<%=htMap.get(htId).getStar() %>" 
					review_point="<%=htMap.get(htId).getReviewPoint() %>" num_reviews="<%=htMap.get(htId).getNumReviews() %>"  >
					<%=fp.formatPrice(htMap.get(htId).getPrice()) %> VNĐ
				</div>
				<%
			}
		%>
		
	</div>
	
<script type="text/javascript" src="/js/jquery.js"></script>
<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAKzKoLguTtClfCpuh4jjFLmvig9jtPqoY"></script>
<script type="text/javascript">
var map;
<%
	for(Long htId : htIdList) {
		%>
var popup<%=htId %>;
		<%
	}
%>
var Popup;
var infoWindowContent;
var infoWindow;
var isMouseOnInfoWindow;
var currZoom = 12;

function setInfoWindowContent(hotelName, hotelStar, hotelPrice) {
    infoWindowContent =
        '<div class="hotel_wrapper">' +
        '<div class="hotel_name">' + hotelName + '</div>' +
        '<div class="hotel_photo_wrapper">' +
        '<img class="hotel_photo" max-height: 200px;" src="https://thedaoofdragonball.com/wp-content/uploads/2012/01/gokuism_church_of_goku.jpg">' +
        '</div>' +
        '<div class="hotel_star">';

    for (var i = 1; i <= hotelStar; i++) {
        infoWindowContent += '<span class="fa fa-star checked"></span>';
    }

    infoWindowContent += '<div class="hotel_price">' + hotelPrice + '</div>' +
        '</div>' +
        '<div class="hotel_review">' +
        '<div class="hotel_point">8.9</div>' +
        '<div class="total_rate">273 rates</div>' +
        '</div>' +
        '<div style="clear: both"></div>' +
        '<!-- <hr style="margin: 2px 0;"> -->' +
        '<div class="hotel_route btn_option">Chỉ đường</div>' +
        '<div class="hotel_reservation btn_option">Đặt phòng</div>' +
        '</div>';
}

/** Initializes the map and the custom popup. */
function initMap() {
    definePopupClass();

    map = new google.maps.Map(document.getElementById('map'), {
        center: { lat: 21.006419, lng: 105.844087 },
        zoom: 12,
    });
    map.addListener("click", function () {
        if (infoWindow != null) infoWindow.close();
    });
    map.addListener("zoom_changed", function () {
        var arr = document.getElementsByClassName("gm-style-iw");
        if(arr.length == 0) return;     //infoWindow chưa hiện lên

        var infoWindowWrapper = arr[0].parentElement;
        var zoom = map.getZoom();

        console.log(infoWindowWrapper);
        console.log(zoom);
        console.log("offsetLeft = " + infoWindowWrapper.offsetLeft);
        console.log("offsetTop = " + infoWindowWrapper.offsetTop);
        
        //di chuyển infoWindow dựa theo zoom (Nếu chỉ thay đổi thuộc tính left và top thì ko được,
        //bởi vì sau khi scroll map thì 2 thuộc tính trên vẫn như cũ)
        //Ta phải thay đổi vị trí tọa độ của infoWindow
        var pos = infoWindow.getPosition();
        console.log(pos);
        console.log(pos.lat());
        console.log(pos.lng());
        
        //infoWindow.setPosition(new google.maps.LatLng(-33.9, 154.1));

        if(zoom < currZoom) {
            //người dùng vừa thu nhỏ map
            //dịch infoWindow sang phải và xuống dưới
            //infoWindow.setPosition(new google.maps.LatLng(pos.lat() - 0.05, pos.lng() - 1));
            //infoWindow.pixelOffset = new google.maps.Size(200,0);
        } else {
            //người dùng vừa phóng to map
            //dịch infoWindow sang trái và lên trên
            //infoWindow.setPosition(new google.maps.LatLng(pos.lat() + 0.05, pos.lng() + 1));
        }

        currZoom = zoom;
    });
    

    //========= popup ============//
    <%
		for(Long htId : htIdList) {
			lat = htMap.get(htId).getLatitude();
			lng = htMap.get(htId).getLongitude();
			%>
			popup<%=htId %> = new Popup(
		        new google.maps.LatLng(<%=lat %>, <%=lng %>),
		        document.getElementById("hotel<%=htId %>")
		    );
			popup<%=htId %>.setMap(map);
			<%
		}
	%>

    //Cần tạo mới đối tượng infoWindow, quên mẹ mất để làm gì :'(
    setInfoWindowContent("demo", 1, "demo");
    infoWindow = new google.maps.InfoWindow({ content: infoWindowContent });
    infoWindow.setPosition(new google.maps.LatLng(-33.9, 151.1));

}

function clickToPopup(htId) {	  
    var hotelName = element.getAttribute("hotel_name");
    var hotelStar = element.getAttribute("star");
    var hotelPrice = element.innerHTML;
    var lat = element.getAttribute("lat");
    var lng = element.getAttribute("lng");
    var reviewPoint = element.getAttribute("review_point");
    var numReviews = element.getAttribute("num_reviews");
    
    lat = Number(lat) - 0.007;
    lng = Number(lng) + 0.07;
    console.log("lat = " + lat, "lng = " + lng);

    setInfoWindowContent(hotelName, hotelStar, hotelPrice);

    if (infoWindow != null) infoWindow.close();
    infoWindow = new google.maps.InfoWindow({ content: infoWindowContent });
    infoWindow.setPosition(new google.maps.LatLng(lat, lng));
    
    infoWindow.open(map);
    customizeInfoWindow();
}

/** Defines the Popup class. */
function definePopupClass() {
    /**
     * A customized popup on the map.
     * @param {!google.maps.LatLng} position
     * @param {!Element} content
     * @constructor
     * @extends {google.maps.OverlayView}
     */
    Popup = function (position, content) {
        this.position = position;

        content.classList.add('popup-bubble-content');

        var pixelOffset = document.createElement('div');
        pixelOffset.classList.add('popup-bubble-anchor');
        pixelOffset.appendChild(content);

        this.anchor = document.createElement('div');
        this.anchor.classList.add('popup-tip-anchor');
        this.anchor.appendChild(pixelOffset);

        // Optionally stop clicks, etc., from bubbling up to the map.
        this.stopEventPropagation();
    };
    // NOTE: google.maps.OverlayView is only defined once the Maps API has
    // loaded. That is why Popup is defined inside initMap().
    Popup.prototype = Object.create(google.maps.OverlayView.prototype);

    /** Called when the popup is added to the map. */
    Popup.prototype.onAdd = function () {
        this.getPanes().floatPane.appendChild(this.anchor);
    };

    /** Called when the popup is removed from the map. */
    Popup.prototype.onRemove = function () {
        if (this.anchor.parentElement) {
            this.anchor.parentElement.removeChild(this.anchor);
        }
    };

    /** Called when the popup needs to draw itself. */
    Popup.prototype.draw = function () {
        var divPosition = this.getProjection().fromLatLngToDivPixel(this.position);
        // Hide the popup when it is far out of view.
        var display =
            Math.abs(divPosition.x) < 4000 && Math.abs(divPosition.y) < 4000 ?
                'block' :
                'none';

        if (display === 'block') {
            this.anchor.style.left = divPosition.x + 'px';
            this.anchor.style.top = divPosition.y + 'px';
        }
        if (this.anchor.style.display !== display) {
            this.anchor.style.display = display;
        }
    };

    /** Stops clicks/drags from bubbling up to the map. */
    Popup.prototype.stopEventPropagation = function () {
        var anchor = this.anchor;
        anchor.style.cursor = 'auto';

        ['click', 'dblclick', 'contextmenu', 'wheel', 'mousedown', 'touchstart',
            'pointerdown']
            .forEach(function (event) {
                anchor.addEventListener(event, function (e) {
                    e.stopPropagation();
                });
            });
    };
}

function customizeInfoWindow() {
    
    // Reference to the DIV that wraps the bottom of infoWindow
    var iwOuter = $('.gm-style-iw');
    //console.log(iwOuter);

    //CHÚ Ý: thằng ở trên và thằng dưới đây là KHÁC NHAU (1)
    //var iwOuter2 = document.getElementsByClassName("gm-style-iw");
    //console.log(iwOuter2[0]);

    /* Since this div is in a position prior to .gm-div style-iw.
     * We use jQuery and create a iwBackground variable,
     * and took advantage of the existing reference .gm-style-iw for the previous div with .prev().
    */
    var iwBackground = iwOuter.prev();

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
    iwBackground.children(':nth-child(1)').attr('style', function (i, s) { return s + 'left: 76px !important;' });

    // Moves the arrow 76px to the left margin.
    iwBackground.children(':nth-child(3)').attr('style', function (i, s) { return s + 'left: 76px !important;' });

    // Changes the desired tail shadow color.
    iwBackground.children(':nth-child(3)').find('div').children().css({ 'box-shadow': 'rgba(72, 181, 233, 0.6) 0px 1px 6px', 'z-index': '1' });

    // Reference to the div that groups the close button elements.
    var iwCloseBtn = iwOuter.next();

    // Apply the desired effect to the close button
    //iwCloseBtn.css({ opacity: '1', right: '38px', top: '3px', border: '7px solid #09b511', 'border-radius': '13px', 'box-shadow': '0 0 5px #09b511' });
    iwCloseBtn.css({width: '13px',
        height: '13px',
        overflow: 'hidden',
        position: 'absolute',
        right: '47px',
        top: '20px',
        cursor: 'pointer',
        border: '1px solid #Fff',
        opacity: '1'});

    // If the content of infoWindow not exceed the set maximum height, then the gradient is removed.
    if ($('.iw-content').height() < 140) {
        $('.iw-bottom-gradient').css({ display: 'none' });
    }

    // The API automatically applies 0.7 opacity to the button after the mouseout event. This function reverses this event to the desired value.
    iwCloseBtn.mouseover(function () {
        $(this).css({opacity: '1', border: '3px solid #Fff'});
    });
    iwCloseBtn.mouseout(function () {
        $(this).css({opacity: '1', border: '1px solid #Fff'});
    });
}

google.maps.event.addDomListener(window, 'load', initMap);
	
</script>
</body>

</html>