package hello.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.support.JdbcDaoSupport;
import org.springframework.stereotype.Repository;

import hello.model.Hotel;

@Repository
public class HotelDAO extends JdbcDaoSupport {

	@Autowired
	public HotelDAO(DataSource dataSource) {
		this.setDataSource(dataSource);
	}
	
	public List<Hotel> getAllHotels() {
		String sql = "SELECT * FROM hotel";
		//return this.getJdbcTemplate().queryForList(sql, Hotel.class);
		return this.getJdbcTemplate().query(sql, new HotelDAO.HotelMapper());
	}
	
	/**
	 * hotel mapper
	 * @author AnhTu
	 */
	public static class HotelMapper implements RowMapper<Hotel> {

		@Override
		public Hotel mapRow(ResultSet rs, int rowNum) throws SQLException {
			Hotel h = new Hotel();
			h.setId(Integer.valueOf(rs.getString("id")));
			h.setName(rs.getString("name"));
			//...
			
			return h;
		}
	}
}
