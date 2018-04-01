package hello.dao;

import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.support.JdbcDaoSupport;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
@Transactional
public class MyRoleDAO extends JdbcDaoSupport {
	@Autowired
	public MyRoleDAO(DataSource dataSource) {
		this.setDataSource(dataSource);
	}
	
	public List<String> getRoleNames(Long userId) {
		String sql = "SELECT r.name " +
					 "FROM user_role ur, role r "  +
					 "WHERE ur.role_id = r.id " +
					 "AND ur.user_id = ?";
		return this.getJdbcTemplate()
			.queryForList(sql, new Object[] {userId}, String.class);
	}
}
