package hello.controller;

import java.security.Principal;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import hello.service.MyUserDetailsService;

@Controller
public class MainController {

	@RequestMapping(value= {"/{locale:en|vi}/", "/", "/{locale:en|vi}/home", "/home"})
	public String home(Model model, HttpServletRequest request) {
		model.addAttribute("message", "Today I overslept! My mom said: \"Try and get an early night so I don't oversleep tomorrow\"");
		
		if(request.getSession().getAttribute("USER_MUST_LOGOUT_FIRST") != null) {
			model.addAttribute("USER_MUST_LOGOUT_FIRST", 1);
			request.getSession().removeAttribute("USER_MUST_LOGOUT_FIRST");
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
