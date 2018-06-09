package hello.dao;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.support.JdbcDaoSupport;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import hello.model.MyUser;
import hello.util.EncryptPassword;

/*
 * Các lớp DAO (Data Access Object) là các lớp sử dụng để truy cập 
 * vào cơ sở dữ liệu, chẳng hạn Query, Insert, Update, Delete. Các
 * lớp DAO thường được chú thích bởi @Repository để nói với Spring
 * rằng hãy quản lý chúng như các Spring BEAN.
 * 
 * Lớp AppUserDAO sử dụng để thao tác với bảng APP_USER. Nó có một 
 * phương thức để tìm kiếm một người dùng trong Database ứng với 
 * tên đăng nhập nào đó.
 */
@Repository
@Transactional
public class MyUserDAO extends JdbcDaoSupport {
	@Autowired
	public MyUserDAO(DataSource dataSource) {
		this.setDataSource(dataSource);
	}

	public MyUser findUserAccount(String userName) {
		try {
			String sql = "SELECT u.id, u.username, u.email, u.fullname, u.encrypted_password, u.enabled "
					+ "FROM user u WHERE u.username = ?";
			return this.getJdbcTemplate().queryForObject(sql, new Object[] { userName }, 
					new MyUser.MyUserMapper());
		} catch (EmptyResultDataAccessException e) {
			return null;
		}
	}
	
	public String saveMyUser(MyUser myUser) {
		try {
			//reset counter trước:
			String resetCounter = "ALTER TABLE user AUTO_INCREMENT = 1";
			this.getJdbcTemplate().execute(resetCounter);
			
			String sql = "INSERT INTO `user` (`username`, `email`, `fullname`, `encrypted_password`) " +
						 "VALUES (?,?,?,?);\n";
			String encrytedPassword = EncryptPassword.encriptPassword(myUser.getPassword());
			int row = this.getJdbcTemplate().update(sql, myUser.getUsername(), myUser.getEmail(), 
									myUser.getFullname(), encrytedPassword);
			if(row > 0) return "OK";
			else return "fail";
		} catch (DuplicateKeyException e) {
			return "duplicate_key";
		} catch (Exception e) {
			e.printStackTrace();
			return e.getMessage();
		}
	}
}
