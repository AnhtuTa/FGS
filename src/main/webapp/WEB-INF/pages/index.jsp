<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ page isELIgnored="false" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>home</title>
    <link rel="shortcut icon" href="/img/favicon.png">

    <!-- <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css"> -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <link rel='stylesheet' href="/css/style.css">
    <link rel='stylesheet' href="/css/post.css">
    <!-- <link rel='stylesheet' href="/css/hotel_popup.css"> -->
	<link rel="stylesheet" href="/css/popup.css" />
    <link rel='stylesheet' href="/css/home.css">
    <link rel="stylesheet" href="/css/jquery-ui.css">
    
	<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAKzKoLguTtClfCpuh4jjFLmvig9jtPqoY"></script>
	<script type="text/javascript" src="/js/map.js"></script>
    <script type="text/javascript" src="/js/fgs.js"></script>
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

	<script type="text/javascript">
		var mapMap = new Map();		//mapMap thuộc kiểu Map, lưu trữ bản đồ cho từng hotel (mapMap.get(912) = bản đồ của khách sạn ID = 912)
	    var popupMap = new Map();	//lưu các popup của từng hotel
		definePopupClass();

        $(function() {
            $("#slider-range" ).slider({
                range: true,
                min: 0,
                max: 30000000,
                values: [0, 30000000],
                slide: function( event, ui ) {
                    $( "#amount" ).val(addDotsToNumber(ui.values[0]) + "đ - " + addDotsToNumber(ui.values[1]) + "đ");
                }
            });
            $("#amount").val(addDotsToNumber($( "#slider-range" ).slider( "values", 0 )) + "đ - " + addDotsToNumber($( "#slider-range" ).slider( "values", 1 )) + "đ");
        });
	</script>
    <style type="text/css">

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

        <h2>Lấy dữ liệu từ nhiều website và tìm cho bạn kết quả phù hợp nhất</h2>

        <div id="tab_wrapper_hotel_nhatro" class="tab_wrapper">
            <!-- Tab links: số lượng tab link = số lượng tab content -->
            <div class="tablink_wrapper2">
                <button style="border-top-left-radius: 4px;" class="tablink active"><spring:message code="label.hotel" /></button>
                <button style="border-top-right-radius: 4px;" class="tablink"><spring:message code="label.nhatro" /></button>
            </div>

            <!-- Tab content -->
            <div id="tab_hotel" class="tabcontent" style="display: block; padding: 0">
                <div class="form_wrapper">
                    <div class="form_search_label_section"><spring:message code="label.enter_address_or_name" />:</div>
                    <form class="form_search">
                        <input type="text" name="search_type" value="hotel" style="display: none"/>
                        <input type="text" name="search_by" id="search_hotel_by" value="wtf" style="display: none"/>
                        <div class="input_btn_wrapper">
                            <input type="text" class="form_hotel_name" name="input" id="input_hotel_name"
                                   placeholder="<spring:message code='label.example' />: Hà Nội" required autocomplete="off" oninput="getSuggestion(this)">
                            <div class="suggestion_places" id="suggestion_places" style="display: none">
                                <div onclick="showSuggestion(this)" class="suggestion_item">Hà Nội, Việt Nam
                                    <span class="suggestion_item_span">Hotel</span>
                                </div>
                                <div onclick="showSuggestion(this)" class="suggestion_item">Hà Nội, Việt Nam
                                    <span class="suggestion_item_span">Hotel</span>
                                </div>
                            </div>
                            <input type="submit" class="btn_submit" value="<spring:message code="label.search" />">
                        </div>

                        <div class="form_search_label_section"><spring:message code="label.accommodation_type" />:</div>
                        <table>
                            <tr>
                                <td>
                                    <label class="checkbox-container"><spring:message code="label.hotel" />
                                        <input type="checkbox" name="cb_hotel">
                                        <span class="checkmark"></span>
                                    </label>
                                </td>
                                <td>
                                    <label class="checkbox-container"><spring:message code="label.villa" />
                                        <input type="checkbox" name="cb_villa">
                                        <span class="checkmark"></span>
                                    </label>
                                </td>
                                <td>
                                    <label class="checkbox-container"><spring:message code="label.BandB" />
                                        <input type="checkbox" name="cb_BandB">
                                        <span class="checkmark"></span>
                                    </label>
                                </td>
                                <td>
                                    <label class="checkbox-container"><spring:message code="label.apartment" />
                                        <input type="checkbox" name="cb_apartment">
                                        <span class="checkmark"></span>
                                    </label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label class="checkbox-container"><spring:message code="label.resort" />
                                        <input type="checkbox" name="cb_resort">
                                        <span class="checkmark"></span>
                                    </label>
                                </td>
                                <td>
                                    <label class="checkbox-container"><spring:message code="label.homestay" />
                                        <input type="checkbox" name="cb_homestay">
                                        <span class="checkmark"></span>
                                    </label>
                                </td>
                                <td>
                                    <label class="checkbox-container"><spring:message code="label.hostel" />
                                        <input type="checkbox" name="cb_hostel">
                                        <span class="checkmark"></span>
                                    </label>
                                </td>
                                <td></td>
                            </tr>
                        </table>
                        
                        <div class="filter_wrapper">
                            <div class="form_search_label_section"><spring:message code="label.filter" />:</div>
                        	<div class="filter_price all_filters">
                                <div>
                                    <label class="label_price_range" for="amount"><spring:message code="label.price" />:</label>
                                </div>
                                <input class="input_price_range" type="text" id="amount" name="price_range" readonly>

                                <div style="padding-right: 25px;">
                                    <div id="slider-range"></div>
                                </div>
                        	</div>
                            <div class="filter_star all_filters">
                                <div>Star rate</div>
                                <table>
                                    <tr>
                                        <td>
                                            <label class="checkbox-container">1<span class="fa fa-star checked"></span>
                                                <input type="checkbox" name="cb_1star">
                                                <span class="checkmark"></span>
                                            </label>
                                            <label class="checkbox-container">2<span class="fa fa-star checked"></span>
                                                <input type="checkbox" name="cb_2star">
                                                <span class="checkmark"></span>
                                            </label>
                                            <label class="checkbox-container">3<span class="fa fa-star checked"></span>
                                                <input type="checkbox" name="cb_3star">
                                                <span class="checkmark"></span>
                                            </label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <label class="checkbox-container">4<span class="fa fa-star checked"></span>
                                                <input type="checkbox" name="cb_4star">
                                                <span class="checkmark"></span>
                                            </label>
                                            <label class="checkbox-container">5<span class="fa fa-star checked"></span>
                                                <input type="checkbox" name="cb_5star">
                                                <span class="checkmark"></span>
                                            </label>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                            <div class="order_wrapper all_filters">
                            	<select name="order_by">
                            		<option value="price ASC"><spring:message code="label.sort_by_price_asc" /></option>
                            		<option value="price DESC"><spring:message code="label.sort_by_price_desc" /></option>
                            		<option value="review_point DESC"><spring:message code="label.sort_by_review_point" /></option>
                            		<option value="current_position"><spring:message code="label.sort_by_position" /></option>
                            	</select>
                            </div>
                            
                        </div>

                    </form>
                    <div><spring:message code="label.or_search_by_your_location" /></div>
                </div>
            </div>

            <div id="tab_nhatro" class="tabcontent" style="padding: 0">
                <div class="form_wrapper">
                    <div style="margin-bottom: 5px;"><spring:message code="label.select_location_for_rent" />:</div>
                    <form class="form_search" style="padding-right: 77px;position: relative;">
                        <input type="text" name="search_type" value="nhatro" style="display: none">
                        <!-- Nhà trọ thì chỉ tìm theo quận, thành phố hoặc theo location -->
                        <jsp:include page="select_city_district.jsp" />

                        <input style="padding: 8px;top: 30px;right: 0;" type="submit" class="btn_submit" value="<spring:message code="label.search" />">
                    </form>
                    <div><spring:message code="label.or_search_by_your_location" /></div>
                </div>
            </div>
        </div>

		<a target="_blank" href="${pageContext.request.contextPath}/map?location=Hanoi">View map</a>

        <jsp:include page="show_hotels.jsp" />
    </div>
</body>

<script src="/js/home1.js"></script>
<script type="text/javascript">
    var locationString = '<spring:message code="label.location" />';
    var STR_CITY = '<spring:message code="label.city" />';
    var STR_DISTRICT = '<spring:message code="label.district" />';
    var STR_HOTEL = '<spring:message code="label.hotel" />';

<c:if test="${not empty hotelList}">
	<c:forEach items="${hotelList}" var="hotel">
	
		/*========== Show and hide tab when click to hotel's name ==============*/
		var hotel_name${hotel.id} = document.getElementById("hotel_wrapper${hotel.id}").getElementsByClassName("hotel_details")[0].getElementsByClassName("hotel_name")[0];
		var hotel_slideout${hotel.id} = document.getElementById("hotel_wrapper${hotel.id}").getElementsByClassName("hotel_slideout")[0];
		var btn_close${hotel.id} = document.getElementById("tab_wrapper${hotel.id}").getElementsByClassName("btn_close_wrapper")[0];
		
		hotel_name${hotel.id}.addEventListener("click", function() {
			//hiển thị slideout khi click vào thẻ hotel's name
			hotel_slideout${hotel.id}.style.display = "block";
			
			var tabPhoto = document.getElementById("tab_wrapper${hotel.id}").getElementsByClassName("tab-photo")[0];
			
			if(tabPhoto.innerHTML == "") {
				//nếu tabphoto chưa có ảnh thì hiển thị hình ảnh của hotel
				var query = 
				`query {
					  hotel(id: ${hotel.id}) {
				    image_urls
				  }
				}`;
				var xhttp = new XMLHttpRequest();
			    xhttp.onreadystatechange = function() {
			        if (this.readyState == 4 && this.status == 200) {
			            var tabwrapper;
			            
			            showSlide(this.responseText, tabPhoto, ${hotel.id});
			       }
			    };
			    xhttp.open("GET", "/graphql?query=" + escape(query), true);
			    xhttp.setRequestHeader("Content-Type", "application/json; charset=UTF-8");
			    xhttp.send(); 
			}
		});
		btn_close${hotel.id}.addEventListener("click", function() {
			//ẩn slideout khi click vào button close
			hotel_slideout${hotel.id}.style.display = "none";
		});
		
		
		/*========== switch tab content when click to tablink ==============*/
		//VD: tablinks7: các tablink của hotel có id=7
		//vd: tabcontents7: các tabcontent của hotel có id=7
		var tab_wrapper${hotel.id} = document.getElementById("tab_wrapper${hotel.id}");
		var tablinks${hotel.id} = tab_wrapper${hotel.id}.getElementsByClassName("tablink_wrapper")[0].getElementsByClassName("tablink");
		var tabcontents${hotel.id} = tab_wrapper${hotel.id}.getElementsByClassName("tabcontent");
	
		for (var i = 0; i < tablinks${hotel.id}.length; i++) {
			tablinks${hotel.id}[i].addEventListener("click", showTab${hotel.id}.bind({position: i}));	//Trói đít, nhầm, trói this lại bằng bind. Do đó đối tượng this của hàm showTab sẽ chứa vị trí mà tab đc click (truy nhập vào vị trí này = cách: this.position)
		}
	
		//show tab thứ this.position, và active tablink thứ this.position
		function showTab${hotel.id}() {
			//phải chắc chắn rẳng tabcontents và tablinks có cùng size (Hiển nhiên!)
			for (i = 0; i < tabcontents${hotel.id}.length; i++) {
				// Get all elements with class="tabcontent" and hide them
				tabcontents${hotel.id}[i].style.display = "none";
				
				// Get all elements with class="tablinks" and remove the class "active"
				tablinks${hotel.id}[i].className = tablinks${hotel.id}[i].className.replace(" active", "");
			}

			//document.getElementById(cityName).style.display = "block";
			// Show the current tab
			tabcontents${hotel.id}[this.position].style.display = "block";
			
			// add an "active" class to the button that opened the tab
			tablinks${hotel.id}[this.position].className += " active";
			
			switch(this.position) {
			    case 0:
			        //tab này là tab hình ảnh
			        //đã hiển thị ảnh ngay khi click vào tên hotel rồi
			        //do đó đoạn này chả cần làm j cả!
			        break;
			    case 1:
			        //tab này là tab thông tin
			        var tabInfo = tab_wrapper${hotel.id}.getElementsByClassName("tab-info")[0];
			        if(tabInfo.innerHTML == "") {
			        	showHotelMap(${hotel.id}, tabInfo);
			        }
			        break;
				case 2:
			        //tab này là tab review
			        
			        break;
				case 3:
			        //tab này là tab giá
			        
			        break;
			    
			    default:
			        console.log("Default showTab${hotel.id}()");
			}
		}
		
	</c:forEach>
</c:if>
</script>
<script src="/js/home2.js"></script>
<script src="/js/select_city_district.js"></script>
</html>