package hello.config;

import org.springframework.context.MessageSource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.ReloadableResourceBundleMessageSource;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewResolverRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;
import org.springframework.web.servlet.view.InternalResourceViewResolver;
import org.springframework.web.servlet.view.JstlView;

import hello.interceptor.SetUriInterceptor;
import hello.interceptor.UrlLocaleInterceptor;
import hello.resolver.UrlLocaleResolver;

@Configuration
// không cần bọn sau vì Spring boot đã config hết rồi!
@EnableWebMvc
// @ComponentScan
public class WebMvcConfig extends WebMvcConfigurerAdapter {

	/**
	 * To resolve JSP files location, you can have two approaches. 1) Add entries in
	 * application.properties 2) Configure InternalResourceViewResolver, like this:
	 */
	@Override
	public void configureViewResolvers(ViewResolverRegistry registry) {
		InternalResourceViewResolver viewResolver = new InternalResourceViewResolver();
		viewResolver.setPrefix("/WEB-INF/pages/");
		viewResolver.setSuffix(".jsp");
		viewResolver.setViewClass(JstlView.class);
		registry.viewResolver(viewResolver);
	}

	@Bean(name = "messageSource")
	public MessageSource getMessageResource() {
		ReloadableResourceBundleMessageSource messageResource = new ReloadableResourceBundleMessageSource();

		// Đọc vào file i18n/messages_xxx.properties
		// Ví dụ: i18n/message_en.properties
		messageResource.setBasename("classpath:i18n/messages");
		messageResource.setDefaultEncoding("UTF-8");
		return messageResource;
	}

	// To solver URL like:
	// /SomeContextPath/en/login2xyz
	// /SomeContextPath/vi/loginabc
	@Bean(name = "localeResolver")
	public LocaleResolver getLocaleResolver() {
		LocaleResolver resolver = new UrlLocaleResolver();
		return resolver;
	}

	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		UrlLocaleInterceptor localeInterceptor = new UrlLocaleInterceptor();
		registry.addInterceptor(localeInterceptor).addPathPatterns("/en/*", "/fr/*", "/vi/*");

		// interceptor này được áp dụng cho mọi request đang tiến đến một Controller
		registry.addInterceptor(new SetUriInterceptor());
	}

	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
		registry.addResourceHandler("/css/**").addResourceLocations("/static/css/");
		registry.addResourceHandler("/js/**").addResourceLocations("/static/js/");
		registry.addResourceHandler("/img/**").addResourceLocations("/static/img/");
		
	}

}
