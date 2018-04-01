package hello.model;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.hibernate.validator.constraints.Email;
import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotBlank;
import org.springframework.jdbc.core.RowMapper;

import hello.validator.MyPassword;

public class MyUser {
	Long id;
	
	@Length(min=6, max=20)	//Nếu sửa đổi số ở đây, thì phải sửa ở trong các file message.properties
	String username;
	
	@NotBlank
	@Email
	String email;
	
	@NotBlank
	String fullname;
	
	//Nếu lỗi xảy ra thì message sẽ đc lấy từ file message.properties
	//Chú ý: cú pháp của message trong file message.properties là:
	//[ConstraintName].[ClassName].[FieldName]=[your message]
	@MyPassword
	String password;	// trong database thì là field: encrypted_password
	
	String confirmPassword;
	int enabled;
	
	public MyUser() {}

	//constructor này cho thằng mapper ở dưới, nên nó chỉ cần những field mà trong database có
	public MyUser(Long id, String username, String email, String fullname, String password, int enabled) {
		super();
		this.id = id;
		this.username = username;
		this.email = email;
		this.fullname = fullname;
		this.password = password;
		this.enabled = enabled;
	}


	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getFullname() {
		return fullname;
	}

	public void setFullname(String fullname) {
		this.fullname = fullname;
	}
	
	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getConfirmPassword() {
		return confirmPassword;
	}

	public void setConfirmPassword(String confirmPassword) {
		this.confirmPassword = confirmPassword;
	}

	public int getEnabled() {
		return enabled;
	}

	public void setEnabled(int enabled) {
		this.enabled = enabled;
	}

	public static class MyUserMapper implements RowMapper<MyUser> {

		@Override
		public MyUser mapRow(ResultSet rs, int rowNum) throws SQLException {
			return new MyUser(rs.getLong("id"), rs.getString("username"), rs.getString("email"),
					rs.getString("fullname"), rs.getString("encrypted_password"), rs.getInt("enabled"));
		}

	}
}
