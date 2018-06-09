package hello.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import java.util.Enumeration;

@Controller
public class LoginLogoutController {

    @RequestMapping(value = {"/{locale:en|vi}/login", "/login"}, method = RequestMethod.GET)
    public String loginPage(HttpServletRequest req) {
        //Nếu người dùng đã login rồi thì ko được login hoặc register nữa
        //(phải logout trước đã). Do đó ta sẽ redirect về trang chủ
        //CHÚ Ý: ko được return tên file nhé, phải redirect về trang chủ,
        //ko được: return "index";
        if (req.getSession().getAttribute("SPRING_SECURITY_CONTEXT") != null) {
            req.getSession().setAttribute("USER_MUST_LOGOUT_FIRST", 1);
            return "redirect:/home";
        }
        return "login";
    }

    /**
     * Thằng spring nó sẽ tự động thiết lập các thứ liên quan đến logout khi người dùng truy cập vào url /logout
     * Do đó sẽ ko bao giờ nhảy vào hàm này! Do đó tất cả session attribute đều được Spring nó xóa chứ ta ko xóa
     * được bằng tay như ở dưới! (hàm sau ko bao giờ chạy)
     *
     * @param request
     * @return
     */
    @RequestMapping(value = "/logout", method = RequestMethod.GET)
    public String logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        String ls = session.getAttribute("localeString").toString();

        Enumeration<String> attributeNames = session.getAttributeNames();
        while (attributeNames.hasMoreElements()) {
            String attrName = attributeNames.nextElement();
            session.removeAttribute(attrName);
        }
        // close session
        session.invalidate();

        session.setAttribute("localeString", ls);
        System.out.println("1. ls = " + session.getAttribute("localeString"));  //ko bao giờ in ra console dòng này
        return "redirect:/logout_successful";
    }

    @RequestMapping(value = "/logout_successful", method = RequestMethod.GET)
    public String logoutSuccessfulWithoutLocale(HttpServletRequest req) {
        String ls = (String) req.getSession().getAttribute("localeString");
        //ls luôn = null, vì spring security mặc định sẽ xóa tất cả attribute của session sau khi logout
        if (ls == null) ls = "vi";
        //do đó sau khi logout thì locale lại reset lại thành Vietnam, dù trước đó người dùng dùng tiếng Anh
        return "redirect:/" + ls + "/logout_successful";
    }

    @RequestMapping(value = "/{locale:en|vi}/logout_successful", method = RequestMethod.GET)
    public String logoutSuccessful() {
        return "logoutSuccessful";
    }
}
