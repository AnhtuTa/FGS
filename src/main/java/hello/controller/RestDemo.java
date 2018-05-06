package hello.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import hello.dao.HotelDAO;
import hello.model.Hotel;

@Controller
public class RestDemo {

	@Autowired
	HotelDAO hotelDAO;
	
	@ResponseBody
	@RequestMapping(value= {"/rest/hotel"})
	public String getHotels() {
		String kq = "[";
		
		List<Hotel> htList = hotelDAO.getAllHotels();
		for(Hotel ht : htList) {
			kq += "\t{'name': '" + ht.getName() + "'},\n";
		}
		kq += "]";
		
		return kq;
	}
}
