package hello.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.PreparedStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.support.JdbcDaoSupport;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import hello.crawler.AddressToLatlng;
import hello.model.Hotel;
import hello.model.MyAddress;
import hello.util.FormatPrice;

@Repository
public class HotelDAO extends JdbcDaoSupport {

	static FormatPrice fp = new FormatPrice();
	
	@Autowired
	public HotelDAO(DataSource dataSource) {
		this.setDataSource(dataSource);
	}
	
	/**
	 * Khi chạy riêng file crawler thì cần hàm sau
	 */
	public HotelDAO() {
		org.springframework.jdbc.datasource.DriverManagerDataSource ds = new org.springframework.jdbc.datasource.DriverManagerDataSource();
		ds.setDriverClassName("com.mysql.cj.jdbc.Driver");
	    ds.setUrl("jdbc:mysql://localhost:3306/guesthouse?characterEncoding=utf8");
	    ds.setUsername("root");
	    ds.setPassword("5555");
		this.setDataSource(ds);
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
	
	/**
	 * Lấy các hotel để hiển thị sau khi người dùng search (tại trang chủ)
	 * @param fieldName trùng với tên 1 cột trong CSDL
	 * @param fieldValue giá trị của cột trên trong CSDL
	 * @param lowPrice
	 * @param highPrice
	 * @param stars mảng 5 phần tử, tương ứng với số sao của khách sạn. VD: stars[] = {false, true, true, false, true} nghĩa là chọn hotel có (star = 2 or star = 3 or star = 5) 
	 * @param start
	 * @param nums
	 * @return
	 */
    public List<Hotel> getHotelsByFieldAtHomePage(String fieldName, String fieldValue, int lowPrice, int highPrice, boolean []stars, int start, int nums) {
        String sql = "SELECT id, name, avatar, street, district, city, star, review_point, num_reviews, price " +
                "FROM hotel WHERE " + fieldName + " LIKE '%" + fieldValue + "%'";
        if(lowPrice != 0 || highPrice != 30000000) {
            sql = sql + " AND price >= " + lowPrice + " AND price <= " + highPrice;
        }
        
        for(int i = 0; i < 5; i++) {
        	if(stars[i]) {
        		sql = sql + " AND (star = " + (i+1);
        		for(int j = i+1; j < 5; j++) {
        			if(stars[j]) sql = sql + " OR star = " + (j+1);
        		}
        		sql += ")";
        		break;
        	}
        }
        
        sql = sql + " LIMIT " + start + ", " + nums;
        System.out.println("[HotelDAO][getHotelsByFieldAtHomePage] sql = " + sql);
        return this.getJdbcTemplate().query(sql, new HotelDAO.HotelHomePageMapper());
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

	/*
	 * Nếu review ko crawl từ trang web khác thì ko insert các field: review, review point,...
	 */
	public long insertHotel(Hotel h) {
		String sql = "INSERT INTO hotel(hotel_id, name, star, avatar, hotel_url, image_urls, street, "
				+ "district, city, latitude, longitude, review_point, num_reviews, price, type) "
				+ "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		String [] params = {h.getHotelId()+"", h.getName(), h.getStar()+"", h.getAvatar(),
				h.getHotelUrl(), h.getImageUrlsString(), h.getStreet(), h.getDistrict(),
				h.getCity(), h.getLatitude(), h.getLongitude(), h.getReviewPoint()+"",
				h.getNumReviews()+"", h.getPrice()+"", "hotel"};
		
		KeyHolder keyHolder = new GeneratedKeyHolder();
		getJdbcTemplate().update(
    	    new PreparedStatementCreator() {
    	        public PreparedStatement createPreparedStatement(Connection con) throws SQLException {
    	            PreparedStatement pst =
    	                con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
    	            	for(int i=0; i<params.length; i++) {
    	            		pst.setNString(i+1, params[i]);
    	            	}
    	            return pst;
    	        }
    	    },
    	    keyHolder);
    	return Long.valueOf(keyHolder.getKey() + "");
	}
	
	/*
	 * Nếu review ko crawl từ trang web khác thì ko update các field: review, review point,...
	 */
	public boolean updateHotel(Hotel h) {
		try {
			String sql = "UPDATE hotel SET name=?, star=?, avatar=?, hotel_url=?, image_urls=?, street=?, "
					+ "district=?, city=?, latitude=?, longitude=?, review_point=?, num_reviews=?, price=? "
					+ "WHERE hotel_id=?";
			Object [] params = {h.getName(), h.getStar()+"", h.getAvatar(),
					h.getHotelUrl(), h.getImageUrlsString(), h.getStreet(), h.getDistrict(),
					h.getCity(), h.getLatitude(), h.getLongitude(), h.getReviewPoint()+"",
					h.getNumReviews()+"", h.getPrice()+"", h.getHotelId()+""};
			
			getJdbcTemplate().update(sql, params);
	    	return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
	
	public boolean insertHotelBatch(List<Hotel> htList) {
		String sql = "INSERT INTO hotel(hotel_id, name, star, avatar, hotel_url, image_urls, street, "
				+ "district, city, latitude, longitude, review_point, num_reviews, price, type) "
				+ "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		List<Object[]> paramList = new LinkedList<>();
		MyAddress myAddress;
		
		for(Hotel h : htList) {
			// Dùng google API để lấy giá trị lat, lng... từ raw address
			myAddress = AddressToLatlng.address2coordinate(h.getRawAddress());
			if(myAddress != null && myAddress.getCity() != null) {
				try {
					h.setStreet(myAddress.getStreet());
					h.setDistrict(myAddress.getDistrict());
					h.setCity(myAddress.getCity());
					h.setLatitude(myAddress.getLatitude());
					h.setLongitude(myAddress.getLongitute());
				} catch (Exception e2) {
					e2.printStackTrace();
				}
			}
			
			paramList.add(new Object[] {h.getHotelId()+"", h.getName(), h.getStar()+"", h.getAvatar(),
					h.getHotelUrl(), h.getImageUrlsString(), h.getStreet(), h.getDistrict(),
					h.getCity(), h.getLatitude(), h.getLongitude(), h.getReviewPoint()+"",
					h.getNumReviews()+"", h.getPrice()+"", "hotel"});
		}
		try {
			getJdbcTemplate().batchUpdate(sql, paramList);
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}
	
	public boolean updateHotelBatch(List<Hotel> htList) {
		String sql = "UPDATE hotel SET name=?, star=?, avatar=?, hotel_url=?, image_urls=?, review_point=?, num_reviews=?, price=? "
				+ "WHERE hotel_id=?";
		List<Object[]> paramList = new LinkedList<>();
		for(Hotel h : htList) {
			paramList.add(new Object[] {h.getName(), h.getStar()+"", h.getAvatar(),
					h.getHotelUrl(), h.getImageUrlsString(), h.getReviewPoint()+"",
					h.getNumReviews()+"", h.getPrice()+"", h.getHotelId()+""});
		}
		try {
			getJdbcTemplate().batchUpdate(sql, paramList);
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}
	
	public boolean upsertHotel(List<Hotel> hotelList) {
		List<Hotel> insertedHotelList = new LinkedList<>();
		List<Hotel> updatedHotelList = new LinkedList<>();

		for(Hotel h : hotelList) {
			if(checkExistHotel(h.getHotelId()) == 0) {
				//if h doesn't exist in DB: insert h
				insertedHotelList.add(h);
			} else {
				//else: update h
				updatedHotelList.add(h);
			}
		}
		
		return insertHotelBatch(insertedHotelList) && updateHotelBatch(updatedHotelList);
	}
	
	public int checkExistHotel(long hotelId) {
		String sql = "SELECT EXISTS (SELECT 1 FROM hotel WHERE hotel_id = ?)";
		return getJdbcTemplate().queryForObject(sql, new Object[] { hotelId }, Integer.class);
	}
	
	/**
	 * hotel mapper
	 * @author AnhTu
	 */
	public static class HotelMapper implements RowMapper<Hotel> {

		@Override
		public Hotel mapRow(ResultSet rs, int rowNum) throws SQLException {
			List<String> imageUrls = new ArrayList<>();
			String imageUrlString = rs.getString("image_urls");
			if(imageUrlString != null) {
				StringTokenizer tokenizer = new StringTokenizer(imageUrlString, "|");
				while(tokenizer.hasMoreTokens()) {
					imageUrls.add(tokenizer.nextToken());
				}
			}
			
			Hotel h = new Hotel();
			h.setId(Long.valueOf(rs.getString("id")));
			h.setHotelId(rs.getLong("hotel_id"));
			if(rs.getString("name") != null) h.setName(rs.getString("name"));
			h.setStar(rs.getInt("star"));
			if(rs.getString("avatar") != null) h.setAvatar(rs.getString("avatar"));
			if(rs.getString("hotel_url") != null) h.setHotelUrl(rs.getString("hotel_url"));
			h.setImageUrls(imageUrls);
			if(rs.getString("street") != null) h.setStreet(rs.getString("street"));
			if(rs.getString("district") != null) h.setDistrict(rs.getString("district"));
			if(rs.getString("city") != null) h.setCity(rs.getString("city"));
			if(rs.getString("latitude") != null) h.setLatitude(rs.getString("latitude"));
			if(rs.getString("longitude") != null) h.setLongitude(rs.getString("longitude"));
			h.setReviewPoint(rs.getFloat("review_point"));
			h.setNumReviews(rs.getInt("num_reviews"));
			h.setPrice(rs.getInt("price"));
			
			return h;
		}
	}
	
	public static class HotelIdPriceGeoMapper implements RowMapper<Hotel> {

		@Override
		public Hotel mapRow(ResultSet rs, int rowNum) throws SQLException {
			Hotel h = new Hotel();
			h.setId(Integer.valueOf(rs.getString("id")));
			h.setPrice(rs.getInt("price"));
			h.setLatitude(rs.getString("latitude"));
			h.setLongitude(rs.getString("longitude"));
			return h;
		}
	}
	
	public static class HotelHomePageMapper implements RowMapper<Hotel> {

		@Override
		public Hotel mapRow(ResultSet rs, int rowNum) throws SQLException {
			Hotel h = new Hotel();
			h.setId(Long.valueOf(rs.getString("id")));
			h.setName(rs.getString("name"));
			h.setAvatar(rs.getString("avatar"));
			h.setStreet(rs.getString("street"));
			h.setDistrict(rs.getString("district"));
			h.setCity(rs.getString("city"));
			h.setStar(rs.getInt("star"));
			h.setReviewPoint(rs.getFloat("review_point"));
			h.setNumReviews(rs.getInt("num_reviews"));
			h.setPrice(rs.getInt("price"));
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
