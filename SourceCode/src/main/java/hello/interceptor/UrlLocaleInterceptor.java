package hello.interceptor;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import org.springframework.web.servlet.support.RequestContextUtils;

/*
 * Interceptor này sẽ xác định locale dựa trên URL, VD:
 * /en/home nghĩa là locale = English
 * /vi/home nghĩa là locale = Vietnamese
 */
public class UrlLocaleInterceptor extends HandlerInterceptorAdapter {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		// Việc tính toán locale đã do class UrlLocaleResolver thực hiện
		LocaleResolver localeResolver = RequestContextUtils.getLocaleResolver(request);
		
		if(localeResolver == null) {
			throw new IllegalStateException("No LocaleResolver found: not in a DispatcherServlet request?");
		}
		
		// Lấy ra thông tin Locale từ LocaleResolver
		Locale locale = localeResolver.resolveLocale(request);
		localeResolver.setLocale(request, response, locale);
		return true;
	}
}
