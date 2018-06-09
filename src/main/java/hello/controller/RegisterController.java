package hello.controller;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import hello.dao.MyUserDAO;
import hello.model.MyUser;

@Controller
public class RegisterController {
	@Autowired
	MyUserDAO myUserDao;

	@RequestMapping(value = { "/{locale:en|vi}/register", "/register" }, method = RequestMethod.GET)
	public String register(Model model, HttpServletRequest req) {
		if(req.getSession().getAttribute("SPRING_SECURITY_CONTEXT") != null) {
			req.getSession().setAttribute("USER_MUST_LOGOUT_FIRST", 1);
			return "redirect:/home";
		}
		if (!model.containsAttribute("myUser")) {
			model.addAttribute("myUser", new MyUser());
		}
		return "register";
	}

	@RequestMapping(value = { "/{locale:en|vi}/register", "/register" }, method = RequestMethod.POST)
	public String doRegister(@ModelAttribute("myUser") @Valid MyUser myUser, BindingResult result,
			HttpServletRequest request) {
		if (result.hasErrors()) {
			// List<ObjectError> errorList = result.getAllErrors();
			// for(ObjectError err : errorList) {
			// System.out.println("\tgetDefaultMessage = " + err.getDefaultMessage());
			// System.out.println("\tgetCode = " + err.getCode());
			// System.out.println("\tgetObjectName = " + err.getObjectName());
			// System.out.println();
			// }

			return "register";
			// chú ý: return TÊN FILE VIEW NHÉ, CHỨ KHÔNG PHẢI ĐƯỜNG DẪN (/en/register)
			// MẤT CẢ BUỔI CHIỀU ĐỀ TÌM RA LỖI NÀY!
		}
		
		if(!myUser.getPassword().equals(myUser.getConfirmPassword())) {
			request.setAttribute("PASSWORD_DOESNT_MATCH", 1);
			return "register";
		} else if ("OK".equals(myUserDao.saveMyUser(myUser))) {
			return "registerSuccessful";
		} else if ("duplicate_key".equals(myUserDao.saveMyUser(myUser))) {
			request.setAttribute("DUPLICATE_USER_OR_EMAIL", 1);
			return "register";
		} else {
			request.setAttribute("UNKNOWN_ERROR", 1);
			return "register";
		}
	}

}
