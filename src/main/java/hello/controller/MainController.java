package hello.controller;

import java.security.Principal;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import hello.dao.PostDAO;
import hello.model.Hotel;
import hello.model.Post;
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

@Controller
public class MainController {

    @Autowired
    HotelDAO hotelDAO;

    @Autowired
    PostDAO postDAO;

    @Autowired
    ProvinceDAO provinceDAO;

    @Autowired
    DistrictDAO districtDAO;

    @RequestMapping(value = {"/{locale:en|vi}/", "/", "/{locale:en|vi}/home", "/home"})
    public String home(Model model, HttpServletRequest request) {
        if(request.getParameter("city") == null) {
            List<Province> provinceList = provinceDAO.getAllProvinces();
            List<District> districtList = districtDAO.getDistricts(1);
            model.addAttribute("provinceList", provinceList);
            model.addAttribute("districtList", districtList);
        }

        if (request.getSession().getAttribute("USER_MUST_LOGOUT_FIRST") != null) {
            model.addAttribute("USER_MUST_LOGOUT_FIRST", 1);
            request.getSession().removeAttribute("USER_MUST_LOGOUT_FIRST");
        }

        if (request.getParameter("search_type") != null) {
            switch (request.getParameter("search_type")) {
                case "hotel":
                    return searchTypeHotel(model, request);
                case "nhatro":
                    return searchTypeNhatro(model, request);
                default:
                    return "404Page";
            }
        } else {
            //người dùng vừa vào trang chủ và chưa tìm gì
//            model.addAttribute("low_price_range", 0);
//            model.addAttribute("high_price_range", 30000000);
        }

        return "index";
    }

    private String searchTypeHotel(Model model, HttpServletRequest request) {
        try {
            //tìm kiếm theo field nào
            String fieldName = request.getParameter("search_by");
            String fieldValue = request.getParameter("input");
            String yourLat = null, yourLng = null, cityFound = null;
            if(fieldName.equals("location")) {
                yourLat = request.getParameter("your_lat");
                yourLng = request.getParameter("your_lng");
                cityFound = request.getParameter("city_found");
            } else {
                model.addAttribute("input_value", fieldValue);
                fieldValue = fieldValue.split(",")[0];
            }

            //khoảng giá
            int [] prices = getPriceParam(request);
            int lowPrice = prices[0];
            int highPrice = prices[1];

            //hạng sao
            boolean[] stars = {false, false, false, false, false};
            if (request.getParameter("cb_1star") != null) {
                stars[0] = true;
                model.addAttribute("cb_1star_checked", "1");
            }
            if (request.getParameter("cb_2star") != null) {
                stars[1] = true;
                model.addAttribute("cb_2star_checked", "1");
            }
            if (request.getParameter("cb_3star") != null) {
                stars[2] = true;
                model.addAttribute("cb_3star_checked", "1");
            }
            if (request.getParameter("cb_4star") != null) {
                stars[3] = true;
                model.addAttribute("cb_4star_checked", "1");
            }
            if (request.getParameter("cb_5star") != null) {
                stars[4] = true;
                model.addAttribute("cb_5star_checked", "1");
            }

            //sắp xếp
            String orderBy = request.getParameter("order_by");
            String orderByString = null;
            switch (orderBy) {
                case "price ASC":
                    orderByString = "price ASC";
                    model.addAttribute("price_asc", "1");
                    break;
                case "price DESC":
                    orderByString = "price DESC";
                    model.addAttribute("price_desc", "1");
                    break;
                case "review_point DESC":
                    orderByString = "review_point DESC";
                    model.addAttribute("review_point_desc", "1");
                    break;
                default:
                    orderByString = null;
                    //do nothing
            }

            //=============== phân trang ===============
            int page = 1; int numOfHotels;
            if (request.getParameter("page") != null) {
                page = Integer.valueOf(request.getParameter("page"));
            }
            if(fieldName.equals("location")) {
                numOfHotels = hotelDAO.countHotelsByLocationAtHomePage(cityFound, lowPrice, highPrice, stars);
            } else {
                numOfHotels = hotelDAO.countHotelsByFieldAtHomePage(fieldName, fieldValue, lowPrice, highPrice, stars);
            }
            int start = (page - 1) * 20;
            int nums = 20;

            pagination(request, page, numOfHotels);

            List<Hotel> hotelList = null;
            if(fieldName.equals("location")) {
                hotelList = hotelDAO.getHotelsByLocationAtHomePage(cityFound, lowPrice, highPrice, stars, start, nums, orderByString);
                model.addAttribute("cb_search_by_curr_pos_hotel_checked", true);
                model.addAttribute("your_lat", yourLat);
                model.addAttribute("your_lng", yourLng);
            } else {
                hotelList = hotelDAO.getHotelsByFieldAtHomePage(fieldName, fieldValue, lowPrice, highPrice, stars, start, nums, orderByString);
            }

            model.addAttribute("hotelList", hotelList);

            //trả lại các giá trị mà người dùng trước đó đã chọn
            model.addAttribute("search_by_value", fieldName);
            model.addAttribute("low_price_range", lowPrice);
            model.addAttribute("high_price_range", highPrice);
            model.addAttribute("enabled_btn_search", "1");

            return "index";
        } catch (Exception e) {
            e.printStackTrace();
            return "404Page";
        }
    }

    private String searchTypeNhatro(Model model, HttpServletRequest request) {
        try {
            String city, district;
            List<Province> provinceList = null;
            List<District> districtList = null;

            if(request.getParameter("cb_search_by_curr_pos_nhatro") != null) {
                city = request.getParameter("city_found");
                districtList = districtDAO.getDistricts(1);
                model.addAttribute("cb_search_by_curr_pos_nhatro_checked", true);
                model.addAttribute("disable_spinner_city", 1);
                model.addAttribute("disable_spinner_district", 1);
            } else {
                int cityId = Integer.valueOf(request.getParameter("city"));
                city = provinceDAO.getProvinceName(cityId);
                districtList = districtDAO.getDistricts(cityId);
                model.addAttribute("selected_city_id", cityId);
            }

            int districtId = -1;

            if(request.getParameter("district") != null && !request.getParameter("district").equals("")) {
                districtId = Integer.valueOf(request.getParameter("district"));
                district = districtDAO.getDistrictName(districtId);
            } else {
                district = null;
            }

            provinceList = provinceDAO.getAllProvinces();
            model.addAttribute("provinceList", provinceList);
            model.addAttribute("districtList", districtList);
            if(districtId > 0) model.addAttribute("selected_district_id", districtId);

            //khoảng giá
            int [] prices = getPriceParam(request);
            int lowPrice = prices[0];
            int highPrice = prices[1];

            //sắp xếp
            String orderBy = request.getParameter("order_by");
            String orderByString = null;
            switch (orderBy) {
                case "price ASC":
                    orderByString = "price ASC";
                    model.addAttribute("price_asc2", "1");
                    break;
                case "price DESC":
                    orderByString = "price DESC";
                    model.addAttribute("price_desc2", "1");
                    break;
                case "time DESC":
                    orderByString = "time DESC";
                    model.addAttribute("time_desc2", "1");
                    break;
                default:
                    orderByString = null;
                    //do nothing
            }

            //=============== phân trang ===============
            int page = 1;
            if (request.getParameter("page") != null) {
                page = Integer.valueOf(request.getParameter("page"));
            }
            int numOfPosts = postDAO.countPostsAtHomePage(city, district, lowPrice, highPrice);
            int start = (page - 1) * 20;
            int nums = 20;

            pagination(request, page, numOfPosts);

            List<Post> postList = postDAO.getPostsAtHomePage(city, district, lowPrice, highPrice, start, nums, orderByString);
            model.addAttribute("postList", postList);

            //trả lại các giá trị mà người dùng trước đó đã chọn
            model.addAttribute("show_tab_nhatro", 1);
            model.addAttribute("low_price_range2", lowPrice);
            model.addAttribute("high_price_range2", highPrice);

            return "index";
        } catch (Exception e) {
            e.printStackTrace();
            return "404Page";
        }
    }

    private int [] getPriceParam(HttpServletRequest request) {
        String priceRange = request.getParameter("price_range");
        String[] prices = priceRange.split("-");
        prices[0] = prices[0].trim();
        prices[1] = prices[1].trim();
        FormatPrice fp = new FormatPrice();
        int lowPrice = fp.getPrice(prices[0].substring(0, prices[0].length() - 1));   //Chú ý hàm: public String substring(int startIndex, int endIndex) : endIndex : ending index is exclusive
        int highPrice = fp.getPrice(prices[1].substring(0, prices[1].length() - 1));

        return new int[] {lowPrice, highPrice};
    }

    /**
     * Phân trang kq trả về
     * @param request
     * @param page current page
     * @param numoOfRecords số lượng record lấy từ database để phân trang
     */
    private void pagination(HttpServletRequest request, int page, int numoOfRecords) {
        if (page == 1 || request.getSession().getAttribute("amountOfPages") == null) {
            //Lấy tổng số hotel để tính số trang, mỗi trang có 20 hotel
            int numOfPages;

            if(numoOfRecords <= 20) numOfPages = 1;
            else {
                numOfPages = (numoOfRecords % 20 == 0 ? numoOfRecords/20 : (numoOfRecords/20 + 1));
            }

            //numOfPages = 50;    //just for demo!
            //sau đó lưu vào session
            request.getSession().setAttribute("amountOfPages", numOfPages);

            //tìm link để chuyển trang
            String currentURI = request.getSession().getAttribute("currentURI").toString();
            String link;
            if (currentURI.contains("page")) {
                //Nếu currentURI có chứa param "page" thì xóa tất cả những gì từ chỗ này trở đi
                //do đó phải ĐẢM BẢO RẰNG PARAM "page" TỪ REQUEST PHẢI Ở VỊ TRÍ CUỐI CÙNG
                link = currentURI.substring(0, currentURI.indexOf("page") - 1);
            } else {
                link = currentURI;
            }

            //lưu link vào session
            request.getSession().setAttribute("link_page_numbering", link);
        }

        StringBuilder paginationLink = new StringBuilder();
        if (page > 1) {
            paginationLink.append(printPageNum(request, page-1, "&#10094;")); // Nút previous
        }

        //============= algorithm in here ==================//
        int amountOfPages = Integer.valueOf(request.getSession().getAttribute("amountOfPages").toString());

        if (amountOfPages < 15) {
            for (int i = 1; i < amountOfPages; i++) {
                if (i == page) paginationLink.append(printCurrentPage(i));
                else {
                    paginationLink.append(printPageNum(request, i, i + ""));
                }
            }

            if (amountOfPages == page) {
                paginationLink.append(printCurrentPage(amountOfPages));
            } else {
                paginationLink.append(printPageNum(request, amountOfPages, amountOfPages+""));
            }
        } else {
            if (page <= 5) {        // là 1 trong 5 trang đầu tiên
                for (int i = 1; i <= 6; i++) {
                    if (i == page) paginationLink.append(printCurrentPage(i));
                    else paginationLink.append(printPageNum(request, i, i+""));
                }
                paginationLink.append("... ");
                for (int i = amountOfPages - 2; i <= amountOfPages; i++) {
                    paginationLink.append(printPageNum(request, i, i+""));
                }
            } else if (page >= amountOfPages - 4) {        // là 1 trong 5 trang cuối
                for (int i = 1; i <= 3; i++) {
                    paginationLink.append(printPageNum(request, i, i+""));
                }
                paginationLink.append("... ");
                for (int i = amountOfPages - 5; i <= amountOfPages; i++) {
                    if (i == page) paginationLink.append(printCurrentPage(i));
                    else paginationLink.append(printPageNum(request, i, i+""));
                }
            } else {        // là 1 trang ở giữa
                for (int i = 1; i <= 3; i++) {
                    paginationLink.append(printPageNum(request, i, i+""));
                }
                paginationLink.append("... ");
                for (int i = -1; i <= 1; i++) {
                    int temp = page + i;
                    if (temp == page) paginationLink.append(printCurrentPage(temp));
                    else paginationLink.append(printPageNum(request, temp, temp+""));
                }
                paginationLink.append("... ");
                for (int i = amountOfPages - 2; i <= amountOfPages; i++) {
                    paginationLink.append(printPageNum(request, i, i+""));
                }
            }
        }
        //============= algorithm end here ==================//

        if (page < amountOfPages) {
            paginationLink.append(printPageNum(request, page+1, "&#10095;"));   //nút next
        }

        request.setAttribute("paginationLink", paginationLink.toString());
    }

    private String printPageNum(HttpServletRequest request, int pageNumber, String label) {
        return "<a class='btn_pagination' href='" + request.getSession().getAttribute("link_page_numbering") + "&page=" + pageNumber + "'>" + label + "</a> ";
    }

    private String printCurrentPage(int k) {
        return "<b class='btn_pagination pagination_current_page'>" + k + "</b> ";
    }

    @RequestMapping(value = {"/{locale:en|vi}/user_info", "/user_info"}, method = RequestMethod.GET)
    public String userInfo(Principal principal, HttpServletRequest request) {
        // Sau khi user login thanh cong se co principal
        String userName = principal.getName();
        System.out.println("[/user_info] User Name: " + userName);

        return "userInfo";
    }

    @RequestMapping(value = {"/{locale:en|vi}/403", "/403"}, method = RequestMethod.GET)
    public String accessDenied() {
        return "403Page";
    }

    @RequestMapping(value = "/english")
    public String switchToEnglish(HttpServletRequest request) {
        //get previous URL
        String referer = request.getHeader("Referer");            // http://localhost:8080/vi/login
        String url = request.getRequestURL().toString();        // url = http://localhost:8080/english
        String uri = request.getRequestURI();                    // /english
        String hostname = url.substring(0, url.length() - uri.length());        // http://localhost:8080
        String prevUri = referer.substring(hostname.length());        // /vi/login

        if (prevUri.startsWith("/vi/")) {
            return "redirect:/en/" + prevUri.substring(4);
        } else if (prevUri.startsWith("/en/")) {
            return "redirect:" + referer;    //vẫn ở lại trang đó
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

        if (prevUri.startsWith("/en/")) {
            return "redirect:/vi/" + prevUri.substring(4);
        } else if (prevUri.startsWith("/vi/")) {
            return "redirect:" + referer;    //vẫn ở lại trang đó
        } else {
            return "redirect:/vi" + prevUri;
        }
    }

    @RequestMapping(value = {"/{locale:en|vi}/noJS", "/noJS"})
    public String noJS(HttpServletRequest request) {
        return "no_js";
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
