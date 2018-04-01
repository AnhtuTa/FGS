package hello.resolver;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.LocaleResolver;

/**
 * Get locale based on URL. Example:
 * localhost:8080/demo/en/home => locale = Locale.ENGLISH
 * localhost:8080/demo/vi/home => locale = new Locale("vi", "VN")
 */
public class UrlLocaleResolver implements LocaleResolver {
	private static final String URL_LOCALE_ATTRIBUTE_NAME = "URL_LOCALE_ATTRIBUTE_NAME";
	public static final String LOCALE_STRING = "localeString";
	
	@Override
	public Locale resolveLocale(HttpServletRequest request) {
		Locale locale = null;
		HttpSession session = request.getSession();
		
		String uri = request.getRequestURI();
		//System.out.println("uri = " + uri);
		
		String prefixEn = request.getServletContext().getContextPath() + "/en/";
		String prefixVi = request.getServletContext().getContextPath() + "/vi/";
		
		if(uri.startsWith(prefixEn)) {
			locale = Locale.ENGLISH;
			session.setAttribute(LOCALE_STRING, "en");
		} else if(uri.startsWith(prefixVi)) {
			locale = new Locale("vi", "VN");
			session.setAttribute(LOCALE_STRING, "vi");
		}
		//System.out.println("is locale = null?" + (locale==null));
		
		if(locale != null) {
			session.setAttribute(URL_LOCALE_ATTRIBUTE_NAME, locale);
		} else {
			locale = (Locale) session.getAttribute(URL_LOCALE_ATTRIBUTE_NAME);
			if(locale == null) {
				locale = Locale.ENGLISH;
				session.setAttribute(LOCALE_STRING, "en");
			}
		}
		
//		System.out.println("locale = " + locale);
//		System.out.println("session.getAttribute(LOCALE_STRING) = " + session.getAttribute(LOCALE_STRING));
		return locale;
	}

	@Override
	public void setLocale(HttpServletRequest request, HttpServletResponse response, Locale locale) {
		// do nothing
	}

}
