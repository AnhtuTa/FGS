
/**
 * hiển thị slide hình ảnh của khách sạn
 * @param jsonString: chứa url của các ảnh
 * @param tabPhoto: thẻ cần hiển thị slide
 * @param hotelId: id của khách sạn cần hiển thị slide
 **/
function showSlide(jsonString, tabPhoto, hotelId) {
	//console.log("[showSlide] jsonString = " + jsonString);
    var json = JSON.parse(jsonString);
    if(json.data.hotel.image_urls == "") {
    	var data = '<div class="slide_wrapper" id="slide_wrapper' + hotelId + '">';
	    data += '<img class="my_slides" src="/img/no_image.jpg">';
	    data += "</div>"
	    tabPhoto.innerHTML = data;
    } else {
	    var imageUrls = json.data.hotel.image_urls.split("|");
	
	    //console.log(imageUrls);
	    var data = '<div class="slide_wrapper" id="slide_wrapper' + hotelId + '">';
	    data += '<button class="btn-previous btn-prev-next" onclick="plusDivs(-1, ' + hotelId + ')">&#10094;</button>';
	    data += '<button class="btn-next btn-prev-next" onclick="plusDivs(1, ' + hotelId + ')">&#10095;</button>';
	    data += '<img class="my_slides" src="' + imageUrls[0] + '">';
	    data += "</div>"
	    tabPhoto.innerHTML = data;
	    slideIndexMap.set(hotelId, 0);
	    imageArrayMap.set(hotelId, imageUrls);
    }
}

function plusDivs(k, hotelId) {
    slideIndexMap.set(hotelId, slideIndexMap.get(hotelId) + k);
    showImages(hotelId);
}

/*========== hàm hiển thị ảnh thứ k hotel trên slide, với k = slideIndexMap.get(hotelId) =============*/
function showImages(hotelId) {
    var i;
    var mySlides = document.getElementById("slide_wrapper" + hotelId).getElementsByClassName("my_slides")[0];

    /*======= NHỚ BỎ PHẦN TỬ CUỐI CÙNG CỦA MẢNG imageArrayMap.get(hotelId) ===========*/
    if (slideIndexMap.get(hotelId) > imageArrayMap.get(hotelId).length - 2) {
        slideIndexMap.set(hotelId, 0);
    }
    if (slideIndexMap.get(hotelId) < 0) {
        slideIndexMap.set(hotelId, imageArrayMap.get(hotelId).length - 2);
    }

    mySlides.setAttribute("src", imageArrayMap.get(hotelId)[slideIndexMap.get(hotelId)]);
    /* mySlides.className += " w3-animate-opacity";
    setTimeout(function() {
        mySlides.className = mySlides.className.replace(" w3-animate-opacity", "");
    }, 100); */

}

/**
 * Hiển thị map cho hotel có id = hotelId
 **/
function showHotelMap(hotelId, tabInfo) {
    //send ajax to get price and lat lng
    var query =
        `query {
			  hotel(id: ` + hotelId + `) {
		    latitude
		    longitude
		    price
		  }
		}`;
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            var hotel = JSON.parse(this.responseText).data.hotel;

            var data = "<div class='location_string'>" + locationString + "</div>";
            data += '<div class="map_wrapper">';
            data +=	'<div class="hotel-map" id="map' + hotelId + '"></div>';
            data +=	'<div id="hotel-popup' + hotelId + '" class="hotel-popup">';
            data += addDotsToNumber(hotel.price) + 'đ';
            data +=	'</div></div>';

            tabInfo.innerHTML = data;

            setTimeout(function() {
                //show map
                mapMap.set(hotelId, new google.maps.Map(document.getElementById('map' + hotelId), {
                    center: { lat: parseFloat(hotel.latitude), lng: parseFloat(hotel.longitude) },
                    zoom: 14,
                }));

                popupMap.set(hotelId, new Popup(
                    new google.maps.LatLng(hotel.latitude, hotel.longitude),
                    document.getElementById("hotel-popup" + hotelId)
                ));
                popupMap.get(hotelId).setMap(mapMap.get(hotelId));
            }, 300);

        }
    };
    xhttp.open("GET", "/graphql?query=" + escape(query), true);
    xhttp.setRequestHeader("Content-Type", "application/json; charset=UTF-8");
    xhttp.send();

}

function filterStar(star) {
    document.getElementById("star_rate").innerHTML = star;
}

function getSuggestion(element) {
    if(element.value == "") {
        document.getElementById("suggestion_places").style.display = 'none';
        return;
    }
    document.getElementById("suggestion_places").style.display = 'block';
    var url = "/autocomplete/json?input=" + element.value.replace(" ", "%20");
    var suggestion_places = document.getElementById("suggestion_places");
    suggestion_places.innerHTML = "";
    var data = "";
    var arr = [];
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            console.log(this.responseText);
            var res = JSON.parse(this.responseText);
            var predictions = res.predictions;

            var description;
            for(var i=0; i<predictions.length; i++) {
                description = predictions[i].description;
                arr = description.split(",");
                if(arr.length > 3) continue;

                if(arr.length == 2)
                    data = data + '<div onclick="showSuggestion(\'' + description + '\', \'city\')" class="suggestion_item">' + description +
                        '<span class="suggestion_item_span">' + STR_CITY + '</span></div>';
                else if(arr.length == 3)
                    data = data + '<div onclick="showSuggestion(\'' + description + '\', \'district\')" class="suggestion_item">' + description +
                        '<span class="suggestion_item_span">' + STR_DISTRICT + '</span></div>';
            }

            var hotels = res.hotels.data.hotels;
            if(hotels != null && hotels != "") {
            	for(var i=0; i<hotels.length; i++) {
                    data += '<div onclick="showSuggestion(\'' + hotels[i].name + '\', \'name\')" class="suggestion_item">' + hotels[i].name +
                        '<span class="suggestion_item_span">' + STR_HOTEL + '</span></div>';
                }
            }

            suggestion_places.innerHTML = data;
        }
    };
    xhttp.open("GET", url, true);
    xhttp.setRequestHeader("Content-Type", "application/json; charset=UTF-8");
    xhttp.send();
}

function showSuggestion(string, searchBy) {
    document.getElementById("input_hotel_name").value = string;
    document.getElementById("suggestion_places").style.display = 'none';
    document.getElementById("search_hotel_by").value = searchBy;
}