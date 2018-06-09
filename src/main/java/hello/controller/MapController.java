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
		
		if(request.getParameter("search_by") != null) {
			String fieldName = request.getParameter("search_by");
			String fieldValue = request.getParameter("input");
			String yourLat = request.getParameter("your_lat");
			String yourLng = request.getParameter("your_lng");
			String is_show_your_pos = request.getParameter("is_show_your_pos");

			//model.addAttribute("input_value", fieldValue);
			if(fieldName.equals("location")) {
				fieldName = "city";
			} else {
				fieldValue = fieldValue.split(",")[0];
			}

			List<Hotel> hotelIdPriceList = hotelDAO.getHotelIdPricesGeo(fieldName, fieldValue);
			if(hotelIdPriceList.size() == 0) {
				model.addAttribute("no_hotel", "1");
			} else {
			    //tìm điểm trung tâm của map
			    if(yourLat != null && yourLng != null) {
                    model.addAttribute("center_lat", yourLat);
                    model.addAttribute("center_lng", yourLng);
                } else {
                    for (Hotel h : hotelIdPriceList) {
                        if (h.getLatitude() != null && h.getLongitude() != null) {
                            model.addAttribute("center_lat", h.getLatitude());
                            model.addAttribute("center_lng", h.getLongitude());
                            break;
                        }
                    }
                }
			}
			model.addAttribute("hotelIdPriceList", hotelIdPriceList);
			if(is_show_your_pos != null && is_show_your_pos.equals("true")) {
                model.addAttribute("zoom", 15);
            } else if("district".equals(fieldName)) {
				model.addAttribute("zoom", 14);
			} else if("city".equals(fieldName)) {
				model.addAttribute("zoom", 12);
			}
		} else {
			model.addAttribute("no_hotel", "1");
		}
		
		//return "map";
		return "map2";
	}
}
