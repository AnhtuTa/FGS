package hello.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.support.JdbcDaoSupport;
import org.springframework.stereotype.Repository;

import hello.model.Hotel;
import hello.util.FormatPrice;

@Repository
public class HotelDAO extends JdbcDaoSupport {

	static FormatPrice fp = new FormatPrice();
	
	@Autowired
	public HotelDAO(DataSource dataSource) {
		this.setDataSource(dataSource);
	}
	
	public Hotel getHotel(long id) {
		String sql = "SELECT * FROM hotel WHERE id = ?";
		return this.getJdbcTemplate().query(sql, //
				new Object[] { id },	//
				new HotelDAO.HotelMapper()).get(0);
	}
	
	public List<Hotel> getAllHotels() {
		String sql = "SELECT * FROM hotel";
		//return this.getJdbcTemplate().queryForList(sql, Hotel.class);
		return this.getJdbcTemplate().query(sql, new HotelDAO.HotelMapper());
	}
	
	/*
	 * Lấy các field: id, price, tọa độ của các khác sạn
	 */
	public List<Hotel> getHotelIdPricesGeo() {
		String sql = "SELECT id, price, latitude, longitude FROM hotel";
		return this.getJdbcTemplate().query(sql, new HotelDAO.HotelIdPriceGeoMapper());
	}
	
	/*
	 * Hàm này cần tối ưu lại
	 */
	public Map<Long, Hotel> getAllHotelMap() {
		Map<Long, Hotel> htMap = new HashMap<>();
		List<Hotel> htList = getAllHotels();
		for(Hotel ht : htList) {
			htMap.put(ht.getId(), ht);
		}
		
		return htMap;
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
			h.setLatitude(rs.getString("latitude"));
			h.setLongitude(rs.getString("longitude"));
			h.setPriceString(fp.formatPrice(rs.getInt("price")));
			h.setStar(rs.getInt("star"));
			h.setReviewPoint(rs.getFloat("review_point"));
			h.setNumReviews(rs.getInt("num_reviews"));
			h.setImageUrl(rs.getString("image_url"));
			h.setHotelUrl(rs.getString("hotel_url"));
			h.setCity(rs.getString("city"));
			h.setStreet(rs.getString("street"));
			h.setDistrict(rs.getString("district"));
			h.setLatitude(rs.getString("latitude"));
			h.setLongitude(rs.getString("longitude"));
			
			return h;
		}
	}
	
	public static class HotelIdPriceGeoMapper implements RowMapper<Hotel> {

		@Override
		public Hotel mapRow(ResultSet rs, int rowNum) throws SQLException {
			Hotel h = new Hotel();
			h.setId(Integer.valueOf(rs.getString("id")));
			h.setPriceString(fp.formatPrice(rs.getInt("price")));
			h.setLatitude(rs.getString("latitude"));
			h.setLongitude(rs.getString("longitude"));
			return h;
		}
	}

//	public static void main(String[] args) {
//		org.springframework.jdbc.datasource.DriverManagerDataSource ds = new org.springframework.jdbc.datasource.DriverManagerDataSource();
//		ds.setDriverClassName("com.mysql.jdbc.Driver");
//	    ds.setUrl("jdbc:mysql://localhost:3306/guesthouse");
//	    ds.setUsername("root");
//	    ds.setPassword("");
//		
//	    HotelDAO hd = new HotelDAO(ds);
//	    List<Hotel> htList = hd.getAllHotels();
//	    System.out.println(htList);
//	    
//	    Map<Long, Hotel> htMap = new HashMap<>();
//	    htMap = hd.getAllHotelMap();
//	    System.out.println(htMap);
//	    
//	    Hotel h = hd.getHotel(7);
//	    System.out.println(h);
//	}
}
