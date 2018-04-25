//package hello.controller;
//
//import javax.servlet.RequestDispatcher;
//import javax.servlet.http.HttpServletRequest;
//
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.boot.autoconfigure.web.ErrorController;
//import org.springframework.stereotype.Controller;
//import org.springframework.web.bind.annotation.RequestMapping;
//
//@Controller
//public class MyErrorController implements ErrorController {
//
//	@Autowired
//	HttpServletRequest request;
//	
//	//giả sử người dùng enter 1 URL = /en/utwarklawrleaw/rfewra
//	//do URL trên ko có controller xử lý nên sẽ có lỗi 404, sau
//	//đó spring sẽ forward sang trang /error
//	//CHÚ Ý: forward chứ ko redirect nhé, thế nên trên thanh URL là địa chỉ
//	// /en/utwarklawrleaw/rfewra chứ ko phải /error, mặc dù trang hiện tại
//	// có địa chỉ là /error
//	@RequestMapping(value = {"/error", "/{locale:en|vi}/error"})
//	public String error(HttpServletRequest request) {
//		String forwardRequestUri = request.getAttribute(RequestDispatcher.FORWARD_REQUEST_URI).toString();
//		request.getSession().setAttribute("currentURI", forwardRequestUri);
//		return "404Page";
//	}
//
//	@Override
//	public String getErrorPath() {
//		return "/error";
//	}
//
//	@RequestMapping(value = {"/{locale:en|vi}/page_not_found", "/page_not_found"})
//	public String pageNotFound(HttpServletRequest request) {
//		return "404Page";
//	}
//}
