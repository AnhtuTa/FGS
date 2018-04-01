package hello.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
//import org.springframework.security.web.firewall.HttpFirewall;
//import org.springframework.security.web.firewall.StrictHttpFirewall;

import hello.service.MyUserDetailsService;

/*
 * Ứng dụng này có một vài chức năng (trang), trong đó:
	/userInfo
	Đây là trang xem thông tin người dùng, trang này đòi hỏi người dùng phải đăng nhập, 
	và có vai trò ROLE_ADMIN hoặc ROLE_USER.
	
	/admin
	Đây là trang dành cho người quản trị, yêu cầu người dùng phải đăng nhập, 
	và chỉ những người có vai trò ROLE_ADMIN mới có quyền truy cập.
	
	/. /welcome, /login, /logout, /403
	Tất cả các trang khác trong ứng dụng không đòi hỏi người dùng phải đăng nhập.
	
	Lớp WebSecurityConfig được sử dụng để cấu hình bảo mật cho ứng dụng. 
	Nó được chú thích (annotate) bởi @Configuration, Annotation này nói với
	Spring rằng nó là một lớp cấu hình, và vì vậy nó sẽ được Spring phân
	tích tại thời điểm ứng dụng được chạy.

 */

@Configuration
@EnableWebSecurity
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {
	@Autowired
	MyUserDetailsService myUerDetailsService;

	@Autowired
	public void configureGlobal(AuthenticationManagerBuilder auth) throws Exception {
		// Sét đặt dịch vụ để tìm kiếm User trong Database.
		// Và sét đặt PasswordEncoder.
		auth.userDetailsService(myUerDetailsService).passwordEncoder(new BCryptPasswordEncoder());

	}

	@Override
	protected void configure(HttpSecurity http) throws Exception {

		http.csrf().disable();

		// Các trang không yêu cầu login
		// ko cần nêu ra cũng đc!
		// http.authorizeRequests().antMatchers("/", "/login", "/logout").permitAll();

		// Tất cả các trang bắt đầu = /userInfo yêu cầu phải login với vai trò ROLE_USER hoặc ROLE_ADMIN.
		// Nếu chưa login, nó sẽ redirect tới trang /login.
		http.authorizeRequests().antMatchers("/en/user_info/**", "/vi/user_info/**", "/user_info/**")
			.access("hasAnyRole('ROLE_USER', 'ROLE_ADMIN')");

		// Tất cả các trang chỉ dành cho ADMIN
		// Nếu chưa login, nó cũng redirect tới trang /login.
		http.authorizeRequests().antMatchers("/en/admin/**", "/vi/admin/**", "/admin/**")
			.access("hasRole('ROLE_ADMIN')");

		// Khi người dùng đã login, với vai trò XX.
		// Nhưng truy cập vào trang yêu cầu vai trò YY,
		// Ngoại lệ AccessDeniedException sẽ ném ra.
		http.authorizeRequests().and().exceptionHandling().accessDeniedPage("/403");

		// Cấu hình cho Login Form.
		// CHÚ Ý: sau khi login thành công thì trang web sẽ đi tới trang trước khi người dùng
		// vào trang login. Nếu ko tồn tại trang ý thì nó sẽ đi tới /user_info (định nghĩa ở dưới)
		http.authorizeRequests().and().formLogin()//
				// Submit URL của trang login
				.loginProcessingUrl("/j_spring_security_check") // Submit URL
				.loginPage("/login")//
				.defaultSuccessUrl("/user_info")//
				.failureUrl("/login?error=true")//
				.usernameParameter("username")//
				.passwordParameter("password")
				// Cấu hình cho Logout Page.
				.and().logout().logoutUrl("/logout").logoutSuccessUrl("/logout_successful");

	}

	// Just for testing BCryptPasswordEncoder
//	public static void main(String[] args) {
//		String password = "123";
//		String encrytedPassword = new BCryptPasswordEncoder().encode(password);
//
//		System.out.println("Encryted Password: " + encrytedPassword);
//	}
}
