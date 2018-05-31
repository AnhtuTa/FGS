package hello.controller;

import java.util.Enumeration;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import hello.dao.DistrictDAO;
import hello.dao.ProvinceDAO;
import hello.model.District;
import hello.model.Province;

@Controller
public class PostController {
    @Autowired
    ProvinceDAO provinceDAO;

    @Autowired
    DistrictDAO districtDAO;

    @RequestMapping(value = {"/{locale:en|vi}/post", "/post"}, method = RequestMethod.GET)
    public String post(Model model) {
        List<Province> provinceList = provinceDAO.getAllProvinces();
        List<District> districtList = districtDAO.getDistricts(1);
        model.addAttribute("provinceList", provinceList);
        model.addAttribute("districtList", districtList);

        return "post";
    }

    @RequestMapping(value = {"/{locale:en|vi}/post", "/post"}, method = RequestMethod.POST)
    public String doPost(HttpServletRequest request) {
    	Enumeration<String> params = request.getParameterNames();
    	while(params.hasMoreElements()) {
    		String key = params.nextElement();
    		System.out.println(key + " = " + request.getParameter(key));
    	}

    	String []imageUrls = request.getParameterValues("image_url");
    	for(String url : imageUrls) {
    		System.out.println("url = " + url);
    	}
        return "post";
    }
}
