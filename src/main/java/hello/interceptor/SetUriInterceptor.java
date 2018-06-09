package hello.interceptor;

import java.util.Enumeration;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import hello.service.MyUserDetailsService;

/*
 * Khi login xong thì Spring security sẽ thiết lập 1 attribute của session có tên
 * là SPRING_SECURITY_CONTEXT. attribute này lưu các thuộc tính của người
 * dùng vừa login. Sau khi logout thì attribute này sẽ bị xóa, do đó người 
 * dùng cần login lại để có thể truy cập đc những trang yêu cầu login
 * 
 * Trước khi login, spring security sẽ lưu 1 attribute trong session có tên 
 * là SPRING_SECURITY_SAVED_REQUEST, để sau khi login thành công, spring sẽ
 * đưa người dùng tới URL được lưu trong đó.
 */
public class SetUriInterceptor extends HandlerInterceptorAdapter {
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		HttpSession session = request.getSession();
		String currentURIAndQuery = request.getRequestURI();
		if(request.getQueryString() != null) {
			currentURIAndQuery = currentURIAndQuery + "?" + request.getQueryString();
		}
		session.setAttribute("currentURI", currentURIAndQuery);

		System.out.println("\n==================");
		System.out.println("[SetUriInterceptor] currentURIAndQuery = " + currentURIAndQuery);

		// chú ý: dù người dùng logout nhưng thuộc tính sau của session vẫn
		// tồn tại, khi người dùng login lại bằng tài khoản đó hoặc bất kỳ tài khoản nào
		// khác thì biến sau sẽ được update giá trị
		// System.out.println("[SetUriInterceptor] userId = " + MyUserDetailsService.userId);
		// System.out.println("[SetUriInterceptor] userFullname = " + MyUserDetailsService.userFullname);
		if(session.getAttribute("SPRING_SECURITY_CONTEXT") != null && session.getAttribute("userId") == null) {
			session.setAttribute("userId", MyUserDetailsService.userId);
			session.setAttribute("userFullname", MyUserDetailsService.userFullname);
			session.setAttribute("userRole", MyUserDetailsService.userRole);
		}

		System.out.println("[SetUriInterceptor] All of session attributes:");
		Enumeration<String> attEnum = session.getAttributeNames();
		while (attEnum.hasMoreElements()) {
			String attName = attEnum.nextElement();
			System.out.println("\t" + attName + " = " + session.getAttribute(attName));
		}
		return true;
	}
}