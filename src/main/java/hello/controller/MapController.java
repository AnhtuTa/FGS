package hello.controller;

import java.util.List;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import hello.dao.HotelDAO;
import hello.model.Hotel;

@Controller
public class MapController {
	@Autowired
	HotelDAO hotelDAO;
	
	@RequestMapping(value= {"/{locale:en|vi}/map", "/map"})
	public String home(Model model, HttpServletRequest request) {
		
		if(request.getParameter("location") != null) {
			//model.addAttribute("hotelMap", hotelDAO.getAllHotelMap());
//			Map<Long, Hotel> hotelMap = hotelDAO.getAllHotelMap();
//			
//			List<Long> hotelIdList = new ArrayList<>();
//			for(long key : hotelMap.keySet()) {
//				hotelIdList.add(key);
//			}
//			
//			request.setAttribute("hotelIdList", hotelIdList);
//			request.setAttribute("hotelMap", hotelMap);
			
			List<Hotel> hotelIdPriceList = hotelDAO.getHotelIdPricesGeo();
			System.out.println("[MapController]");
			for(Hotel ht : hotelIdPriceList) {
				System.out.println(ht.getId() + " - " + ht.getPrice() + " - " + ht.getLatitude());
			}
			model.addAttribute("hotelIdPriceList", hotelIdPriceList);
		} else {
			//model.addAttribute();
		}
		
		//return "map";
		return "map2";
	}
}
