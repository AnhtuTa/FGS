package hello.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class LoginLogoutController {
	
	@RequestMapping(value = {"/{locale:en|vi}/login", "/login"}, method = RequestMethod.GET)
	public String loginPage(HttpServletRequest req) {
		//Nếu người dùng đã login rồi thì ko được login hoặc register nữa
		//(phải logout trước đã). Do đó ta sẽ redirect về trang chủ
		//CHÚ Ý: ko được return tên file nhé, phải redirect về trang chủ,
		//ko được: return "index";
		if(req.getSession().getAttribute("SPRING_SECURITY_CONTEXT") != null) {
			req.getSession().setAttribute("USER_MUST_LOGOUT_FIRST", 1);
			return "redirect:/home";
		}
		return "login";
	}
	
	@RequestMapping(value = "/logout_successful", method = RequestMethod.GET)
	public String logoutSuccessfulWithoutLocale(HttpServletRequest req) {
		String ls = (String) req.getSession().getAttribute("localeString");
		if(ls == null) ls = "en";
		return "redirect:/" + ls +"/logout_successful";
	}

	@RequestMapping(value = "/{locale:en|vi}/logout_successful", method = RequestMethod.GET)
	public String logoutSuccessful() {
		return "logoutSuccessful";
	}
}
