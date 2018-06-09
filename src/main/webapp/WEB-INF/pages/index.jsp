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
    <script type="text/javascript" src="/js/jquery.js"></script>
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
                values: [
                    <c:if test="${low_price_range != null}">${low_price_range}</c:if><c:if test="${low_price_range == null}">0</c:if>,
                    <c:if test="${high_price_range != null}">${high_price_range}</c:if><c:if test="${high_price_range == null}">30000000</c:if>
                ],
                slide: function( event, ui ) {
                    $( "#amount" ).val(addDotsToNumber(ui.values[0]) + "đ - " + addDotsToNumber(ui.values[1]) + "đ");
                }
            });
            $("#amount").val(addDotsToNumber($( "#slider-range" ).slider( "values", 0 )) + "đ - " + addDotsToNumber($( "#slider-range" ).slider( "values", 1 )) + "đ");
        });

        $(function() {
            $("#slider-range2" ).slider({
                range: true,
                min: 0,
                max: 30000000,
                values: [
                    <c:if test="${low_price_range2 != null}">${low_price_range2}</c:if><c:if test="${low_price_range2 == null}">0</c:if>,
                    <c:if test="${high_price_range2 != null}">${high_price_range2}</c:if><c:if test="${high_price_range2 == null}">30000000</c:if>
                ],
                slide: function( event, ui ) {
                    $( "#amount2" ).val(addDotsToNumber(ui.values[0]) + "đ - " + addDotsToNumber(ui.values[1]) + "đ");
                }
            });
            $("#amount2").val(addDotsToNumber($( "#slider-range2" ).slider( "values", 0 )) + "đ - " + addDotsToNumber($( "#slider-range2" ).slider( "values", 1 )) + "đ");
        });
	</script>
    <style type="text/css">
        .div_view_map {
            margin: 25px 0;
        }
        .a_view_map {
            border: 1px solid;
            padding: 10px;
        }
        .a_view_map:hover {
            text-decoration: none;
            background: #fff;
        }
        .div_warning {
            color: #03A9F4;
            font-weight: bold;
            margin: 10px 0;
        }
        .div_search_by_location {
            margin: 10px 0;
        }
        .review_edit {
            position: absolute;
            top: 9px;
            right: 27px;
            font-size: 18px;
            color: #2196f3;
            cursor: pointer;
        }
        .review_delete {
            position: absolute;
            top: 8px;
            right: 10px;
            font-size: 18px;
            color: red;
            cursor: pointer;
        }
        .btn_cancel_update {
            position: absolute;
            top: 50px;
            left: 685px;
            width: 85px;
            background: red;
            border: 1px solid red;
        }
        .btn_cancel_update:hover {
            background: #d70000;
            border: 1px solid #d70000;
        }
        .form_hotel_name {
            transition: 0.5s;
        }
        .form_hotel_name:disabled {
            opacity: 0.6;
        }
        .load_more_reviews {
            color: #03A9F4;
            text-align: center;
            cursor: pointer;
            margin-bottom: 5px;
        }
        .load_more_reviews:hover {
            text-decoration: underline;
        }
    </style>
</head>

<body>
<noscript>
    <meta http-equiv="refresh" content="0; url=/noJS" />
    <style type="text/css">div {display: none;}</style>
</noscript>
<div class="body_wrapper">
        <jsp:include page="_menu.jsp" />
        <c:if test="${not empty USER_MUST_LOGOUT_FIRST}">
            <div class="error">
                <spring:message code="err.you_must_logout_first" />
            </div>
        </c:if>

        <h2 style="font-size: 30px;font-weight: 500;">Lấy dữ liệu từ nhiều website và tìm cho bạn kết quả phù hợp nhất</h2>

        <div id="tab_wrapper_hotel_nhatro" class="tab_wrapper">
            <!-- Tab links: số lượng tab link = số lượng tab content -->
            <div class="tablink_wrapper2">
                <button style="border-top-left-radius: 4px;" class="tablink<c:if test='${show_tab_nhatro == null}'> active</c:if>"><spring:message code="label.hotel" /></button>
                <button style="border-top-right-radius: 4px;" class="tablink<c:if test='${show_tab_nhatro != null}'> active</c:if>"><spring:message code="label.nhatro" /></button>
            </div>

            <!-- Tab content -->
            <div id="tab_hotel" class="tabcontent" style="<c:if test='${show_tab_nhatro == null}'>display: block;</c:if>padding: 0">
                <div class="form_wrapper">
                    <div class="form_search_label_section"><spring:message code="label.enter_address_or_name" />:</div>
                    <form class="form_search" id="form_search_hotel">
                        <input type="text" name="search_type" value="hotel" style="display: none"/> <%-- Cái này luôn ko đổi --%>
                        <input type="text" name="search_by" id="search_hotel_by" value="${search_by_value}" style="display: none"/>

                        <div class="input_btn_wrapper">
                            <input type="text" class="form_hotel_name" name="input" id="input_hotel_name" value="${input_value}" <c:if test="${cb_search_by_curr_pos_hotel_checked != null}">disabled</c:if>
                                   placeholder="<spring:message code='label.example' />: Hà Nội" required autocomplete="off" oninput="getSuggestion(this)">
                            <div class="suggestion_places" id="suggestion_places" style="display: none">
                                <div onclick="showSuggestion(this)" class="suggestion_item">Hà Nội, Việt Nam
                                    <span class="suggestion_item_span">Hotel</span>
                                </div>
                                <div onclick="showSuggestion(this)" class="suggestion_item">Hà Nội, Việt Nam
                                    <span class="suggestion_item_span">Hotel</span>
                                </div>
                            </div>
                            <input type="submit" <c:if test="${enabled_btn_search == null || enabled_btn_search != 1}">disabled</c:if> class="btn_submit" id="btn_submit_hotel" value="<spring:message code="label.search" />">
                        </div>

                        <div class="div_search_by_location">
                            <label class="checkbox-container">Tìm theo vị trí hiện tại
                                <input type="checkbox" id="cb_search_by_curr_pos_hotel" name="cb_search_by_curr_pos_hotel" <c:if test="${cb_search_by_curr_pos_hotel_checked != null}">checked</c:if> onchange="searchByYourLocation(this, 'hotel')">
                                <span class="checkmark"></span>
                            </label>
                        </div>
                        <div class="div_warning" style="display: none" id="cannot_get_your_location_hotel"></div>
                        <%--
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
                        --%>
                        
                        <div class="filter_wrapper">
                            <div style="margin-bottom: 0;" class="form_search_label_section"><spring:message code="label.filter" />:</div>
                        	<div class="filter_price all_filters">
                                <div class="filter_labels">
                                    <label class="label_price_range" for="amount"><spring:message code="label.price" /></label>
                                </div>
                                <input class="input_price_range" type="text" id="amount" name="price_range" readonly>

                                <div style="padding-right: 25px;">
                                    <div id="slider-range"></div>
                                </div>
                        	</div>
                            <div class="filter_star all_filters">
                                <div class="filter_labels"><spring:message code="label.star_rate" /></div>
                                <table>
                                    <tr>
                                        <td>
                                            <label class="checkbox-container">1<span class="fa fa-star checked"></span>
                                                <input type="checkbox" name="cb_1star" <c:if test="${cb_1star_checked != null}">checked</c:if>>
                                                <span class="checkmark"></span>
                                            </label>
                                            <label class="checkbox-container">2<span class="fa fa-star checked"></span>
                                                <input type="checkbox" name="cb_2star" <c:if test="${cb_2star_checked != null}">checked</c:if>>
                                                <span class="checkmark"></span>
                                            </label>
                                            <label class="checkbox-container">3<span class="fa fa-star checked"></span>
                                                <input type="checkbox" name="cb_3star" <c:if test="${cb_3star_checked != null}">checked</c:if>>
                                                <span class="checkmark"></span>
                                            </label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <label class="checkbox-container">4<span class="fa fa-star checked"></span>
                                                <input type="checkbox" name="cb_4star" <c:if test="${cb_4star_checked != null}">checked</c:if>>
                                                <span class="checkmark"></span>
                                            </label>
                                            <label class="checkbox-container">5<span class="fa fa-star checked"></span>
                                                <input type="checkbox" name="cb_5star" <c:if test="${cb_5star_checked != null}">checked</c:if>>
                                                <span class="checkmark"></span>
                                            </label>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                            <div class="order_wrapper all_filters">
                            	<div class="filter_labels"><spring:message code="label.sort_by" /></div>
                            	<select name="order_by" class="select_sort_by">
                            		<option value="none"><spring:message code="label.sort_by_none" /></option>
                                    <option value="price ASC" <c:if test="${price_asc != null}">selected</c:if>><spring:message code="label.sort_by_price_asc" /></option>
                            		<option value="price DESC" <c:if test="${price_desc != null}">selected</c:if>><spring:message code="label.sort_by_price_desc" /></option>
                            		<option value="review_point DESC" <c:if test="${review_point_desc != null}">selected</c:if>><spring:message code="label.sort_by_review_point" /></option>
                            		<option value="current_position"><spring:message code="label.sort_by_position" /></option>
                            	</select>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <div id="tab_nhatro" class="tabcontent" style="<c:if test='${show_tab_nhatro != null}'>display: block;</c:if>padding: 0">
                <div class="form_wrapper">
                    <div style="margin-bottom: 5px;"><spring:message code="label.select_location_for_rent" />:</div>
                    <form class="form_search" id="form_search_nhatro">
                        <input type="text" name="search_type" value="nhatro" style="display: none">

                        <div class="input_btn_wrapper" style="padding-right: 76px;">
                            <jsp:include page="select_city_district.jsp" />
                            <input style="padding: 8px;top: 30px;right: 0;" type="submit" id="btn_submit_nhatro" class="btn_submit" value="<spring:message code="label.search" />">
                        </div>

                        <div class="div_search_by_location">
                            <label class="checkbox-container">Tìm theo vị trí hiện tại
                                <input type="checkbox" id="cb_search_by_curr_pos_nhatro" name="cb_search_by_curr_pos_nhatro" <c:if test="${cb_search_by_curr_pos_nhatro_checked != null}">checked</c:if> onchange="searchByYourLocation(this, 'nhatro')">
                                <span class="checkmark"></span>
                            </label>
                        </div>
                        <div class="div_warning" style="display: none" id="cannot_get_your_location_nhatro"></div>

                        <div class="filter_wrapper" style="margin-bottom: 22px;">
                            <div style="margin-bottom: 0;" class="form_search_label_section"><spring:message code="label.filter" />:</div>
                            <div class="filter_price all_filters">
                                <div class="filter_labels">
                                    <label class="label_price_range" for="amount"><spring:message code="label.price" /></label>
                                </div>
                                <input class="input_price_range" type="text" id="amount2" name="price_range" readonly>
                                <div style="padding-right: 25px;">
                                    <div id="slider-range2"></div>
                                </div>
                            </div>
                            <div class="order_wrapper all_filters">
                                <div class="filter_labels"><spring:message code="label.sort_by" /></div>
                                <select name="order_by" class="select_sort_by">
                                    <option value="none"><spring:message code="label.sort_by_none" /></option>
                                    <option value="price ASC" <c:if test="${price_asc2 != null}">selected</c:if>><spring:message code="label.sort_by_price_asc" /></option>
                                    <option value="price DESC" <c:if test="${price_desc2 != null}">selected</c:if>><spring:message code="label.sort_by_price_desc" /></option>
                                    <option value="time DESC" <c:if test="${time_desc2 != null}">selected</c:if>><spring:message code="label.sort_by_most_recent" /></option>
                                    <option value="current_position"><spring:message code="label.sort_by_position" /></option>
                                </select>
                            </div>

                        </div>
                    </form>
                </div>
            </div>
        </div>

        <c:if test="${param.search_type == 'hotel'}">  <%--không thể dùng request.search_type hoặc requestScope.search_type hoặc pageContext.request.search_type--%>
		    <div class="div_view_map">
                <a class="a_view_map" target="_blank"
                   href="${pageContext.request.contextPath}/map?search_by=${param.search_by}&input=<c:if test="${param.input != null}">${param.input}</c:if><c:if test="${param.city_found != null}">${param.city_found}</c:if><c:if test="${param.your_lat != null}">&your_lat=${param.your_lat}</c:if><c:if test="${param.your_lng != null}">&your_lng=${param.your_lng}&is_show_your_pos=true</c:if>">
                    <spring:message code="label.view_map" />
                </a>
            </div>
        </c:if>

        <jsp:include page="show_hotels.jsp" />
        <jsp:include page="show_posts.jsp" />

        <c:if test="${paginationLink != null}">
            <div class="page_list">
                <%=request.getAttribute("paginationLink") %>
            </div>
        </c:if>
    </div>
</body>

<script src="/js/home1.js"></script>
<script type="text/javascript">
    //map này key là hotelId, còn value là index của slide của hotel đó
    var slideIndexMap = new Map();

    //map này key là hotelId, còn value là mảng các hình ảnh của slide của hotel đó
    //chú ý: BỎ PHẦN TỬ CUỐI CÙNG CỦA MẢNG ĐÓ, vì nó = ""
    var imageArrayMap = new Map();

    // định nghĩa các hằng số String theo locale
    var localeString = '${sessionScope.localeString}';
    var locationString = '<spring:message code="label.location" />';
    var STR_CITY = '<spring:message code="label.city" />';
    var STR_DISTRICT = '<spring:message code="label.district" />';
    var STR_HOTEL = '<spring:message code="label.hotel" />';
    var STR_NONE = '<spring:message code="label.none" />';
    var STR_VIEW_DETAILS = '<spring:message code="label.view_details" />';
    var STR_HIDE_DETAILS = '<spring:message code="label.hide_details" />';
    var STR_CONTACT_LANDLORD = '<spring:message code="label.contact_to_landlord" />';
    var STR_CONTACT_NAME = '<spring:message code="label.contact_name" />';
    var STR_CONTACT_PHONE = '<spring:message code="label.contact_phone" />';
    var STR_CONTACT_EMAIL = '<spring:message code="label.contact_email" />';
    var STR_CONTACT_ADDRESS = '<spring:message code="label.contact_address" />';
    var STR_UNKNOWN = '<spring:message code="label.unknown" />';
    var STR_LOADING = '<spring:message code="label.loading" />';
    var STR_YOU_MUST_LOGIN_TO_REVIEW = '<spring:message code="label.you_must_login_to_review" />';
    var STR_OTHER_REVIEWS = '<spring:message code="label.other_reviews" />';
    var STR_YOU = '<spring:message code="label.you" />';
    var STR_YOUR_NAME = '${sessionScope.userFullname}';
    var STR_ADD_YOUR_REVIEW = '<spring:message code="label.add_your_review" />';
    var STR_UPDATE_YOUR_REVIEW_LABEL = 'Cập nhập nhận xét của bạn';
    var STR_RATING = '<spring:message code="label.rating" />';
    var STR_COMMENT = '<spring:message code="label.comment" />';
    var STR_POST_YOUR_REVIEW = '<spring:message code="label.post_review" />';
    var STR_UPDATE_YOUR_REVIEW = '<spring:message code="label.update_review" />';
    var STR_THIS_HOTEL_HAS_NOBODY_REVIEW = '<spring:message code="label.this_hotel_has_noone_review" />';
    var STR_THIS_HOTEL_HAS_NOBODY_ELSE_REVIEW = '<spring:message code="label.this_hotel_has_noone_else_review" />';
    var STR_REVIEWS_OF_OTHERS = '<spring:message code="label.reviews_of_others" />';
    var USER_ID = <c:if test="${sessionScope.userId != null}">${sessionScope.userId}</c:if><c:if test="${sessionScope.userId == null}">null</c:if>;

    <c:if test="${not empty hotelList}">
        <c:forEach items="${hotelList}" var="hotel">

            /*========== Show and hide tab when click to hotel's name ==============*/
            var hotel_name${hotel.id} = document.getElementById("hotel_wrapper${hotel.id}").getElementsByClassName("hotel_details")[0].getElementsByClassName("hotel_name")[0];
            var hotel_slideout${hotel.id} = document.getElementById("hotel_wrapper${hotel.id}").getElementsByClassName("hotel_slideout")[0];
            var btn_close${hotel.id} = document.getElementById("tab_wrapper${hotel.id}").getElementsByClassName("btn_close_wrapper")[0];

            hotel_name${hotel.id}.addEventListener("click", function() {
                //hiển thị slideout khi click vào thẻ hotel's name
                //hotel_slideout${hotel.id}.style.display = "block";
                $("#hotel_wrapper${hotel.id} .hotel_slideout").show(300);

                var tabPhoto = document.getElementById("tab_wrapper${hotel.id}").getElementsByClassName("tab-photo")[0];

                if(tabPhoto.innerHTML == "") {
                	tabPhoto.innerHTML = "<div class='label_no_review'>" + STR_LOADING + "</div>";
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

                            var image_urls = JSON.parse(this.responseText).data.hotel.image_urls;
                            tabPhoto.innerHTML = "";
                            showSlide(image_urls, tabPhoto, ${hotel.id});
                       }
                    };
                    xhttp.open("GET", "/graphql?query=" + escape(query), true);
                    xhttp.setRequestHeader("Content-Type", "application/json; charset=UTF-8");
                    xhttp.send();
                }
            });
            btn_close${hotel.id}.addEventListener("click", function() {
                //ẩn slideout khi click vào button close
                //hotel_slideout${hotel.id}.style.display = "none";
                $("#hotel_wrapper${hotel.id} .hotel_slideout").hide(300);
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
                        var tabReview = tab_wrapper${hotel.id}.getElementsByClassName("tab-review")[0];
                        if(tabReview.innerHTML == "") {
                        	tabReview.innerHTML = "<div class='label_no_review'>" + STR_LOADING + "</div>";
                            showHotelReview(${hotel.id}, <c:if test="${sessionScope.userId != null}">${sessionScope.userId}</c:if><c:if test="${sessionScope.userId == null}">null</c:if>, tabReview);
                        }
                        break;

                    default:
                        console.log("Default showTab${hotel.id}()");
                }
            }

        </c:forEach>
    </c:if>

    /**
     *
     * @param type là hotel hoặc nhatro
     */
    function searchByYourLocation(cb, type) {
        if(type != 'hotel' && type != 'nhatro') return;

        console.log(cb.checked);
        if(cb.checked) {
            /*================ Get current location ========================*/
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(function(position) {
                    console.log(position.coords.latitude, position.coords.longitude);
                    var geocoder = new google.maps.Geocoder;
                    var your_lat = position.coords.latitude;
                    var your_lng = position.coords.longitude;
                    var latlng = {
                        lat: your_lat,
                        lng: your_lng
                    };
                    var city = null;
                    geocoder.geocode({'location': latlng}, function(results, status) {
                        if (status === 'OK') {
                            if (results[0]) {
                                var arr = results[0].formatted_address.split(",");
                                console.log("arr = ", arr);
                                city = arr[arr.length-2].trim();
                                console.log("city = " + city);

                                if(city != null) {
                                    //window.location = "/?search_type=" + type + "&search_by=location&city=" + city + "&your_lat=" + your_lat + "&your_lng=" + your_lng;
                                    addInputSearchByLocation(type, your_lat, your_lng, city);
                                }
                            } else {
                                window.alert('No results found');
                            }
                        } else {
                            window.alert('Geocoder failed due to: ' + status);
                        }
                    });
                }, function() {
                    handleLocationError(true, type);
                });
            } else {
                // Browser doesn't support Geolocation
                handleLocationError(false, type);
            }
        } else {
            removeInputSearchByLocation(type);
        }
    }

    function addInputSearchByLocation(type, your_lat, your_lng, city) {
        if(type == 'hotel') {
            document.getElementById("input_hotel_name").value = "";
            document.getElementById("input_hotel_name").disabled = true;
            document.getElementById("btn_submit_hotel").disabled = false;
            document.getElementById("search_hotel_by").value = "location";
        } else if(type == 'nhatro') {
            var spinner_city = document.getElementById("spinner_select_city");
            spinner_city.disabled = true;
            spinner_city.removeAttribute("name");
            var spinner_district = document.getElementById("spinner_select_district");
            spinner_district.disabled = true;
            spinner_district.removeAttribute("name");
            //document.getElementById("search_nhatro_by").value = "location";
        }
        var form_search = document.getElementById("form_search_" + type);

        var inputLat = document.createElement("input");
        inputLat.setAttribute("type", "text");
        inputLat.setAttribute("name", "your_lat");
        inputLat.setAttribute("id", "your_lat_" + type);
        inputLat.setAttribute("value", your_lat + "");
        inputLat.style.display = "none";
        form_search.appendChild(inputLat);

        var inputLng = document.createElement("input");
        inputLng.setAttribute("type", "text");
        inputLng.setAttribute("name", "your_lng");
        inputLng.setAttribute("id", "your_lng_" + type);
        inputLng.setAttribute("value", your_lng + "");
        inputLng.style.display = "none";
        form_search.appendChild(inputLng);

        var inputCityFound = document.createElement("input");
        inputCityFound.setAttribute("type", "text");
        inputCityFound.setAttribute("name", "city_found");
        inputCityFound.setAttribute("id", "city_found_" + type);
        inputCityFound.setAttribute("value", city);
        inputCityFound.style.display = "none";
        form_search.appendChild(inputCityFound);
    }

    function removeInputSearchByLocation(type) {
        if(type == 'hotel') {
            document.getElementById("input_hotel_name").disabled = false;
            document.getElementById("search_hotel_by").value = "";
            document.getElementById("btn_submit_hotel").disabled = true;
        } else if(type == 'nhatro') {
            var spinner_city = document.getElementById("spinner_select_city");
            spinner_city.disabled = false;
            spinner_city.setAttribute("name", "city");
            var spinner_district = document.getElementById("spinner_select_district");
            spinner_district.disabled = false;
            spinner_district.setAttribute("name", "district");
        }

        var your_lat = document.getElementById("your_lat_" + type);
        if(your_lat != null) {
            your_lat.parentNode.removeChild(your_lat);
        }
        var your_lng = document.getElementById("your_lng_" + type);
        if(your_lng != null) {
            your_lng.parentNode.removeChild(your_lng);
        }
        var city_found = document.getElementById("city_found_" + type);
        if(city_found != null) {
            city_found.parentNode.removeChild(city_found);
        }
    }

    // CẦN CHẠY HÀM searchByYourLocation LUÔN NẾU NGƯỜI DÙNG ĐÃ TÍCH VÀO CHECKBOX TÌM THEO VỊ TRÍ,
    // NHƯNG CHƯA HIỆN INPUT YOUR_LAT,LNG VÀ city_found
    if(document.getElementById("cb_search_by_curr_pos_hotel").checked == true) {
        searchByYourLocation(document.getElementById("cb_search_by_curr_pos_hotel"), "hotel");
    }
    if(document.getElementById("cb_search_by_curr_pos_nhatro").checked == true) {
        searchByYourLocation(document.getElementById("cb_search_by_curr_pos_nhatro"), "nhatro");
    }

    function handleLocationError(browserHasGeolocation, type) {
        if(browserHasGeolocation) {
            $("#cannot_get_your_location_" + type).html("Vị trí bị chặn trên trang này, vui lòng cho phép vị trí");    //Error: The Geolocation service failed
        } else {
            $("#cannot_get_your_location_" + type).html("Error: Your browser doesn't support geolocation");
        }
        $("#cannot_get_your_location_" + type).show(400);
        // infoWindow.setPosition(pos);
        // infoWindow.setContent(browserHasGeolocation ?
        //     'Error: The Geolocation service failed.' : 'Error: Your browser doesn\'t support geolocation.');
        // infoWindow.open(map);
    }

</script>
<script src="/js/home2.js"></script>
<script src="/js/select_city_district.js"></script>
<script src="/js/home_post.js"></script>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<script>

    function showHotelReview(hotel_id, user_id, tabReview) {
        if(user_id == null) user_id = -1;

        var query =
            `query {
			review(hotel_id: ` + hotel_id + `, user_id: ` + user_id + `) {
				id
				user_id
				user_name
				hotel_id
				review_point
				comment
				time
			}
			reviews(hotel_id: ` + hotel_id + `, start: 0, nums: 5) {
			    id
				user_id
				user_name
				hotel_id
				review_point
				comment
				time
			}
		}`;
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200) {
                var data = JSON.parse(this.responseText).data;
                var your_review = data.review;
                var reviews = data.reviews;
                tabReview.innerHTML = "";

                if(user_id == -1) {
                    var divYouMustLogin = document.createElement("div");
                    divYouMustLogin.setAttribute("class", "you_must_login");
                    divYouMustLogin.innerHTML = STR_YOU_MUST_LOGIN_TO_REVIEW;
                    tabReview.appendChild(divYouMustLogin);
                } else if(your_review == null) {
                    //hiển thị form review
                    var divYourReview = document.createElement("div");
                    divYourReview.setAttribute("class", "your_review_wrapper");
                    divYourReview.setAttribute("id", "your_review_wrapper_" + hotel_id);

                    createFormReview(divYourReview, tabReview, hotel_id, user_id, false, -1, null, null);
                } else {
                    //hiển thị review của người này
                    var divYourReviewWrapper = document.createElement("div");
                    divYourReviewWrapper.setAttribute("class", "your_review_wrapper");
                    divYourReviewWrapper.setAttribute("id", "your_review_wrapper_" + hotel_id);

                    createReviewItem(divYourReviewWrapper, tabReview, your_review, STR_YOU, hotel_id, user_id, false);
                }

                if(reviews.length == 0) {
                    //hotel này chưa có review nào
                    var divLabelNobodyReviews = document.createElement("div");
                    divLabelNobodyReviews.setAttribute("class", "label_no_review");
                    divLabelNobodyReviews.innerHTML = STR_THIS_HOTEL_HAS_NOBODY_REVIEW;
                    tabReview.appendChild(divLabelNobodyReviews);
                } else if(reviews.length == 1 && reviews[0].user_id == user_id) {
                    //hotel này chưa có ai khác review
                    var divLabelNobodyElseReviews = document.createElement("div");
                    divLabelNobodyElseReviews.setAttribute("class", "label_noone_else_review");
                    divLabelNobodyElseReviews.innerHTML = STR_THIS_HOTEL_HAS_NOBODY_ELSE_REVIEW;
                    tabReview.appendChild(divLabelNobodyElseReviews);
                } else {
                    var divLabelOtherReviews = document.createElement("div");
                    divLabelOtherReviews.setAttribute("class", "label_other_reviews");
                    divLabelOtherReviews.innerHTML = STR_REVIEWS_OF_OTHERS;
                    tabReview.appendChild(divLabelOtherReviews);

                    for(var i=0; i<reviews.length; i++) {
                        if(reviews[i].user_id == user_id) continue;
                        var divReviewItem = document.createElement("div");
                        divReviewItem.setAttribute("class", "review_item");
                        //divReviewItem.setAttribute("data-item", reviews[i].id);

                        createReviewItem(divReviewItem, tabReview, reviews[i], null, hotel_id, null, false);
                    }

                    var divLoadMore = document.createElement("div");
                    divLoadMore.setAttribute("class", "load_more_reviews");
                    divLoadMore.setAttribute("onclick", "loadMoreReviews(this, 5, " + hotel_id + ", " + user_id + ")");
                    divLoadMore.innerHTML = "Tải thêm nhận xét";
                    tabReview.appendChild(divLoadMore);
                }
            }
        }
        xhttp.open("GET", "/graphql?query=" + escape(query), true);
        xhttp.setRequestHeader("Content-Type", "application/json; charset=UTF-8");
        xhttp.send();
    }

    /**
     * Mỗi lần load thì lấy thêm 5 review
     **/
    function loadMoreReviews(divLoadMore, start, hotel_id, user_id) {
        var query =
            `query {
                reviews(hotel_id: ` + hotel_id + `, start: ` + start + `, nums: 5) {
                    id
                    user_id
                    user_name
                    hotel_id
                    review_point
                    comment
                    time
                }
            }`;

        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200) {
                var reviews = JSON.parse(this.responseText).data.reviews;
                console.log(reviews);

                if(reviews.length == 0) {
                    swal({
                        text: "Không còn reviews nào nữa",
                        icon: "warning",
                    });
                } else {
                    var tab_review = divLoadMore.parentNode;
                    tab_review.removeChild(divLoadMore);

                    for(var i=0; i<reviews.length; i++) {
                        if(reviews[i].user_id == user_id) continue;
                        var divReviewItem = document.createElement("div");
                        divReviewItem.setAttribute("class", "review_item");
                        divReviewItem.setAttribute("id", "review_item_" + reviews[i].id);
                        divReviewItem.style.display = 'none';

                        createReviewItem(divReviewItem, tab_review, reviews[i], null, hotel_id, null, false);

                        $("#review_item_" + reviews[i].id).show(300);
                    }

                    var divLoadMore2 = document.createElement("div");
                    divLoadMore2.setAttribute("class", "load_more_reviews");
                    divLoadMore2.setAttribute("onclick", "loadMoreReviews(this, " + (start+5) + ", " + hotel_id + ", " + user_id + ")");
                    divLoadMore2.innerHTML = "Tải thêm nhận xét";
                    tab_review.appendChild(divLoadMore2);
                }
            }
        }
        xhttp.open("GET", "/graphql?query=" + escape(query), true);
        xhttp.setRequestHeader("Content-Type", "application/json; charset=UTF-8");
        xhttp.send();
    }

    function createFormReview(divYourReviewWrapper, tabReview, hotel_id, user_id, is_edit, review_point, comment, formatted_time) {
        var data;
        if(is_edit) {
            data = "<div class='label_add_review'>" + STR_UPDATE_YOUR_REVIEW_LABEL + "</div>\n";
        } else {
            data = "<div class='label_add_review'>" + STR_ADD_YOUR_REVIEW + "</div>\n";
        }
        data = data +
            "<div class='form_review'>\n" +
            "<table class=\"table_review\">\r\n" +
            "	<tr>\r\n" +
            "		<td class=\"review_label\">" + STR_RATING + "</td>\r\n" +
            "		<td>\r\n" +
            "			<select required class=\"select_rating\" name=\"review_point\">\r\n" +
            "				<option value=\"\">Select rating point</option>\r\n";
        for(var i=1; i<=10; i++) {
            if(review_point == i) {
                data += "<option value=\"" + i + "\" selected>" + i + "</option>\r\n";
            } else {
                data += "<option value=\"" + i + "\">" + i + "</option>\r\n";
            }
        }
        data = data +
            "			</select>\r\n" +
            "		</td>\r\n" +
            "	</tr>\r\n" +
            "	<tr>\r\n" +
            "		<td class=\"review_label\">" + STR_COMMENT + "</td>\r\n" +
            "		<td>\r\n" +
            "			<textarea class=\"input_comment\" type=\"text\" name=\"txt_comment\" required>" + (comment == null ? "" : replaceBrWithNewLine(comment)) + "</textarea>\r\n" +
            "		</td>\r\n" +
            "	</tr>\r\n" +
            "</table>\r\n" +
            "<button class=\"btn_submit btn_review\" onclick='submitReview(this, " + hotel_id + ", " + user_id + ", " + (is_edit ? "true" : "false") + ", " + (formatted_time != null ? ("\"" + formatted_time + "\"") : "null") + ")'>" + (is_edit ? STR_UPDATE_YOUR_REVIEW : STR_POST_YOUR_REVIEW) + "</button>\n";
        if(is_edit) {
            data = data + "<button class=\"btn_submit btn_cancel_update\" onclick='cancelUpdate(this, " + hotel_id + ", " + user_id + ", " + review_point + ", \"" + comment + "\", \"" + formatted_time + "\")'>" + "Hủy bỏ" + "</button>\n";
        }
        data += "</div>";
        divYourReviewWrapper.innerHTML = data;
        if(tabReview != null) tabReview.appendChild(divYourReviewWrapper);
    }

    function cancelUpdate(btn, hotel_id, user_id, review_point, comment, formatted_time) {
        var your_review = {
            "review_point": review_point,
            "comment": comment,
            "user_name": STR_YOUR_NAME,
            "time": formatted_time
        };
        showReviewJustAdded(btn, your_review, hotel_id, user_id, true);
    }

    /**
     * Tạo review item
     * @param divReviewItem thẻ wrapper chứa nội dung review. Thẻ này phải có trên trang web rồi
     * @param tabReview Thẻ này là cha của divReviewItem. Xong xuôi thì sẽ cho divReviewItem.appendChild(divReviewItem)
     * Nếu tham số này = null nghĩa là tabReview đã chứa divReviewItem rồi, do đó ko cần appendChild nữa
     * @param review_json nội dung review sẽ chèn vào divReviewItem
     * @param user_name tên người review
     */
    function createReviewItem(divReviewItem, tabReview, review_json, user_name, hotel_id, user_id, is_time_formatted) {
        var divPointWrapper = document.createElement("div");
        divPointWrapper.setAttribute("class", "review_point");
        divPointWrapper.innerHTML = review_json.review_point;
        divReviewItem.appendChild(divPointWrapper);

        var divNameTimeComment = document.createElement("div");
        divNameTimeComment.setAttribute("class", "review_name_time_comment");

        var divNameTimeCommentInner = document.createElement("div");
        divNameTimeCommentInner.setAttribute("class", "review_ntc_inner");

        var divName = document.createElement("div");
        divName.setAttribute("class", "review_name");
        if(user_name == null) divName.innerHTML = review_json.user_name;
        else divName.innerHTML = user_name;
        divNameTimeCommentInner.appendChild(divName);

        var divComment = document.createElement("div");
        divComment.setAttribute("class", "review_comment");
        divComment.innerHTML = review_json.comment;
        divNameTimeCommentInner.appendChild(divComment);

        if(USER_ID != null && user_id == USER_ID) {
            var btnEdit = document.createElement("div");
            btnEdit.setAttribute("class", "review_edit");
            btnEdit.setAttribute("title", "Edit");
            btnEdit.setAttribute("onclick", "editReview(" + hotel_id + ", " + user_id + ")");
            btnEdit.innerHTML = "<i class='fa fa-edit'></i>";
            divNameTimeCommentInner.appendChild(btnEdit);

            var btnDelete = document.createElement("div");
            btnDelete.setAttribute("class", "review_delete");
            btnDelete.setAttribute("title", "Delete");
            btnDelete.setAttribute("onclick", "deleteReview(" + hotel_id + ", " + user_id + ")");
            btnDelete.innerHTML = "<i class='fa fa-trash'></i>";
            divNameTimeCommentInner.appendChild(btnDelete);
        }

        var divTime = document.createElement("div");
        divTime.setAttribute("class", "review_time");
        if(is_time_formatted) {
            divTime.innerHTML = review_json.time;
        } else {
            divTime.innerHTML = formatDate(new Date(review_json.time), localeString);
        }

        divNameTimeComment.appendChild(divNameTimeCommentInner);
        divNameTimeComment.appendChild(divTime);
        divReviewItem.appendChild(divNameTimeComment);

        if(tabReview != null) {
            tabReview.appendChild(divReviewItem);
        }
    }

    /*
    // HÀM SAU KHÔNG BẢO MẬT
    function submitReview(btn, hotel_id, user_id) {
        var form_review = btn.parentNode;
        var select_rating = form_review.getElementsByClassName("select_rating")[0];
        var input_comment = form_review.getElementsByClassName("input_comment")[0];
        var comment = input_comment.value;
        comment = addSlashDoubleQuote(comment);
        comment = replaceNewLineWithBr(comment);
        //console.log("comment = " + comment);

        //Nếu gửi câu query như này thì người A có thể insertReview cho người B, chỉ cần A biết user_id
        //của người B, như vậy là ko bảo mật 1 tý nào!
        var query =
            `mutation {
		  insertReview(input: {
		    user_id: ` + user_id + `
		    hotel_id: ` + hotel_id + `
		    review_point: ` + select_rating.value + `
		    comment: "` + comment + `"
		  }) {
		    status
		    error
		  }
		}`;
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200) {
                var json = JSON.parse(this.responseText);
                var status = json.data.insertReview.status;
                var error = json.data.insertReview.error;
                if(error != null) console.log(error);

                if(status == 'success') {
                    //Hiển thị review người dùng vừa nhập
                    //var your_review_wrapper = btn.parentNode;
                    //your_review_wrapper.innerHTML = "";		//xóa form comment
                    var your_review = {
                        "review_point": select_rating.value,
                        "comment": replaceNewLineWithBr(input_comment.value),
                        "user_name": STR_YOUR_NAME,
                        "time": new Date()
                    };
                    showReviewJustAdded(btn, your_review, hotel_id, user_id);
                }
            }
        };
        xhttp.open("POST", "/graphql", true);
        xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        // console.log(escape(query));
        // console.log("query = " + query);
        xhttp.send("query=" + query);   //ko cần phải escape gì cả!
    }
    */

    function submitReview(btn, hotel_id, user_id, is_update, formatted_time) {
        var form_review = btn.parentNode;
        var select_rating = form_review.getElementsByClassName("select_rating")[0];
        var input_comment = form_review.getElementsByClassName("input_comment")[0];
        if(select_rating.value == "" || input_comment.value == "") {
            swal({
                text: "Please fill up all fields",
                icon: "warning",
            });
            return;
        }
        var comment = input_comment.value.trim();
        comment = addSlashDoubleQuote(comment);
        comment = replaceNewLineWithBr(comment);
        comment = comment.replace(/%/g, "%25");
        console.log("[submitReview()] comment = " + comment)

        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200) {
                var json = JSON.parse(this.responseText);
                //console.log(json);
                var status, error;
                if(is_update) {
                    status = json.data.updateReview.status;
                    error = json.data.updateReview.error;
                } else {
                    status = json.data.insertReview.status;
                    error = json.data.insertReview.error;
                }
                if(error != null) console.log(error);

                if(status == 'success') {
                    //Hiển thị review người dùng vừa nhập
                    var your_review;
                    if(formatted_time != null) {
                        your_review = {
                            "review_point": select_rating.value,
                            "comment": replaceNewLineWithBr(input_comment.value),
                            "user_name": STR_YOUR_NAME,
                            "time": formatted_time
                        };
                        showReviewJustAdded(btn, your_review, hotel_id, user_id, true);
                    } else {
                        your_review = {
                            "review_point": select_rating.value,
                            "comment": replaceNewLineWithBr(input_comment.value),
                            "user_name": STR_YOUR_NAME,
                            "time": new Date()
                        };
                        showReviewJustAdded(btn, your_review, hotel_id, user_id, false);
                    }
                    if(is_update) {
                        swal({
                            title: "Updated!",
                            icon: "success",
                        });
                    }
                }
            }
        };
        if(is_update) {
            xhttp.open("POST", "/graphql/update-review", true);
        } else {
            xhttp.open("POST", "/graphql/insert-review", true);
        }
        xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        xhttp.send("hotel_id=" + hotel_id + "&user_id=" + user_id + "&review_point=" + select_rating.value + "&comment=" + comment);
    }

    async function showReviewJustAdded(btn, your_review, hotel_id, user_id, is_time_formatted) {
        var your_review_wrapper = document.getElementById("your_review_wrapper_" + hotel_id);
        $("#your_review_wrapper_" + hotel_id).hide(300);
        your_review_wrapper.innerHTML = "";		//xóa form comment
        await sleep(350);
        createReviewItem(your_review_wrapper, null, your_review, STR_YOU, hotel_id, user_id, is_time_formatted);
        $("#your_review_wrapper_" + hotel_id).show(300);
    }

    async function editReview(hotel_id, user_id) {
        var your_review_wrapper = document.getElementById("your_review_wrapper_" + hotel_id);
        var review_point = your_review_wrapper.getElementsByClassName("review_point")[0].innerHTML;
        var comment = your_review_wrapper.getElementsByClassName("review_comment")[0].innerHTML;
        var formatted_time = your_review_wrapper.getElementsByClassName("review_time")[0].innerHTML;

        $("#your_review_wrapper_" + hotel_id).hide(300);
        your_review_wrapper.innerHTML = "";		//xóa comment
        await sleep(350);
        createFormReview(your_review_wrapper, null, hotel_id, user_id, true, review_point, comment, formatted_time);
        $("#your_review_wrapper_" + hotel_id).show(300);
    }

    function deleteReview(hotel_id, user_id) {
        swal({
            title: "Are you sure to delete your review",
            icon: "warning",
            buttons: true,
            dangerMode: true,
        }).then((willDelete) => {
            if (willDelete) {
                var xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function() {
                    if (this.readyState == 4 && this.status == 200) {
                        var kq = JSON.parse(this.responseText);
                        //console.log(kq);

                        if(kq.data.deleteReview.status == 'success') {
                            console.log("[deleteReview] ", hotel_id, user_id);
                            afterDeleteReview(hotel_id, user_id);
                        }
                    }
                };
                xhttp.open("POST", "/graphql/delete-review", true);
                xhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                xhttp.send("hotel_id=" + hotel_id + "&user_id=" + user_id);
            }
        });
    }

    async function afterDeleteReview(hotel_id, user_id) {
        console.log("[afterDeleteReview] ", hotel_id, user_id);
        var your_review_wrapper = document.getElementById("your_review_wrapper_" + hotel_id);
        $("#your_review_wrapper_" + hotel_id).hide(300);
        your_review_wrapper.innerHTML = "";		//xóa form comment
        await sleep(350);
        createFormReview(your_review_wrapper, null, hotel_id, user_id, false, -1, null, null);
        $("#your_review_wrapper_" + hotel_id).show(300);
    }

</script>
</html>
