package hello.controller;

import java.security.Principal;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import hello.util.FormatPrice;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import hello.dao.DistrictDAO;
import hello.dao.HotelDAO;
import hello.dao.ProvinceDAO;
import hello.model.District;
import hello.model.Province;
import hello.service.MyUserDetailsService;

@Controller
public class MainController {

	@Autowired
	HotelDAO hotelDAO;
	@Autowired
	ProvinceDAO provinceDAO;

	@Autowired
	DistrictDAO districtDAO;
	
	@RequestMapping(value= {"/{locale:en|vi}/", "/", "/{locale:en|vi}/home", "/home"})
	public String home(Model model, HttpServletRequest request) {
		//model.addAttribute("message", "Today I overslept! My mom said: \"Try and get an early night so I don't oversleep tomorrow\"");
        List<Province> provinceList = provinceDAO.getAllProvinces();
        List<District> districtList = districtDAO.getDistricts(1);
        model.addAttribute("provinceList", provinceList);
        model.addAttribute("districtList", districtList);

		if(request.getSession().getAttribute("USER_MUST_LOGOUT_FIRST") != null) {
			model.addAttribute("USER_MUST_LOGOUT_FIRST", 1);
			request.getSession().removeAttribute("USER_MUST_LOGOUT_FIRST");
		}

		if(request.getParameter("search_type") != null) {
		    switch (request.getParameter("search_type")) {
                case "hotel":
                    try {
                        String fieldName = request.getParameter("search_by");
                        String fieldValue = request.getParameter("input");
                        fieldValue = fieldValue.split(",")[0];
                        
                        String priceRange = request.getParameter("price_range");
                        String[] prices = priceRange.split("-");
                        prices[0] = prices[0].trim();
                        prices[1] = prices[1].trim();
                        FormatPrice fp = new FormatPrice();
                        int lowPrice = fp.getPrice(prices[0].substring(0, prices[0].length() - 1));   //Chú ý hàm: public String substring(int startIndex, int endIndex) : endIndex : ending index is exclusive
                        int highPrice = fp.getPrice(prices[1].substring(0, prices[1].length() - 1));
                        
                        boolean [] stars = {false, false, false, false, false};
                        if(request.getParameter("cb_1star") != null) {
                        	stars[0] = true;
                        }
                        if(request.getParameter("cb_2star") != null) {
                        	stars[1] = true;
                        }
                        if(request.getParameter("cb_3star") != null) {
                        	stars[2] = true;
                        }
                        if(request.getParameter("cb_4star") != null) {
                        	stars[3] = true;
                        }
                        if(request.getParameter("cb_5star") != null) {
                        	stars[4] = true;
                        }
                        
                        int page = 1;
                        if (request.getParameter("page") != null) {
                            page = Integer.valueOf(request.getParameter("page"));
                        }
                        int start = (page - 1) * 20;
                        int nums = 20;

                        model.addAttribute("hotelList", hotelDAO.getHotelsByFieldAtHomePage(fieldName, fieldValue, lowPrice, highPrice, stars, start, nums));
                        break;
                    } catch (Exception e) {
                        e.printStackTrace();
                        return "404Page";
                    }
                case "nhatro":

                    break;
                default:
                    return "404Page";
            }
        }

		return "index";
	}

	@RequestMapping(value = {"/{locale:en|vi}/user_info", "/user_info"}, method = RequestMethod.GET)
	public String userInfo(Principal principal) {
		// Sau khi user login thanh cong se co principal
		String userName = principal.getName();
		System.out.println("[/user_info] User Name: " + userName);
		
		System.out.println("userFullname = " + MyUserDetailsService.userFullname);
		return "userInfo";
	}
	
	@RequestMapping(value = {"/{locale:en|vi}/403", "/403"}, method = RequestMethod.GET)
	public String accessDenied() {
		return "403Page";
	}
	
	@RequestMapping(value = "/english")
	public String switchToEnglish(HttpServletRequest request) {
		//get previous URL
		String referer = request.getHeader("Referer");			// http://localhost:8080/vi/login
		String url = request.getRequestURL().toString();		// url = http://localhost:8080/english
		String uri = request.getRequestURI();					// /english
		String hostname = url.substring(0, url.length() - uri.length());		// http://localhost:8080
		String prevUri = referer.substring(hostname.length());		// /vi/login
		
		if(prevUri.startsWith("/vi/")) {
			return "redirect:/en/" + prevUri.substring(4);
		} else if(prevUri.startsWith("/en/")) {
			return "redirect:" + referer;	//vẫn ở lại trang đó
		} else {
			return "redirect:/en" + prevUri;
		}
	}
	
	@RequestMapping(value = "/vietnamese")
	public String switchToVietnamese(HttpServletRequest request) {
		//get previous URL
		String referer = request.getHeader("Referer");
		String url = request.getRequestURL().toString();
		String uri = request.getRequestURI();
		String hostname = url.substring(0, url.length() - uri.length());
		String prevUri = referer.substring(hostname.length());
		
		if(prevUri.startsWith("/en/")) {
			return "redirect:/vi/" + prevUri.substring(4);
		} else if(prevUri.startsWith("/vi/")) {
			return "redirect:" + referer;	//vẫn ở lại trang đó
		} else {
			return "redirect:/vi" + prevUri;
		}
	}
	
	/*============ old version: ===========*/
//	@RequestMapping(value = "/user_info", method = RequestMethod.GET)
//	public String userInfoWithoutLocale(HttpServletRequest req) {
//		không nên làm như sau, nên dùng interceptor để áp dụng cho mọi URL:
//		String ls = (String) req.getSession().getAttribute("localeString");
//		if(ls == null) ls = "en";
//		return "redirect:/" + ls + "/user_info";
//	}
	
//	@RequestMapping(value = "/vietnamese")
//	public String switchToVietnamese(HttpServletRequest request) {
//		//get previous URL
//		String referer = request.getHeader("Referer");
//		int index = referer.indexOf("/en/");
//		if(index > 0) {
//			return "redirect:/vi/" + referer.substring(index + 4);
//		} else {
//			return "redirect:" + referer;	//vẫn ở lại trang đó
//		}
//	}
	
//	@RequestMapping(value = "/error")
//	public String pageNotFound() {
////		String ls = (String) req.getSession().getAttribute("localeString");
////		if (ls == null) ls = "en";
//		return "404Page";
//	}
}
