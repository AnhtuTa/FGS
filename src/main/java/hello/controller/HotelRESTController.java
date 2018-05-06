package hello.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import hello.dao.HotelDAO;
import hello.model.Hotel;

@RestController
public class HotelRESTController {

	@Autowired
	HotelDAO hotelDAO;
	
	/*
	 * Giải thích:
		produces = { MediaType.APPLICATION_JSON_VALUE, MediaType.APPLICATION_XML_VALUE }
		produces = { "application/json" , "application/xml" }
		Thuộc tính produces được sử dụng để quy định một URL sẽ chỉ tạo ra (trả về cho người dùng) các dữ liệu với các định dạng nào. Chẳng hạn "application/json", "application/xml".
	 */
	// URL:
    // http://localhost:8080/rest/hotel
    // http://localhost:8080/rest/hotel.xml
    // http://localhost:8080/rest/hotel.json
	@RequestMapping(value= {"/rest/hotels"}, //
			method = RequestMethod.GET,  produces = { MediaType.APPLICATION_JSON_VALUE})
	@ResponseBody
	public List<Hotel> getAllHotels() {
		return hotelDAO.getAllHotels();
	}
	
	// URL:
    // http://localhost:8080/rest/hotel/{hotelID}
    // http://localhost:8080/rest/hotel/{hotelID}.xml
    // http://localhost:8080/rest/hotel/{hotelID}.json
	@RequestMapping(value= {"/rest/hotel/{hotelId}"}, //
			method = RequestMethod.GET,  produces = { MediaType.APPLICATION_JSON_VALUE})
	@ResponseBody
	public Hotel getHotel(@PathVariable("hotelId") long hotelId) {
		return hotelDAO.getHotel(hotelId);
	}
}
