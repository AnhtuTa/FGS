package hello.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import hello.dao.MyRoleDAO;
import hello.dao.MyUserDAO;
import hello.model.MyUser;

/*
 * UserDetailsService là một interface trung tâm trong Spring Security. 
 * Nó là một dịch vụ để tìm kiếm "Tài khoản người dùng và các vai trò của 
 * người dùng đó". Nó được sử dụng bởi Spring Security mỗi lần người dùng 
 * đăng nhập vào hệ thống. Chính vì vậy bạn cần viết một lớp thi hành 
 * (implements) interface này.
 * 
 * Ở đây tôi tạo lớp MyUserDetailsService thi hành (implements) interface 
 * UserDetailsService. Lớp  MyUserDetailsService được chú thích bởi 
 * @Service để nói với Spring rằng hãy quản lý nó như một Spring BEAN
 */

@Service
public class MyUserDetailsService implements UserDetailsService {

	@Autowired
	private MyUserDAO appUserDAO;

	@Autowired
	private MyRoleDAO appRoleDAO;
	
	public static String userFullname;

	/*
	 * Tham số truyền vào chỉ gồm có username của người dùng. Ta sẽ tìm kiếm trong
	 * CSDL, record thỏa mãn username. Nếu không tìm thấy, ta sẽ ném ra ngoại lệ
	 * UsernameNotFoundException.
	 * 
	 * Phương thức loadUserByUsername() sẽ trả về một implementation của UserDetails
	 * Implementation ở đây có thể là:
	 * org.springframework.security.core.userdetails.User, YourCustomUserDetails
	 * implements org.springframework.security.userdetails.UserDetails
	 */
	@Override
	public UserDetails loadUserByUsername(String userName) throws UsernameNotFoundException {
		MyUser myUser = appUserDAO.findUserAccount(userName);

		if (myUser == null) {
			throw new UsernameNotFoundException("User " + userName + " was not found in the DB");
		}

		List<String> roles = appRoleDAO.getRoleNames(myUser.getId());
		List<GrantedAuthority> grantList = new ArrayList<>();
		if (roles != null && roles.size() != 0) {
			for (String role : roles) {
				grantList.add(new SimpleGrantedAuthority(role));
				System.out.println("role = " + role);
			}
		}

		//Ko thể get session ở đây, vì lỗi, ko fix được!
		//HttpSession session = request.getSession(true);
		//session.setAttribute("userFullName", myUser.getFullname());
		userFullname = myUser.getFullname();

		System.out.println("[MyUserDetailsService] userFullname = " + userFullname);
		return (UserDetails) new User(myUser.getUsername(), myUser.getPassword(), grantList);
	}

}
