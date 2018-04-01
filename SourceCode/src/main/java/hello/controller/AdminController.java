package hello.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class AdminController {

	@RequestMapping(value= {"/{locale:en|vi}/admin", "/admin"})
	public String adminHome() {
		return "adminPage";
	}
}
